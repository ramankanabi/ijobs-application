import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iraqijob/pages/login_page.dart';
import 'package:iraqijob/pages/tap_saved_cv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CompanySaved extends StatefulWidget {
  @override
  _CompanySavedState createState() => _CompanySavedState();
}

class _CompanySavedState extends State<CompanySaved>
    with AutomaticKeepAliveClientMixin<CompanySaved> {
  ScrollController controller = ScrollController();
  bool isLoading = false;
  QuerySnapshot doc;
  List<DocumentSnapshot> postData = [];
  DocumentSnapshot skipDoc;
  bool moreDoc = true;
  bool showErrorText = false;

  @override
  void initState() {
    try {
     
      controller.addListener(() {
        

        if (controller.position.maxScrollExtent == controller.position.pixels) {
          print('scroll');
          setDoc();
        }
      });
      getDoc();
    } catch (er) {}
    super.initState();
  }

  getDoc() async {
    try {
      setState(() {
        isLoading = true;
      });
      doc = await cvRef
          .orderBy("savedDateTime.$userId", descending: true)
          .limit(25)
          .getDocuments();
      if (doc.documents.length == 0) {
        setState(() {
          showErrorText = true;
        });
      }

      setState(() {
        postData.addAll(doc.documents);
        skipDoc = doc.documents[doc.documents.length - 1];
      });

      setState(() {
        isLoading = false;
      });
    } catch (er) {
      print(er);
    }
  }

  setDoc() async {
    if (moreDoc) {
      doc = await cvRef
          .startAfterDocument(skipDoc)
          .orderBy("savedDateTime.$userId", descending: true)
          .limit(12)
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
    try {
      setState(() {
        isLoading = true;
        doc = null;
      });
      doc = await cvRef
          .orderBy("savedDateTime.$userId", descending: true)
          .limit(25)
          .getDocuments();

      if (doc.documents.length == 0) {
        setState(() {
          showErrorText = true;
        });
      }
      setState(() {
        postData = doc.documents;
        skipDoc = doc.documents[doc.documents.length - 1];
        moreDoc = true;
        isLoading = false;
      });
    } catch (er) {}
  }

  bool get wantKeepAlive => false;
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(designSize: Size(360, 640), allowFontScaling: true);
    super.build(context);
    return Scaffold(
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
      body: RefreshIndicator(
        onRefresh: () => onRefresh(),
        child: Padding(
          padding: EdgeInsets.all(5),
          child: showErrorText
              ? Center(
                  child: Text(
                    "you don't save any CV",
                    style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: ScreenUtil().setSp(15)),
                  ),
                )
              : GridView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  controller: controller,
                  itemCount:
                      isLoading || doc == null? 2 : postData.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return isLoading || doc == null 
                        ? Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              border: Border.all(color: Colors.grey),
                            ),
                          )
                        : SavedItem(postData[index]);
                  },
                ),
        ),
      ),
    );
  }
}

class SavedItem extends StatefulWidget {
  final DocumentSnapshot postData;
  SavedItem(this.postData);
  @override
  _SavedItemState createState() => _SavedItemState();
}

class _SavedItemState extends State<SavedItem>
    with AutomaticKeepAliveClientMixin<SavedItem> {
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => TapSavedCv(widget.postData),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: Colors.grey),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(
              widget.postData["mediaUrl"],
            ),
          ),
        ),
      ),
    );
  }
}
