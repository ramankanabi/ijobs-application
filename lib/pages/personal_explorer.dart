import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iraqijob/pages/login_page.dart';
import 'package:iraqijob/pages/search.dart';
import 'package:iraqijob/widget/advertise_post.dart';
import 'package:iraqijob/widget/job_post.dart';
import 'package:iraqijob/widget/job_post_loader.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import '../widget/textfield_search_packages.dart' as auto;
import 'package:badges/badges.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PersonalExplorer extends StatefulWidget {
  @override
  _PersonalExplorerState createState() => _PersonalExplorerState();
}

class _PersonalExplorerState extends State<PersonalExplorer>
    with AutomaticKeepAliveClientMixin<PersonalExplorer> {
  QuerySnapshot doc;
  List<DocumentSnapshot> postData = [];
  bool isLoading = false;
  GlobalKey<ScaffoldState> scafKey = GlobalKey();
  GlobalKey<ScaffoldState> scafKey3 = GlobalKey();
  ScrollController controller = ScrollController();
  DocumentSnapshot skipDoc;
  DocumentSnapshot lengthDoc;
  bool moreDoc = true;
  bool showErrorText = false;
  ///////////////// drawer ///////////////////
  TextEditingController cityController = TextEditingController();
  TextEditingController companyTypeController = TextEditingController();
  GlobalKey<ScaffoldState> scafKey2 = GlobalKey();
  String secondDrawer = "";
  int firstSalary;
  int secondSalary;
  String city;
  String genderpressed;
  String salaryPressed;
  String companyType;
  bool cityValidate = true;
  bool companyTypeValidate = true;
  bool isShowBadge = false;
  RegExp validateSpace = RegExp(r"^[\s]+$");
  List<String> citySuggetions = [
     "al anbar",
    "al najaf",
    "al fallujah",
    "al muthanna",
    "al basrah",
    "al qadisiyah",
    "babil",
    "baghdad",
    "duhok",
    "diyala",
    "hawler",
    "halabja",
    "karbala",
    "kirkuk",
    "misan",
    "mosul",
    "ninewa",
    "sulaymani",
    "thi qar",
  ];

  List<String> types = [
   "airline company",
    "car company",
    "cafe",
    "cleaning service company",
    "clothing company",
    "computer store",
    "concrete factory",
    "construction company",
    "delivery service",
    "educational segments",
    "electric company",
    "finance and banking company",
    "food company",
    "furniture company",
    "glass industrial",
    "market",
    "media company",
    "medical group",
    "mobile store",
    "oil company",
    "print shop",
    "restaurant",
    "shopping mall",
    "software company",
    "steel company",
    "telecommunication company",
    "transportation service",
    "other",
  ];

  /////////////////////////////////////////////
  @override
  void initState() {
    try {
      setState(() {
        isLoading = true;
      });
      controller.addListener(() {
        // var maxScroll = controller.position.maxScrollExtent;
        // var currentPos = controller.position.pixels;
        // var delta = MediaQuery.of(context).size.height * 0.25;

        if (controller.position.maxScrollExtent == controller.position.pixels) {
          if (city == null && genderpressed == null && companyType == null) {
            setDoc();
          } else {
            setFilterDoc();
          }
        }
      });

      getDoc();

      setState(() {
        isLoading = false;
      });
    } catch (er) {}
    super.initState();
  }

  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ScreenUtil.init(designSize: Size(360, 640), allowFontScaling: true);
    return Scaffold(
      key: scafKey,
      endDrawer: drawer(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text(
          "Explorer",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        elevation: 0.5,
        actions: <Widget>[
          IconButton(
              icon: Icon(OMIcons.search, color: Colors.blue),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => SearchPage(),
                  ),
                );
              }),
          Badge(
              badgeColor: Colors.red,
              showBadge: isShowBadge ? true : false,
              child: IconButton(
                  icon: Icon(OMIcons.filterList, color: Colors.blue),
                  onPressed: () {
                    scafKey.currentState.openEndDrawer();
                  }),
              position: BadgePosition.topRight(
                right: 10,
                top: 15,
              ))
        ],
      ),
      body: RefreshIndicator(
                  onRefresh: () => onRefresh(),
                  child: showErrorText
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "At now in there does't have any jobs hiring .",
                        style: TextStyle(
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                  )
                : isLoading == true || postData == null
            ? SingleChildScrollView(
                          child: Column(
                children: [
                  JobPostLoader(isMyJob:true),
                ],
              ),
            )
            : (ListView.builder(
              controller: controller,
              itemCount: postData.length,
              itemBuilder: (ctx, i) {
                return Card(
                    elevation: 1,
                    child: postData[i]["isAdvertise"]
                        ? AdvertisePost.fromDocument(postData[i])
                        : JobPost.fromDocument(
                            postData[i],
                          ));
              },
            )),
      ),
    );
  }

  drawer() {
    return Drawer(
      child: Scaffold(
        key: scafKey2,
        appBar: AppBar(
          actions: <Widget>[
            FlatButton(
              child: Text(
                "reset",
                style: TextStyle(
                  color: city == null &&
                          genderpressed == null &&
                          companyType == null
                      ? Colors.grey
                      : Colors.blue,
                ),
              ),
              onPressed:
                  companyType == null && city == null && genderpressed == null
                      ? () {}
                      : () async {
                          companyType = null;
                          city = null;
                          salaryPressed = null;
                          genderpressed = null;
                          setState(() {
                            isShowBadge = false;
                          });
                          getFilterDoc();
                        },
            )
          ],
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Text(
            "Filtering Job Hiring",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: ScreenUtil().setSp(15),
            ),
          ),
          elevation: 0.5,
        ),
        backgroundColor: Colors.white,
        endDrawer: secondDrawer == "city"
            ? cityDrawer()
            : secondDrawer == "gender" ? genderDrawer() : companyTypeDrawer(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Column(children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 0.5,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  child: ListTile(
                      title: Text("Company Types"),
                      subtitle: companyType == null
                          ? null
                          : Text(
                              companyType,
                              style: TextStyle(color: Colors.blue),
                            ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          try {
                            setState(() {
                              secondDrawer = "companyType";
                            });
                            scafKey2.currentState.openEndDrawer();
                          } catch (er) {}
                        },
                      ),
                      onTap: () {
                        try {
                          setState(() {
                            secondDrawer = "companyType";
                          });
                          scafKey2.currentState.openEndDrawer();
                        } catch (er) {}
                      }),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 0.5,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  child: ListTile(
                      title: Text("City"),
                      subtitle: city == null
                          ? null
                          : Text(
                              city,
                              style: TextStyle(color: Colors.blue),
                            ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          try {
                            setState(() {
                              secondDrawer = "city";
                            });
                            scafKey2.currentState.openEndDrawer();
                          } catch (er) {}
                        },
                      ),
                      onTap: () {
                        try {
                          setState(() {
                            secondDrawer = "city";
                          });
                          scafKey2.currentState.openEndDrawer();
                        } catch (er) {}
                      }),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 0.5,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  child: ListTile(
                    title: Text("Gender"),
                    subtitle: genderpressed == null
                        ? null
                        : Text(
                            genderpressed,
                            style: TextStyle(color: Colors.blue),
                          ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        try {
                          setState(() {
                            secondDrawer = "gender";
                          });
                          scafKey2.currentState.openEndDrawer();
                        } catch (er) {}
                      },
                    ),
                    onTap: () {
                      try {
                        setState(() {
                          secondDrawer = "gender";
                        });
                        scafKey2.currentState.openEndDrawer();
                      } catch (er) {}
                    },
                  ),
                ),
              ]),
            ),
            GestureDetector(
              onTap: () {
                try {
                  setState(() {
                    isLoading = true;
                  });
                  getFilterDoc();
                  if (city != null ||
                      companyType != null ||
                      genderpressed != null ||
                      salaryPressed != null) {
                    setState(() {
                      isShowBadge = true;
                    });
                  } else {
                    setState(() {
                      isShowBadge = false;
                    });
                  }
                  setState(() {
                    isLoading = false;
                  });

                  Navigator.pop(context);
                } catch (er) {}
              },
              child: Container(
                  color: Theme.of(context).primaryColor,
                  height: ScreenUtil().setHeight(50),
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      "Apply",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }

  getFilterDoc() async {
    try {
      setState(() {
        postData = null;
        showErrorText = false;
      });
      if (companyType == null && city == null && genderpressed == null) {
        getDoc();
      } else if (city != null && genderpressed == null && companyType == null) {
        doc = await jobRef
            .where(
              "city",
              isEqualTo: city,
            )
            .orderBy("isVIP", descending: true)
            .orderBy("dateTime", descending: true)
            .limit(7)
            .getDocuments();
        QuerySnapshot adDoc;
        if (doc.documents.length != 0) {
          adDoc = await advertiseRef
              .where("index",
                  isGreaterThanOrEqualTo:
                      Random().nextInt(lengthDoc.data["length"] + 1))
              .limit(1)
              .getDocuments();

          if (adDoc.documents.length == 0) {
            adDoc = await advertiseRef
                .where("index",
                    isGreaterThanOrEqualTo:
                        Random().nextInt(lengthDoc.data["length"] + 1))
                .limit(1)
                .getDocuments();
          }
          setState(() {
            postData = doc.documents;
            postData.addAll(adDoc.documents);
          });
        }
        if (doc.documents.length == 0) {
          setState(() {
            showErrorText = true;
          });
        }
      } else if (city == null && genderpressed != null && companyType == null) {
        doc = await jobRef
            .where(
              "gender",
              isEqualTo: genderpressed,
            )
            .orderBy("isVIP", descending: true)
            .orderBy("dateTime", descending: true)
            .limit(7)
            .getDocuments();
        QuerySnapshot adDoc;
        if (doc.documents.length != 0) {
          adDoc = await advertiseRef
              .where("index",
                  isGreaterThanOrEqualTo:
                      Random().nextInt(lengthDoc.data["length"] + 1))
              .limit(1)
              .getDocuments();

          if (adDoc.documents.length == 0) {
            adDoc = await advertiseRef
                .where("index",
                    isGreaterThanOrEqualTo:
                        Random().nextInt(lengthDoc.data["length"] + 1))
                .limit(1)
                .getDocuments();
          }
          setState(() {
            postData = doc.documents;
            postData.addAll(adDoc.documents);
          });
        }
        if (doc.documents.length == 0) {
          setState(() {
            showErrorText = true;
          });
        }
      } else if (city == null && genderpressed == null && companyType != null) {
        doc = await jobRef
            .where("typeCompany", isEqualTo: companyType)
            .orderBy("isVIP", descending: true)
            .orderBy("dateTime", descending: true)
            .limit(7)
            .getDocuments();
        QuerySnapshot adDoc;
        if (doc.documents.length != 0) {
          adDoc = await advertiseRef
              .where("index",
                  isGreaterThanOrEqualTo:
                      Random().nextInt(lengthDoc.data["length"] + 1))
              .limit(1)
              .getDocuments();

          if (adDoc.documents.length == 0) {
            adDoc = await advertiseRef
                .where("index",
                    isGreaterThanOrEqualTo:
                        Random().nextInt(lengthDoc.data["length"] + 1))
                .limit(1)
                .getDocuments();
          }
          setState(() {
            postData = doc.documents;
            postData.addAll(adDoc.documents);
          });
        }

        if (doc.documents.length == 0) {
          setState(() {
            showErrorText = true;
          });
        }
      } else if (city != null && genderpressed != null && companyType == null) {
        doc = await jobRef
            .where("gender", isEqualTo: genderpressed)
            .where("city", isEqualTo: city)
            .orderBy("isVIP", descending: true)
            .orderBy("dateTime", descending: true)
            .limit(7)
            .getDocuments();
        QuerySnapshot adDoc;
        if (doc.documents.length != 0) {
          adDoc = await advertiseRef
              .where("index",
                  isGreaterThanOrEqualTo:
                      Random().nextInt(lengthDoc.data["length"] + 1))
              .limit(1)
              .getDocuments();

          if (adDoc.documents.length == 0) {
            adDoc = await advertiseRef
                .where("index",
                    isGreaterThanOrEqualTo:
                        Random().nextInt(lengthDoc.data["length"] + 1))
                .limit(1)
                .getDocuments();
          }
          setState(() {
            postData = doc.documents;
            postData.addAll(adDoc.documents);
          });
        }
        if (doc.documents.length == 0) {
          setState(() {
            showErrorText = true;
          });
        }
      } else if (city != null && genderpressed == null && companyType != null) {
        doc = await jobRef
            .where("typeCompany", isEqualTo: companyType)
            .where("city", isEqualTo: city)
            .orderBy("isVIP", descending: true)
            .orderBy("dateTime", descending: true)
            .limit(7)
            .getDocuments();

        QuerySnapshot adDoc;
        if (doc.documents.length != 0) {
          adDoc = await advertiseRef
              .where("index",
                  isGreaterThanOrEqualTo:
                      Random().nextInt(lengthDoc.data["length"] + 1))
              .limit(1)
              .getDocuments();

          if (adDoc.documents.length == 0) {
            adDoc = await advertiseRef
                .where("index",
                    isGreaterThanOrEqualTo:
                        Random().nextInt(lengthDoc.data["length"] + 1))
                .limit(1)
                .getDocuments();
          }
          setState(() {
            postData = doc.documents;
            postData.addAll(adDoc.documents);
          });
        }

        if (doc.documents.length == 0) {
          setState(() {
            showErrorText = true;
          });
        }
      } else if (city == null && genderpressed != null && companyType != null) {
        doc = await jobRef
            .where("typeCompany", isEqualTo: companyType)
            .where("gender", isEqualTo: genderpressed)
            .orderBy("isVIP", descending: true)
            .orderBy("dateTime", descending: true)
            .limit(7)
            .getDocuments();

        QuerySnapshot adDoc;
        if (doc.documents.length != 0) {
          adDoc = await advertiseRef
              .where("index",
                  isGreaterThanOrEqualTo:
                      Random().nextInt(lengthDoc.data["length"] + 1))
              .limit(1)
              .getDocuments();

          if (adDoc.documents.length == 0) {
            adDoc = await advertiseRef
                .where("index",
                    isGreaterThanOrEqualTo:
                        Random().nextInt(lengthDoc.data["length"] + 1))
                .limit(1)
                .getDocuments();
          }
          setState(() {
            postData = doc.documents;
            postData.addAll(adDoc.documents);
          });
        }
        if (doc.documents.length == 0) {
          setState(() {
            showErrorText = true;
          });
        }
      } else if (city != null && genderpressed != null && companyType != null) {
        doc = await jobRef
            .where("typeCompany", isEqualTo: companyType)
            .where("gender", isEqualTo: genderpressed)
            .where("city", isEqualTo: city)
            .orderBy("isVIP", descending: true)
            .orderBy("dateTime", descending: true)
            .limit(7)
            .getDocuments();

        QuerySnapshot adDoc;
        if (doc.documents.length != 0) {
          adDoc = await advertiseRef
              .where("index",
                  isGreaterThanOrEqualTo:
                      Random().nextInt(lengthDoc.data["length"] + 1))
              .limit(1)
              .getDocuments();

          if (adDoc.documents.length == 0) {
            adDoc = await advertiseRef
                .where("index",
                    isGreaterThanOrEqualTo:
                        Random().nextInt(lengthDoc.data["length"] + 1))
                .limit(1)
                .getDocuments();
          }
          setState(() {
            postData = doc.documents;
            postData.addAll(adDoc.documents);
          });
        }

        if (doc.documents.length == 0) {
          setState(() {
            showErrorText = true;
          });
        }
      }

      if (doc.documents.length != 0) {
        setState(() {
          skipDoc = doc.documents[doc.documents.length - 1];
          moreDoc = true;
          showErrorText = false;
        });
      }
    } catch (er) {
      print(er);
    }
  }

  getDoc() async {
    setState(() {
      isLoading = true;
      showErrorText = false;
      postData = null;
    });
    try {
      doc = await jobRef
          .orderBy("dateTime", descending: true)
          .limit(7)
          .getDocuments();
      QuerySnapshot adDoc;
      if (doc.documents.length != 0) {
        lengthDoc = await Firestore.instance
            .collection("advertise length")
            .document("length")
            .get();
        adDoc = await advertiseRef
            .where("index",
                isGreaterThanOrEqualTo:
                    Random().nextInt(lengthDoc.data["length"] + 1))
            .limit(1)
            .getDocuments();

        if (adDoc.documents.length == 0) {
          adDoc = await advertiseRef
              .where("index",
                  isGreaterThanOrEqualTo:
                      Random().nextInt(lengthDoc.data["length"] + 1))
              .limit(1)
              .getDocuments();
        }
        setState(() {
          postData = doc.documents;
          postData.addAll(adDoc.documents);
          isLoading = false;
        });
      }
      if (doc.documents.length == 0) {
        setState(() {
          showErrorText = true;
        });
      }
    } catch (er) {}
  }

  setFilterDoc() async {
    QuerySnapshot adDoc;
    if (moreDoc) {
      setState(() {
        skipDoc = doc.documents[doc.documents.length - 1];
      });

      if (companyType == null && city == null && genderpressed == null) {
        getDoc();
      } else if (city != null && genderpressed == null && companyType == null) {
        doc = await jobRef
            .where(
              "city",
              isEqualTo: city,
            )
            .orderBy("isVIP", descending: true)
            .orderBy("dateTime", descending: true)
            .startAfterDocument(skipDoc)
            .limit(7)
            .getDocuments();

        if (doc.documents.length != 0) {
          adDoc = await advertiseRef
              .where("index",
                  isGreaterThanOrEqualTo:
                      Random().nextInt(lengthDoc.data["length"] + 1))
              .limit(1)
              .getDocuments();

          if (adDoc.documents.length == 0) {
            adDoc = await advertiseRef
                .where("index",
                    isGreaterThanOrEqualTo:
                        Random().nextInt(lengthDoc.data["length"] + 1))
                .limit(1)
                .getDocuments();
          }
        }
      } else if (city == null && genderpressed != null && companyType == null) {
        doc = await jobRef
            .where(
              "gender",
              isEqualTo: genderpressed,
            )
            .orderBy("isVIP", descending: true)
            .orderBy("dateTime", descending: true)
            .startAfterDocument(skipDoc)
            .limit(7)
            .getDocuments();

        if (doc.documents.length != 0) {
          adDoc = await advertiseRef
              .where("index",
                  isGreaterThanOrEqualTo:
                      Random().nextInt(lengthDoc.data["length"] + 1))
              .limit(1)
              .getDocuments();

          if (adDoc.documents.length == 0) {
            adDoc = await advertiseRef
                .where("index",
                    isGreaterThanOrEqualTo:
                        Random().nextInt(lengthDoc.data["length"] + 1))
                .limit(1)
                .getDocuments();
          }
        }
      } else if (city == null && genderpressed == null && companyType != null) {
        doc = await jobRef
            .where("typeCompany", isEqualTo: companyType)
            .orderBy("isVIP", descending: true)
            .orderBy("dateTime", descending: true)
            .startAfterDocument(skipDoc)
            .limit(7)
            .getDocuments();
        if (doc.documents.length != 0) {
          adDoc = await advertiseRef
              .where("index",
                  isGreaterThanOrEqualTo:
                      Random().nextInt(lengthDoc.data["length"] + 1))
              .limit(1)
              .getDocuments();

          if (adDoc.documents.length == 0) {
            adDoc = await advertiseRef
                .where("index",
                    isGreaterThanOrEqualTo:
                        Random().nextInt(lengthDoc.data["length"] + 1))
                .limit(1)
                .getDocuments();
          }
        }
      } else if (city != null && genderpressed != null && companyType == null) {
        doc = await jobRef
            .where("gender", isEqualTo: genderpressed)
            .where("city", isEqualTo: city)
            .orderBy("isVIP", descending: true)
            .orderBy("dateTime", descending: true)
            .startAfterDocument(skipDoc)
            .limit(7)
            .getDocuments();
        if (doc.documents.length != 0) {
          adDoc = await advertiseRef
              .where("index",
                  isGreaterThanOrEqualTo:
                      Random().nextInt(lengthDoc.data["length"] + 1))
              .limit(1)
              .getDocuments();

          if (adDoc.documents.length == 0) {
            adDoc = await advertiseRef
                .where("index",
                    isGreaterThanOrEqualTo:
                        Random().nextInt(lengthDoc.data["length"] + 1))
                .limit(1)
                .getDocuments();
          }
        }
      } else if (city != null && genderpressed == null && companyType != null) {
        doc = await jobRef
            .where("city", isEqualTo: city)
            .where("typeCompany", isEqualTo: companyType)
            .orderBy("isVIP", descending: true)
            .orderBy("dateTime", descending: true)
            .startAfterDocument(skipDoc)
            .limit(7)
            .getDocuments();
        if (doc.documents.length != 0) {
          adDoc = await advertiseRef
              .where("index",
                  isGreaterThanOrEqualTo:
                      Random().nextInt(lengthDoc.data["length"] + 1))
              .limit(1)
              .getDocuments();

          if (adDoc.documents.length == 0) {
            adDoc = await advertiseRef
                .where("index",
                    isGreaterThanOrEqualTo:
                        Random().nextInt(lengthDoc.data["length"] + 1))
                .limit(1)
                .getDocuments();
          }
        }
      } else if (city == null && genderpressed != null && companyType != null) {
        doc = await jobRef
            .where("typeCompany", isEqualTo: companyType)
            .where("gender", isEqualTo: genderpressed)
            .orderBy("isVIP", descending: true)
            .orderBy("dateTime", descending: true)
            .startAfterDocument(skipDoc)
            .limit(7)
            .getDocuments();
        if (doc.documents.length != 0) {
          adDoc = await advertiseRef
              .where("index",
                  isGreaterThanOrEqualTo:
                      Random().nextInt(lengthDoc.data["length"] + 1))
              .limit(1)
              .getDocuments();

          if (adDoc.documents.length == 0) {
            adDoc = await advertiseRef
                .where("index",
                    isGreaterThanOrEqualTo:
                        Random().nextInt(lengthDoc.data["length"] + 1))
                .limit(1)
                .getDocuments();
          }
        }
      } else if (city != null && genderpressed != null && companyType != null) {
        doc = await jobRef
            .where("typeCompany", isEqualTo: companyType)
            .where("gender", isEqualTo: genderpressed)
            .where("city", isEqualTo: city)
            .orderBy("isVIP", descending: true)
            .orderBy("dateTime", descending: true)
            .startAfterDocument(skipDoc)
            .limit(7)
            .getDocuments();
        if (doc.documents.length != 0) {
          adDoc = await advertiseRef
              .where("index",
                  isGreaterThanOrEqualTo:
                      Random().nextInt(lengthDoc.data["length"] + 1))
              .limit(1)
              .getDocuments();

          if (adDoc.documents.length == 0) {
            adDoc = await advertiseRef
                .where("index",
                    isGreaterThanOrEqualTo:
                        Random().nextInt(lengthDoc.data["length"] + 1))
                .limit(1)
                .getDocuments();
          }
        }
      }

      if (doc.documents.length == 0) {
        print("lengthe ended");
        setState(() {
          moreDoc = false;
        });
        return;
      }
      setState(() {
        postData.addAll(doc.documents);
        postData.addAll(adDoc.documents);
      });
    } else {
      return;
    }
  }

  setDoc() async {
    if (moreDoc) {
      setState(() {
        skipDoc = doc.documents[doc.documents.length - 1];
      });
      doc = await jobRef
          .orderBy("dateTime", descending: true)
          .startAfterDocument(skipDoc)
          .limit(7)
          .getDocuments();
      QuerySnapshot adDoc;
      if (doc.documents.length != 0) {
        adDoc = await advertiseRef
            .where("index",
                isGreaterThanOrEqualTo:
                    Random().nextInt(lengthDoc.data["length"] + 1))
            .limit(1)
            .getDocuments();

        if (adDoc.documents.length == 0) {
          adDoc = await advertiseRef
              .where("index",
                  isGreaterThanOrEqualTo:
                      Random().nextInt(lengthDoc.data["length"] + 1))
              .limit(1)
              .getDocuments();
        }
        setState(() {
          postData.addAll(doc.documents);
          postData.addAll(adDoc.documents);
        });
      }
      if (doc.documents.length == 0) {
        setState(() {
          moreDoc = false;
        });
        return;
      }
    } else {
      return;
    }
  }

  onRefresh() async {
    if (city == null && genderpressed == null && companyType == null) {
      setState(() {
        isLoading = true;
        postData = null;
        showErrorText = false;
      });
      doc = await jobRef
          .orderBy("dateTime", descending: true)
          .limit(7)
          .getDocuments();

      QuerySnapshot adDoc;
      if (doc.documents.length != 0) {
        adDoc = await advertiseRef
            .where("index",
                isGreaterThanOrEqualTo:
                    Random().nextInt(lengthDoc.data["length"] + 1))
            .limit(1)
            .getDocuments();

        if (adDoc.documents.length == 0) {
          adDoc = await advertiseRef
              .where("index",
                  isGreaterThanOrEqualTo:
                      Random().nextInt(lengthDoc.data["length"] + 1))
              .limit(1)
              .getDocuments();
        }
        setState(() {
          postData = doc.documents;
          postData.addAll(adDoc.documents);
          skipDoc = doc.documents[doc.documents.length - 1];
          moreDoc = true;
          isLoading = false;
        });
      }

      if (doc.documents.length == 0) {
        setState(() {
          showErrorText = true;
        });
      }
    } else {
      setState(() {
        isLoading = true;
        postData = null;
      });
      getFilterDoc();

      setState(() {
        isLoading = false;
      });
    }
  }

  companyTypeDrawer() {
    return Drawer(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.grey.shade800),
              onPressed: () {
                try {
                  setState(()  {
                     SystemChannels.textInput
                        .invokeMethod("TextInput.hide");
                        companyTypeController.text=null;
                    companyType = null;
                    companyTypeValidate = true;
                    Navigator.pop(context);
                  });
                } catch (er) {}
              }),
          actions: <Widget>[Text("")],
          iconTheme: IconThemeData(color: Colors.grey.shade800, size: 15),
          backgroundColor: Colors.white,
          title: Text(
            "Company Types",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: ScreenUtil().setSp(15),
            ),
          ),
          elevation: 0.5,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  auto.TextFieldSearch(
                    isAddJob: false,
                    controller: companyTypeController,
                    label: "Types of company",
                    initialList: types,isCity: false,
                  ),
                  SizedBox(height: ScreenUtil().setHeight(5)),
                  Text(
                    companyTypeValidate ? "" : "This type is'nt found",
                    style: TextStyle(
                        color: Colors.red, fontSize: ScreenUtil().setSp(10)),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
                try {
                  if (validateSpace.hasMatch(companyTypeController.text) ||
                      companyTypeController.text.isEmpty) {
                    SystemChannels.textInput.invokeMethod("TextInput.hide");
                    Navigator.pop(context);
                    setState(() {
                      companyTypeController.clear();
                      companyType = null;
                      companyTypeValidate = true;
                    });
                  } else if (!types
                      .contains(companyTypeController.text.toLowerCase())) {
                    SystemChannels.textInput.invokeMethod("TextInput.hide");

                    setState(() {
                      companyType = null;
                      companyTypeValidate = false;
                    });
                  } else {
                    SystemChannels.textInput.invokeMethod("TextInput.hide");
                    Navigator.pop(context);
                    setState(() {
                      companyType = companyTypeController.text.toLowerCase();
                      companyTypeValidate = true;
                    });
                  }
                } catch (er) {}
              },
              child: Container(
                color: Theme.of(context).primaryColor,
                height: ScreenUtil().setHeight(50),
                width: double.infinity,
                child: Center(
                  child: Text(
                    "Done",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  cityDrawer() {
    return Drawer(
      child: Scaffold(
        key: scafKey3,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.grey.shade800),
              onPressed: () {
                try {
                  setState(() {
                    SystemChannels.textInput.invokeMethod("TextInput.hide");
                    city = null;
                    cityValidate = true;
                    Navigator.pop(context);
                  });
                } catch (er) {}
              }),
          actions: <Widget>[Text("")],
          iconTheme: IconThemeData(color: Colors.grey.shade800, size: 15),
          backgroundColor: Colors.white,
          title: Text(
            "City",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: ScreenUtil().setSp(15),
            ),
          ),
          elevation: 0.5,
        ),
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  auto.TextFieldSearch(
                    isAddJob: false,
                    controller: cityController,
                    label: "City",
                    initialList: citySuggetions,isCity: true,
                  ),
                  SizedBox(height: ScreenUtil().setHeight(5)),
                  Text(
                    cityValidate ? "" : "This city don't found",
                    style: TextStyle(
                        color: Colors.red, fontSize: ScreenUtil().setSp(10)),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                try {
                  if (validateSpace.hasMatch(cityController.text) ||
                      cityController.text.isEmpty) {
                    SystemChannels.textInput.invokeMethod("TextInput.hide");
                    Navigator.pop(context);
                    setState(() {
                      cityController.clear();
                      city = null;
                      cityValidate = true;
                    });
                  } else if (!citySuggetions
                      .contains(cityController.text.toLowerCase())) {
                    SystemChannels.textInput.invokeMethod("TextInput.hide");

                    setState(() {
                      city = null;
                      cityValidate = false;
                    });
                  } else {
                    SystemChannels.textInput.invokeMethod("TextInput.hide");
                    Navigator.pop(context);
                    setState(() {
                      city = cityController.text.toLowerCase();
                      cityValidate = true;
                    });
                  }
                } catch (er) {}
              },
              child: Container(
                color: Theme.of(context).primaryColor,
                height: ScreenUtil().setHeight(50),
                width: double.infinity,
                child: Center(
                  child: Text(
                    "Done",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  genderDrawer() {
    return Drawer(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.grey.shade800),
              onPressed: () {
                setState(() {
                  genderpressed = null;
                });
                Navigator.pop(context);
              }),
          actions: <Widget>[Text("")],
          iconTheme: IconThemeData(color: Colors.grey.shade800, size: 15),
          backgroundColor: Colors.white,
          title: Text(
            "Gender",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: ScreenUtil().setSp(15),
            ),
          ),
          elevation: 0.5,
        ),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Column(children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                    ),
                    child: ListTile(
                      title: Text(
                        "Male",
                        style: TextStyle(
                            color: genderpressed == "male"
                                ? Colors.blue
                                : Colors.black),
                      ),
                      trailing: genderpressed == "male"
                          ? Icon(
                              Icons.check,
                              color: Colors.blue,
                              size: 15,
                            )
                          : Text(""),
                      onTap: () {
                        try {
                          setState(() {
                            if (genderpressed != "male") {
                              genderpressed = "male";
                            } else {
                              genderpressed = null;
                            }
                          });
                        } catch (er) {}
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                    ),
                    child: ListTile(
                      title: Text(
                        "Female",
                        style: TextStyle(
                            color: genderpressed == "female"
                                ? Colors.blue
                                : Colors.black),
                      ),
                      trailing: genderpressed == "female"
                          ? Icon(
                              Icons.check,
                              color: Colors.blue,
                              size: 15,
                            )
                          : Text(""),
                      onTap: () {
                        try {
                          setState(() {
                            if (genderpressed != "female") {
                              genderpressed = "female";
                            } else {
                              genderpressed = null;
                            }
                          });
                        } catch (er) {}
                      },
                    ),
                  ),
                ]),
              ),
              GestureDetector(
                onTap: () {
                  try {
                    Navigator.pop(context);
                  } catch (er) {}
                },
                child: Container(
                    color: Theme.of(context).primaryColor,
                    height: ScreenUtil().setHeight(50),
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        "Done",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    )),
              )
            ]),
      ),
    );
  }

  salaryDrawer() {
    return Drawer(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          // leading: IconButton(
          //     icon: Icon(Icons.arrow_back, color: Colors.grey.shade800),
          //     onPressed: () {
          //       setState(() {
          //         salaryPressed = null;
          //       });
          //       Navigator.pop(context);
          //     }),
          actions: <Widget>[Text("")],
          iconTheme: IconThemeData(color: Colors.grey.shade800, size: 15),
          backgroundColor: Colors.white,
          title: Text(
            "Salary",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: ScreenUtil().setSp(15),
            ),
          ),
          elevation: 0.5,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Column(children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey, width: 0.5),
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      "0\$ - 500\$",
                      style: TextStyle(
                          color: salaryPressed == "0\$ - 500\$"
                              ? Colors.blue
                              : Colors.black),
                    ),
                    trailing: salaryPressed == "0\$ - 500\$"
                        ? Icon(
                            Icons.check,
                            color: Colors.blue,
                            size: 15,
                          )
                        : Text(""),
                    onTap: () {
                      try {
                        setState(() {
                          if (salaryPressed != "0\$ - 500\$") {
                            salaryPressed = "0\$ - 500\$";
                            firstSalary = 0;
                            secondSalary = 500;
                          } else {
                            salaryPressed = null;
                            firstSalary = null;
                            secondSalary = null;
                          }
                        });
                      } catch (er) {}
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey, width: 0.5),
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      "500\$ - 1000\$",
                      style: TextStyle(
                          color: salaryPressed == "500\$ - 1000\$"
                              ? Colors.blue
                              : Colors.black),
                    ),
                    trailing: salaryPressed == "500\$ - 1000\$"
                        ? Icon(
                            Icons.check,
                            color: Colors.blue,
                            size: 15,
                          )
                        : Text(""),
                    onTap: () {
                      try {
                        setState(() {
                          if (salaryPressed != "500\$ - 1000\$") {
                            salaryPressed = "500\$ - 1000\$";
                            firstSalary = 500;
                            secondSalary = 1000;
                          } else {
                            salaryPressed = null;
                            firstSalary = null;
                            secondSalary = null;
                          }
                        });
                      } catch (er) {}
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey, width: 0.5),
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      "1000\$ - 2000\$",
                      style: TextStyle(
                          color: salaryPressed == "1000\$ - 2000\$"
                              ? Colors.blue
                              : Colors.black),
                    ),
                    trailing: salaryPressed == "1000\$ - 2000\$"
                        ? Icon(
                            Icons.check,
                            color: Colors.blue,
                            size: 15,
                          )
                        : Text(""),
                    onTap: () {
                      try {
                        setState(() {
                          if (salaryPressed != "1000\$ - 2000\$") {
                            salaryPressed = "1000\$ - 2000\$";
                            firstSalary = 1000;
                            secondSalary = 2000;
                          } else {
                            salaryPressed = null;
                            firstSalary = null;
                            secondSalary = null;
                          }
                        });
                      } catch (er) {}
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey, width: 0.5),
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      "2000\$ - ~\$",
                      style: TextStyle(
                          color: salaryPressed == "2000\$ - ~\$"
                              ? Colors.blue
                              : Colors.black),
                    ),
                    trailing: salaryPressed == "2000\$ - ~\$"
                        ? Icon(
                            Icons.check,
                            color: Colors.blue,
                            size: 15,
                          )
                        : Text(""),
                    onTap: () {
                      try {
                        setState(() {
                          if (salaryPressed != "2000\$ - ~\$") {
                            salaryPressed = "2000\$ - ~\$";
                            firstSalary = 2000;
                            secondSalary = 1000000000000;
                          } else {
                            salaryPressed = null;
                            firstSalary = null;
                            secondSalary = null;
                          }
                        });
                      } catch (er) {}
                    },
                  ),
                )
              ]),
            ),
            GestureDetector(
              onTap: () {
                try {
                  Navigator.pop(context);
                } catch (er) {}
              },
              child: Container(
                  color: Theme.of(context).primaryColor,
                  height: ScreenUtil().setHeight(50),
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      "Done",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
