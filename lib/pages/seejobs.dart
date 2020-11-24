import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iraqijob/pages/login_page.dart';
import 'package:iraqijob/widget/job_post.dart';
import 'package:iraqijob/widget/job_post_loader.dart';

class SeeJobs extends StatefulWidget {
  final String profileId;

  SeeJobs(this.profileId);
  @override
  _SeeJobsState createState() => _SeeJobsState();
}

class _SeeJobsState extends State<SeeJobs> {
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
        var maxScroll = controller.position.maxScrollExtent;
        var currentPos = controller.position.pixels;

        if (maxScroll - currentPos == 0) {
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
          .where("ownerId", isEqualTo: widget.profileId)
          .limit(2)
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
    if (moreDoc) {
      print("called");

      doc = await jobRef
          .orderBy("dateTime", descending: true)
          .where("ownerId", isEqualTo: widget.profileId)
          .startAfterDocument(skipDoc)
          .limit(25)
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
  }

  onRefresh() async {
    doc = await jobRef
        .orderBy("dateTime", descending: true)
        .where("ownerId", isEqualTo: widget.profileId)
        .limit(2)
        .getDocuments();
    setState(() {
      postData = doc.documents;
      skipDoc = doc.documents[doc.documents.length - 1];
      moreDoc = true;
      print("done");
    });
  }

  @override
  Widget build(BuildContext context) {
    bool ownerProfile = widget.profileId == userId;
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.grey.shade800,
          ),
          backgroundColor: Colors.white,
          elevation: 0.5,
        ),
        body: isLoading
            ? JobPostLoader(isMyJob: false,)
            : (RefreshIndicator(
                onRefresh: () => onRefresh(),
                child: showErrorText
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: ownerProfile
                              ? Text(
                                  " You have not any jobs hiring .",
                                  style: TextStyle(color: Colors.blue),
                                )
                              : Text(
                                  "That Company at now have not any job hiring .",
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
                            child: JobPost.fromDocument(postData[i],),
                          );
                        },
                      ),
              )));
  }
}
