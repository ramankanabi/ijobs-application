import 'dart:io';
import 'package:flutter/material.dart';
import 'package:iraqijob/pages/login_page.dart';
import 'package:iraqijob/widget/loader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as im;
import 'home.dart' as home;
import 'package:shared_preferences/shared_preferences.dart';

class ChangeProfilePhoto extends StatefulWidget {
  final File imageProfile;
  ChangeProfilePhoto(this.imageProfile);

  @override
  _ChangeProfilePhotoState createState() => _ChangeProfilePhotoState();
}

class _ChangeProfilePhotoState extends State<ChangeProfilePhoto> {
  File imageProfile;
  String mediaUrl;
  bool isLoading = false;

  compresImage() async {
    imageProfile = widget.imageProfile;

    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;

    im.Image imageFilee = im.decodeImage(imageProfile.readAsBytesSync());
    final compressedImageFile = File("$path/profilePhoto_$userId.jpg")
      ..writeAsBytesSync(im.encodeJpg(imageFilee, quality: 75));
    setState(() {
      imageProfile = compressedImageFile;
    });
  }

  Future<String> uploadImage() async {
    final uploadTask = storageRef
        .child("profile picture/profilePhoto_$userId.jpg")
        .putFile(imageProfile);
    final storageSnap = await uploadTask.onComplete;
    final downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  saveToDatabase() async {
    if (home.isCompany) {
      await cUserRef.document(userId).updateData({"photoUrl": mediaUrl});
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("photoUrl", mediaUrl);
      home.photoUrl=ValueNotifier(mediaUrl);
      // home.photoUrl=mediaUrl;
    } else {
      await pUserRef.document(userId).updateData({"photoUrl": mediaUrl});
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("photoUrl", mediaUrl);
       home.photoUrl=ValueNotifier(mediaUrl);
      // home.photoUrl=mediaUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: isLoading
          ? null
          : AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              actions: <Widget>[
                Expanded(
                  child: FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                Expanded(
                  child: FlatButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      await compresImage();
                      mediaUrl = await uploadImage();
                      await saveToDatabase();
                      setState(() {
                        isLoading = false;
                      });
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Done",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
              ],
            ),
      body: isLoading
          ? Loader()
          : Container(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: FileImage(widget.imageProfile),
                      radius: 110,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
