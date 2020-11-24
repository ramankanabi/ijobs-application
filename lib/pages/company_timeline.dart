import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iraqijob/widget/advertise_post.dart';
import 'package:iraqijob/widget/cv_post.dart';
import 'package:iraqijob/widget/cv_post_loader.dart';
import 'home.dart' as home;
import 'login_page.dart' as login;

class CompanyTimeline extends StatefulWidget {
  @override
  _CompanyTimelineState createState() => _CompanyTimelineState();
}

class _CompanyTimelineState extends State<CompanyTimeline>
    with AutomaticKeepAliveClientMixin<CompanyTimeline> {
  QuerySnapshot doc;
  bool isLoading = false;
  GlobalKey<ScaffoldState> scafKey = GlobalKey();
  ScrollController controller = ScrollController();
  List postData = [];
  DocumentSnapshot skipDoc;
  DocumentSnapshot lengthDoc;
  bool moreDoc = true;
  bool showErrorText = false;
  List finalDoc = [];

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
        // var delta = MediaQuery.of(context).size.height * 0.25;

        if (maxScroll - currentPos == 0) {
          setDoc();
        }
      });

      setState(() {
        isLoading = false;
      });
    } catch (er) {}
    super.initState();
  }

  setDoc() async {
    try {
      if (moreDoc) {
        setState(() {
          skipDoc = doc.documents[doc.documents.length - 1];
        });

        doc = await login.cvRef
            .where("interestedCompany", isEqualTo: home.cUser.typeCompany)
            .orderBy("isVIP", descending: true)
            .orderBy("dateTime", descending: true)
            .startAfterDocument(skipDoc)
            .limit(7)
            .getDocuments();
        QuerySnapshot adDoc;

        if (doc.documents.length != 0) {
          adDoc = await login.advertiseRef
              .where("index",
                  isGreaterThanOrEqualTo:
                      Random().nextInt(lengthDoc.data["length"] + 1))
              .limit(1)
              .getDocuments();

          if (adDoc.documents.length == 0) {
            adDoc = await login.advertiseRef
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
      }
    } catch (er) {}
  }

  getDoc() async {
    try {
      setState(() {
        isLoading = true;
        postData = null;
      });

      final doc = await login.cvRef
          .where("interestedCompany", isEqualTo: home.cUser.typeCompany)
          .orderBy("isVIP", descending: true)
          .orderBy("dateTime", descending: true)
          .limit(7)
          .getDocuments();

          // tebini am queryay sarawa bo yak wena bakarm ahena 
          
      // for (int i = 0; i < doc.documents.length; i++) {
      //   final n = await login.cvRef.document(doc.documents[i].documentID)
      //       .collection("cv images")
      //       .getDocuments();
      // print(n.documents.length);
      //   finalDoc.add(n);
      // }


      //adDoc functioni sponsora u hich keshay tya nya baray xom u la dway har 7 postek reklamek pishan dadat 
      QuerySnapshot adDoc;
      if (0 != 0) {
        lengthDoc = await Firestore.instance
            .collection("advertise length")
            .document("length")
            .get();

        adDoc = await login.advertiseRef
            .where("index",
                isGreaterThanOrEqualTo:
                    Random().nextInt(lengthDoc.data["length"] + 1))
            .limit(1)
            .getDocuments();

        if (adDoc.documents.length == 0) {
          adDoc = await login.advertiseRef
              .where("index",
                  isGreaterThanOrEqualTo:
                      Random().nextInt(lengthDoc.data["length"] + 1))
              .limit(1)
              .getDocuments();
        }

        setState(() {
          postData = finalDoc;
          postData.addAll(adDoc.documents);
          isLoading = false;
        });
      }

      // if (doc.documents.length == 0) {
      //   setState(() {
      //     showErrorText = true;
      //   });
      // }
    } catch (e) {}
  }

  onRefresh() async {
    try {
      setState(() {
        isLoading = true;
        postData = null;
      });
      doc = await login.cvRef
          .where("interestedCompany", isEqualTo: home.cUser.typeCompany)
          .orderBy("isVIP", descending: true)
          .orderBy("dateTime", descending: true)
          .limit(7)
          .getDocuments();
      QuerySnapshot adDoc;

      if (doc.documents.length != 0) {
        adDoc = await login.advertiseRef
            .where("index",
                isGreaterThanOrEqualTo:
                    Random().nextInt(lengthDoc.data["length"] + 1))
            .limit(1)
            .getDocuments();

        if (adDoc.documents.length == 0) {
          adDoc = await login.advertiseRef
              .where("index",
                  isGreaterThanOrEqualTo:
                      Random().nextInt(lengthDoc.data["length"] + 1))
              .limit(1)
              .getDocuments();
        }
      }

      setState(() {
        postData = doc.documents;
        postData.addAll(adDoc.documents);
        skipDoc = doc.documents[doc.documents.length - 1];
        moreDoc = true;
        isLoading = false;
      });
    } catch (er) {}
  }

  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      key: scafKey,
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          "Job In Iraq",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ),
      body: showErrorText
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
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
                          child:  CVPost.fromDocument(
                                  postData[i].documents,
                                ),
                        );
                      },
                    )),
            ),
    );
  }
}
