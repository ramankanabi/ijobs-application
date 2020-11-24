import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:iraqijob/pages/uploading_cv.dart';
import 'package:iraqijob/pages/vip_package.dart';
import 'package:connectivity/connectivity.dart';
import 'build_cv.dart';
import 'login_page.dart' as login;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multi_image_picker/multi_image_picker.dart' as multi;
import 'package:photo/photo.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import '../widget/slide_dots.dart';

class CV extends StatefulWidget {
  final String cvuid;
  final bool isEditing;

  CV(this.cvuid, this.isEditing);
  @override
  _CVState createState() => _CVState();
}

class _CVState extends State<CV> with AutomaticKeepAliveClientMixin<CV> {
  QuerySnapshot doc;
  bool isLoading = false;
  int currentPage = 0;
  bool isWifi = false;
  var wifiListen;
  checkWifi() async {
    var connection = await Connectivity().checkConnectivity();

    if (connection == ConnectivityResult.none) {
      setState(() {
        isWifi = false;
      });
    } else {
      setState(() {
        isWifi = true;
      });
    }
    wifiListen = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      try {
        if (result == ConnectivityResult.none) {
          setState(() {
            isWifi = false;
          });
        } else {
          setState(() {
            isWifi = true;
          });
        }
      } catch (er) {}
    });
  }

  @override
  void dispose() {
    wifiListen.cancel();
    super.dispose();
  }

  @override
  void initState() {
    checkWifi();
    getDoc();
    super.initState();
  }

  getDoc() async {
    try {
      setState(() {
        isLoading = true;
      });
      doc = await login.cvRef
          .document(widget.cvuid)
          .collection("cv images")
          .getDocuments();
      if (doc.documents.length == 0) {
        doc = null;
      }
      // // print(doc.documents.length);
      setState(() {
        isLoading = false;
      });
    } catch (e) {}
  }

  imageFromGallary() async {
    setState(() {
      isLoading = true;
    });

    try {
      List<File> fileImagePicked = [];
      final cvImage = (await multi.MultiImagePicker.pickImages(maxImages: 12));
      for (int i = 0; i < cvImage.length; i++) {
        final path =
            await FlutterAbsolutePath.getAbsolutePath(cvImage[i].identifier);

        fileImagePicked.add(File(path));
      }
      if (cvImage != null) {
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => UploadingCv(fileImagePicked)));
        await getDoc();
      }
    } catch (e) {}

    setState(() {
      isLoading = false;
    });
  }

  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    ScreenUtil.init(designSize: Size(360, 640), allowFontScaling: true);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey.shade600),
        title: Row(
          children: [
            Text(
              "CV",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            SizedBox(width: ScreenUtil().setWidth(5)),
            if (doc != null && doc.documents[0]["isVIP"] == true) ...{
              Text("VIP",
                  style: TextStyle(
                      color: Colors.grey, fontSize: ScreenUtil().setSp(10)))
            }
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: <Widget>[
          if (widget.isEditing) ...{
            doc != null
                ? PopupMenuButton(
                    offset: Offset(0, 40),
                    padding: EdgeInsets.all(20),
                    elevation: 5,
                    icon: Icon(Icons.more_vert, color: Colors.grey.shade800),
                    onSelected: (slec) {
                      if (slec == "delete") {
                        _showErrorDialog();
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VIPpackage(),
                          ),
                        );
                      }
                    },
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        height: 30,
                        child: Center(
                          child: Text(
                            "VIP package",
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        value: "vip",
                      ),
                      PopupMenuItem(
                        height: 30,
                        child: Center(
                          child: Text(
                            "Delete",
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                        value: "delete",
                      ),
                    ],
                  )
                : Text(""),
          }
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        child: doc == null ? withOutCvView() : showCv(),
      ),
    );
  }

  showCv() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: isLoading
          ? Container(
              height: ScreenUtil().setHeight(700),
              width: double.infinity,
              color: Colors.grey.shade100)
          : Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    onPageChanged: (index) {
                      setState(() {
                        currentPage = index;
                      });
                    },
                    // scrollDirection: Axis.horizontal,
                    itemCount: doc.documents.length,
                    itemBuilder: (context, index) {
                      return CachedNetworkImage(
                          // width: 300,
                          // height: double.infinity,
                          imageUrl: doc.documents[index]["mediaUrl"],
                          fit: BoxFit.cover);
                    },
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < doc.documents.length; i++) ...{
                      if (i == currentPage)
                        SlideDots(true, i + 1)
                      else
                        SlideDots(false, i + 1)
                    }
                  ],
                )
              ],
            ),
    );
  }

  withOutCvView() {
    return isLoading
        ? Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
                height: ScreenUtil().setHeight(700),
                width: double.infinity,
                color: Colors.grey.shade100),
          )
        : Padding(
            padding: const EdgeInsets.all(50.0),
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    height: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                            "asset/images/cv.png",
                          ),
                          fit: BoxFit.contain),
                    ),
                  ),
                  RaisedButton(
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        "Upload CV",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      onPressed:imageFromGallary
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("If you don't have a personal CV, ",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: ScreenUtil().setSp(17),
                          )),
                      SizedBox(height: 4),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => BuildCV(),
                            ),
                          );
                        },
                        child: Text("Click Here",
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: ScreenUtil().setSp(17),
                                fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
  }


  void _showErrorDialog() {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text("Deleting CV"),
              content: Text("Do yo want to delete your CV ?"),
              actions: <Widget>[
                FlatButton(
                    onPressed: isLoading
                        ? () {}
                        : () {
                            Navigator.of(ctx).pop();
                          },
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.grey.shade600),
                    )),
                FlatButton(
                    onPressed: () async {
                      Navigator.of(ctx).pop();
                      try {
                        setState(() {
                          isLoading = true;
                        });

                         await Firestore.instance.collection("D")
          .document(login.userId).delete();
                        // await login.storageRef
                        //     .child("cv media/CV_${login.userId}")
                        //     .delete();
                        print("done");

                        setState(() {
                          doc = null;
                          isLoading = false;
                        });
                      } catch (er) {}
                    },
                    child: Text(
                      "Delete",
                      style: TextStyle(color: Colors.red),
                    )),
              ],
            ));
  }
}
