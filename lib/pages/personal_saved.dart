import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iraqijob/pages/login_page.dart';
import 'package:iraqijob/widget/saved_job_design.dart';

class PersonalSaved extends StatefulWidget {
  @override
  _PersonalSavedState createState() => _PersonalSavedState();
}

class _PersonalSavedState extends State<PersonalSaved>
    with AutomaticKeepAliveClientMixin<PersonalSaved> {
  int skip = 0;
  ScrollController controller = ScrollController();
  bool isLoading = false;
  QuerySnapshot doc;
  List<DocumentSnapshot> queryData = [];
  List<DocumentSnapshot> postData = [];
  DocumentSnapshot skipDoc;
  bool moreDoc = true;
  bool showErrorText = false;

  @override
  void initState() {
    try {
      setState(() {
        isLoading = true;
      });
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
    super.initState();
  }

  getDoc() async {
    setState(() {
      isLoading = true;
    });

    try {
      doc = await jobRef
          .orderBy("savedDateTime.$userId", descending: true)
          .limit(10)
          .getDocuments();

      if (doc.documents.length == 0) {
        setState(() {
          showErrorText = true;
          isLoading = false;
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
        doc = await jobRef
            .orderBy("savedDateTime.$userId", descending: true)
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
    } catch (er) {}
  }

  onRefresh() async {
    doc = await jobRef
        .orderBy("savedDateTime.$userId", descending: true)
        .limit(15)
        .getDocuments();
    setState(() {
      postData = doc.documents;
      skipDoc = doc.documents[doc.documents.length - 1];
      moreDoc = true;
    });
  }

  bool get wantKeepAlive => false;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.5,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text(
          "Saved",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: isLoading
          ? Padding(
            padding: const EdgeInsets.all(5.0),
            child: Card(
                elevation: 2,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey.shade200,
                  ),
                  title: Text(
                    "company name",
                    style: TextStyle(color: Colors.grey.shade200),
                  ),
                  subtitle: Text(
                    "position",
                    style: TextStyle(color: Colors.grey.shade200),
                  ),
                ),
              ),
          )
          : RefreshIndicator(
              onRefresh: () => getDoc(),
              child: Padding(
                padding: EdgeInsets.all(5),
                child: showErrorText
                    ? Center(
                        child: Text(
                          "you didn't save any job hiring",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                        ),
                      )
                    : ListView.builder(
                        controller: controller,
                        itemCount: postData.length,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return SavedJobDesign(
                            postData[index],
                          );
                        },
                      ),
              ),
            ),
    );
  }
}
