import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iraqijob/widget/job_post.dart';

class TapSavedJob extends StatefulWidget {
  final DocumentSnapshot doc;
  TapSavedJob(this.doc);

  @override
  _TapSavedJobState createState() => _TapSavedJobState();
}

class _TapSavedJobState extends State<TapSavedJob> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.grey.shade700),
      ),
      body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: JobPost.fromDocument(widget.doc,),
          )),
    );
  }
}
