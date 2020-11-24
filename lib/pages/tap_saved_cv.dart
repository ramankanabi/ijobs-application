import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iraqijob/widget/cv_post.dart';

class TapSavedCv extends StatefulWidget {
  final DocumentSnapshot doc;
  TapSavedCv(this.doc);

  @override
  _TapSavedCvState createState() => _TapSavedCvState();
}

class _TapSavedCvState extends State<TapSavedCv> {
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
            child: CVPost.fromDocument(widget.doc),
          )),
    );
  }
}
