import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iraqijob/pages/login_page.dart';
import 'package:iraqijob/widget/advertise_post.dart';
import 'package:iraqijob/widget/job_post.dart';
import 'package:iraqijob/widget/job_post_loader.dart';
import 'home.dart';

class PersonalTimeline extends StatefulWidget {
  @override
  _PersonalTimelineState createState() => _PersonalTimelineState();
}

class _PersonalTimelineState extends State<PersonalTimeline>
    with AutomaticKeepAliveClientMixin<PersonalTimeline> {
  int skip = 0;
  ScrollController controller = ScrollController();
  bool isLoading = false;
  QuerySnapshot doc;
  List<DocumentSnapshot> postData = [];
  DocumentSnapshot lengthDoc;
  DocumentSnapshot skipDoc;
  DocumentSnapshot firstDoc;
  bool moreDoc = true;
  bool a = true;
  // Puser pUser;
  bool showErrorText = false;
  bool isReload = false;
  @override
  void initState() {
    super.initState();
    try {
      setState(() {
        isLoading = true;
      });
      getDoc();
      controller.addListener(() {
        // var maxScroll = controller.position.maxScrollExtent;
        // var currentPos = controller.position.pixels;
        // // var delta = MediaQuery.of(context).size.height * 0.25;

        if (controller.position.pixels == controller.position.maxScrollExtent) {
          setDoc();
        }
      });

      setState(() {
        isLoading = false;
      });
    } catch (er) {}
  }

  getDoc() async {
    try {
      setState(() {
        isLoading = true;
        showErrorText = false;
        postData = null;
      });
      doc = await jobRef
          .where("typeCompany", isEqualTo: pUser.interestedCompany)
          .orderBy("isVIP", descending: true)
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

  setDoc() async {
    try {
      if (moreDoc) {
        skipDoc = doc.documents[doc.documents.length - 1];
        doc = await jobRef
            .where("typeCompany", isEqualTo: pUser.interestedCompany)
            .orderBy("isVIP", descending: true)
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
    } catch (er) {}
  }

  onRefresh() async {
    setState(() {
      postData = null;
      isLoading = true;
    });
    doc = await jobRef
        .where("typeCompany", isEqualTo: pUser.interestedCompany)
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
  }

  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: Text(
            "Ijobs",
            style: TextStyle(color: Theme.of(context).primaryColor,),
          ),
          elevation: 0.5,
        ),
        body: RefreshIndicator(
          onRefresh: () => onRefresh(),
          child: showErrorText
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "At now you don't have any jobs hiring which interested .",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                )
              : isLoading || postData == null
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          JobPostLoader(isMyJob: false,),
                        ],
                      ),
                    )
                  : (ListView.builder(
                      controller: controller,
                      itemCount: postData.length,
                      itemBuilder: (ctx, i) {
                        return Card(
                          elevation: 1,
                          child: (postData[i]["isAdvertise"]
                              ? AdvertisePost.fromDocument(postData[i])
                              : JobPost.fromDocument(
                                  postData[i],
                                )),
                        );
                      })),
        ));
  }
}
