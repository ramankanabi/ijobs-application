import 'dart:math';

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iraqijob/widget/advertise_post.dart';
import 'package:iraqijob/widget/cv_post.dart';
import 'package:iraqijob/widget/cv_post_loader.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'login_page.dart';
import '../widget/textfield_search_packages.dart' as auto;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CompanyExplorer extends StatefulWidget {
  @override
  _ExplorerState createState() => _ExplorerState();
}

class _ExplorerState extends State<CompanyExplorer>
    with AutomaticKeepAliveClientMixin<CompanyExplorer> {
  QuerySnapshot doc;
  List<DocumentSnapshot> postData = [];
  DocumentSnapshot lengthDoc;
  bool isLoading = false;
  GlobalKey<ScaffoldState> scafKey = GlobalKey();
  ScrollController controller = ScrollController();
  DocumentSnapshot skipDoc;
  bool moreDoc = true;
  bool showErrorText = false;
  ////////////////////////////////// Drawer Filter ////////////////////////////
  TextEditingController cityController = TextEditingController();
  TextEditingController usersInterestedCompanyController =
      TextEditingController();
  GlobalKey<ScaffoldState> scafKey2 = GlobalKey();
  String secondDrawer = "";
  String city;
  String genderpressed;
  String usersInterestedCompany;
  bool cityValidate = true;
  bool usersInterestedCompanyValidate = true;
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
  /////////////////////////////////////////////////////////////////////////////////////////
  ///

  @override
  void initState() {
    try {
      setState(() {
        isLoading = true;
      });
      getDoc();
      controller.addListener(() {
        var maxScroll = controller.position.maxScrollExtent;
        var currentPos = controller.position.pixels;

        if (maxScroll - currentPos == 0) {
          if (city == null &&
              usersInterestedCompany == null &&
              genderpressed == null) {
            setDoc();
          } else {
            setFilterDoc();
          }
        }
      });

      setState(() {
        isLoading = false;
      });
    } catch (er) {}
    super.initState();
  }

  setDoc() async {
    if (moreDoc) {
      setState(() {
        skipDoc = doc.documents[doc.documents.length - 1];
      });
      doc = await cvRef
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

  getDoc() async {
    try {
      postData = null;
      isLoading = true;

      lengthDoc = await Firestore.instance
          .collection("advertise length")
          .document("length")
          .get();

      doc = await cvRef
          .orderBy("dateTime", descending: true)
          .limit(7)
          .getDocuments();

      QuerySnapshot adDoc = await advertiseRef
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

      if (doc.documents.length == 0) {
        setState(() {
          showErrorText = true;
        });
      }
    } catch (e) {}
  }

  onRefresh() async {
    try {
      setState(() {
        showErrorText = false;
      });
      if (city == null &&
          genderpressed == null &&
          usersInterestedCompany == null) {
        setState(() {
          isLoading = true;
          postData = null;
        });
        doc = await cvRef
            .orderBy("dateTime", descending: true)
            .limit(7)
            .getDocuments();

        lengthDoc = await Firestore.instance
            .collection("advertise length")
            .document("length")
            .get();

        QuerySnapshot adDoc = await advertiseRef
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
    } catch (er) {}
  }

  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    ScreenUtil.init(designSize: Size(360, 640), allowFontScaling: true);
    return Scaffold(
      key: scafKey,
      endDrawer: drawer(),
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          "Explorer",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        actions: <Widget>[
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
      body: showErrorText
          ? Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: Text("At now there is has'nt any post",
                    style: TextStyle(color: Colors.grey.shade800)),
              ),
            )
          : RefreshIndicator(
              onRefresh: () => onRefresh(),
              child: isLoading || postData == null
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          CvPostLoader(),
                        ],
                      ),
                    )
                  : (ListView.builder(
                      controller: controller,
                      itemCount: postData.length,
                      itemBuilder: (ctx, i) {
                        return Card(
                            elevation: 2,
                            child: postData[i]["isAdvertise"]
                                ? AdvertisePost.fromDocument(postData[i])
                                : CVPost.fromDocument(postData[i]));
                      },
                    )),
            ),
    );
  }

  drawer() {
    return Drawer(
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            FlatButton(
              child: Text(
                "reset",
                style: TextStyle(
                  color: city == null &&
                          genderpressed == null &&
                          usersInterestedCompany == null
                      ? Colors.grey
                      : Colors.blue,
                ),
              ),
              onPressed: usersInterestedCompany == null &&
                      city == null &&
                      genderpressed == null
                  ? () {}
                  : () async {
                      usersInterestedCompany = null;
                      city = null;
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
            "Filtering",
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
            : secondDrawer == "gender"
                ? genderDrawer()
                : usersInterestedCompanyDrawer(),
        key: scafKey2,
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
                      subtitle: usersInterestedCompany == null
                          ? null
                          : Text(
                              usersInterestedCompany,
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
                              secondDrawer = "usersInterestedCompany";
                            });
                            scafKey2.currentState.openEndDrawer();
                          } catch (er) {}
                        },
                      ),
                      onTap: () {
                        try {
                          setState(() {
                            secondDrawer = "usersInterestedCompany";
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
                      usersInterestedCompany != null ||
                      genderpressed != null) {
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

  usersInterestedCompanyDrawer() {
    return Drawer(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.grey.shade800),
              onPressed: () {
                try {
                  SystemChannels.textInput.invokeMethod("TextInput.hide");
                  setState(() {
                    usersInterestedCompanyController.text = null;
                    usersInterestedCompany = null;
                    usersInterestedCompanyValidate = true;
                    Navigator.pop(context);
                  });
                } catch (er) {}
              }),
          actions: <Widget>[Text("")],
          iconTheme: IconThemeData(color: Colors.grey.shade800, size: 15),
          backgroundColor: Colors.white,
          title: Text(
            "Users Interested Company",
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
                    controller: usersInterestedCompanyController,
                    label: "Category",
                    initialList: types,
                    isCity: false,
                  ),
                  SizedBox(height: ScreenUtil().setHeight(5)),
                  Text(
                    usersInterestedCompanyValidate ? "" : "it's not found",
                    style: TextStyle(
                        color: Colors.red, fontSize: ScreenUtil().setSp(10)),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                try {
                  if (validateSpace
                          .hasMatch(usersInterestedCompanyController.text) ||
                      usersInterestedCompanyController.text.isEmpty) {
                    SystemChannels.textInput.invokeMethod("TextInput.hide");
                    Navigator.pop(context);
                    setState(() {
                      usersInterestedCompanyController.clear();
                      usersInterestedCompany = null;
                      usersInterestedCompanyValidate = true;
                    });
                  } else if (!types.contains(
                      usersInterestedCompanyController.text.toLowerCase())) {
                    SystemChannels.textInput.invokeMethod("TextInput.hide");

                    setState(() {
                      usersInterestedCompany = null;
                      usersInterestedCompanyValidate = false;
                    });
                  } else {
                    SystemChannels.textInput.invokeMethod("TextInput.hide");
                    Navigator.pop(context);
                    setState(() {
                      usersInterestedCompany =
                          usersInterestedCompanyController.text.toLowerCase();
                      usersInterestedCompanyValidate = true;
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
                    initialList: citySuggetions,
                    isCity: true,
                  ),
                  SizedBox(height: ScreenUtil().setHeight(5)),
                  Text(
                    cityValidate ? "" : "This city is'nt found",
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

  //////////////////////////////////////////////////////////filter actionn   /////////////////////////////////////////////
  getFilterDoc() async {
    setState(() {
      postData = null;
      showErrorText = false;
    });

    try {
      if (usersInterestedCompany == null &&
          city == null &&
          genderpressed == null) {
        getDoc();
      } else if (city != null &&
          genderpressed == null &&
          usersInterestedCompany == null) {
        doc = await cvRef
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
      } else if (city == null &&
          genderpressed != null &&
          usersInterestedCompany == null) {
        doc = await cvRef
            .where(
              "gender",
              isEqualTo: genderpressed,
            )
            .orderBy("isVIP", descending: true)
            .orderBy("dateTime", descending: true)
            .limit(7)
            .getDocuments();

        if (doc.documents.length != 0) {
          QuerySnapshot adDoc = await advertiseRef
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
      } else if (city == null &&
          genderpressed == null &&
          usersInterestedCompany != null) {
        doc = await cvRef
            .where("interestedCompany", isEqualTo: usersInterestedCompany)
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
      } else if (city != null &&
          genderpressed != null &&
          usersInterestedCompany == null) {
        doc = await cvRef
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
      } else if (city != null &&
          genderpressed == null &&
          usersInterestedCompany != null) {
        doc = await cvRef
            .where("city", isEqualTo: city)
            .where("interestedCompany", isEqualTo: usersInterestedCompany)
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
      } else if (city == null &&
          genderpressed != null &&
          usersInterestedCompany != null) {
        doc = await cvRef
            .where("interestedCompany", isEqualTo: usersInterestedCompany)
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
      } else if (city != null &&
          genderpressed != null &&
          usersInterestedCompany != null) {
        doc = await cvRef
            .where("interestedCompany", isEqualTo: usersInterestedCompany)
            .where("gender", isEqualTo: genderpressed)
            .where("city", isEqualTo: city)
            .orderBy("isVIP", descending: true)
            .orderBy("dateTime", descending: true)
            .limit(7)
            .getDocuments();

        if (doc.documents.length != 0) {
          QuerySnapshot adDoc = await advertiseRef
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
      }

      if (doc.documents.length == 0) {
        setState(() {
          showErrorText = true;
        });
      }
      if (doc.documents.length != 0) {
        setState(() {
          skipDoc = doc.documents[doc.documents.length - 1];
          moreDoc = true;
        });
      }
    } catch (er) {
      print(er);
    }
  }

  setFilterDoc() async {
    QuerySnapshot adDoc;
    if (moreDoc) {
      setState(() {
        skipDoc = doc.documents[doc.documents.length - 1];
      });

      if (usersInterestedCompany == null &&
          city == null &&
          genderpressed == null) {
        getDoc();
      } else if (city != null &&
          genderpressed == null &&
          usersInterestedCompany == null) {
        doc = await cvRef
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
      } else if (city == null &&
          genderpressed != null &&
          usersInterestedCompany == null) {
        doc = await cvRef
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
      } else if (city == null &&
          genderpressed == null &&
          usersInterestedCompany != null) {
        doc = await cvRef
            .where("interestedCompany", isEqualTo: usersInterestedCompany)
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
      } else if (city != null &&
          genderpressed != null &&
          usersInterestedCompany == null) {
        doc = await cvRef
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
      } else if (city != null &&
          genderpressed == null &&
          usersInterestedCompany != null) {
        doc = await cvRef
            .where("city", isEqualTo: city)
            .where("interestedCompany", isEqualTo: usersInterestedCompany)
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
      } else if (city == null &&
          genderpressed != null &&
          usersInterestedCompany != null) {
        doc = await cvRef
            .where("interestedCompany", isEqualTo: usersInterestedCompany)
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
      } else if (city != null &&
          genderpressed != null &&
          usersInterestedCompany != null) {
        doc = await cvRef
            .where("interestedCompany", isEqualTo: usersInterestedCompany)
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
      } else if (city != null &&
          genderpressed != null &&
          usersInterestedCompany != null) {
        doc = await cvRef
            .where("interestedCompany", isEqualTo: usersInterestedCompany)
            .where("gender", isEqualTo: genderpressed)
            .startAfterDocument(skipDoc)
            .where("city", isEqualTo: city)
            .orderBy("isVIP", descending: true)
            .orderBy("dateTime", descending: true)
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
        setState(() {
          moreDoc = false;
        });
        return;
      }
      if (doc.documents.length != 0) {
        setState(() {
          postData.addAll(doc.documents);
          postData.addAll(adDoc.documents);
        });
      }
    } else {
      return;
    }
  }
}
