import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iraqijob/pages/add_job.dart';
import 'package:iraqijob/widget/job_post.dart';
import 'package:iraqijob/widget/job_post_loader.dart';

import 'login_page.dart';

class MyJobsHiring extends StatefulWidget {
  @override
  _MyJobsHiringState createState() => _MyJobsHiringState();
}

class _MyJobsHiringState extends State<MyJobsHiring>
    with AutomaticKeepAliveClientMixin<MyJobsHiring> {
  ScrollController controller = ScrollController();

  bool isLoading = false;

  QuerySnapshot doc;

  List<DocumentSnapshot> postData = [];

  DocumentSnapshot skipDoc;

  bool moreDoc = true;

  bool showErrorText = false;

  @override
  void initState() {
    super.initState();
    try {
      isLoading = true;
      controller.addListener(() {
        if (controller.position.maxScrollExtent == controller.position.pixels) {
          setDoc();
        }
      });
      getDoc();
      setState(() {
        isLoading = false;
      });
    } catch (er) {}
  }

  getDoc() async {
    try {
      doc = await jobRef
          .orderBy("dateTime", descending: true)
          .where("ownerId", isEqualTo: userId)
          .limit(7)
          .getDocuments();
      if (doc.documents.length == 0) {
        setState(() {
          showErrorText = true;
        });
      }

      setState(() {
        postData = doc.documents;
        skipDoc = doc.documents[doc.documents.length - 1];
        isLoading = false;
      });
    } catch (er) {
      print(er);
    }
  }

  setDoc() async {
    try {
      if (moreDoc) {
        print("called");

        doc = await jobRef
            .orderBy("dateTime", descending: true)
            .where("ownerId", isEqualTo: userId)
            .startAfterDocument(skipDoc)
            .limit(7)
            .getDocuments();
        if (doc.documents.length == 0) {
          setState(() {
            moreDoc = false;
          });
          return;
        }
        setState(() {
          postData.addAll(doc.documents);
          skipDoc = doc.documents[doc.documents.length - 1];
        });
      } else {
        return;
      }
    } catch (e) {}
  }

  onRefresh() async {
    setState(() {
      isLoading = true;
      postData = null;
    });
    doc = await jobRef
        .orderBy("dateTime", descending: true)
        .where("ownerId", isEqualTo: userId)
        .limit(7)
        .getDocuments();
    setState(() {
      postData = doc.documents;
      skipDoc = doc.documents[doc.documents.length - 1];
      moreDoc = true;
      isLoading = false;
    });
  }

  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Jobs Hiring",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: isLoading
          ? SingleChildScrollView(
              child: Column(
                children: [
                  JobPostLoader(isMyJob: true,),
                ],
              ),
            )
          : (RefreshIndicator(
              onRefresh: () => onRefresh(),
              child: showErrorText
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          " You don't have any jobs hiring .",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    )
                  : ListView.builder(
                      controller: controller,
                      itemCount: postData.length,
                      itemBuilder: (ctx, i) {
                        return Card(
                          elevation: 1,
                          child: JobPost.fromDocument(postData[i]),
                        );
                      },
                    ),
            )),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 4,
          highlightElevation: 0,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddJob(),
              ),
            );
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 26,
          )),
    );
  }
}
