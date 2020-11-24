import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:iraqijob/model.dart/person_user.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as im;
import 'login_page.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadingCv extends StatefulWidget {
  List<File> cvImage;

  UploadingCv(this.cvImage);

  @override
  _UploadingCvState createState() => _UploadingCvState();
}

class _UploadingCvState extends State<UploadingCv> {
  List<File> cvImage;
  List<File> compressedCvImage = [];
  List mediaUrl = [];
  bool isUploading = false;
  bool isLoading = false;
  String cvId = Uuid().v4();
  compresImage() async {
    setState(() {
      isUploading = true;
    });
    cvImage = widget.cvImage;
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;

    for (int i = 0; i < cvImage.length; i++) {
      im.Image imageFilee = im.decodeImage(cvImage[i].readAsBytesSync());
      final compressedImageFile = File("$path/CV_${DateTime.now()}.jpg")
        ..writeAsBytesSync(im.encodeJpg(imageFilee, quality: 85));

      setState(() {
        compressedCvImage.add(compressedImageFile);
      });
    }

    // saveToDatabase(mediaUrl);
  }

  uploadCv() async {
    for (int i = 0; i < compressedCvImage.length; i++) {
      print(compressedCvImage.length);
      final uploadTask = storageRef
          .child("cv media/CV_$userId/${DateTime.now()}.jpg")
          .putFile(compressedCvImage[i]);
      await uploadTask.onComplete.then((value) async {
        final downloadUrl = await value.ref.getDownloadURL();
        mediaUrl.add(downloadUrl);
      });
    }

    // return downloadUrl;
  }

  Future saveToDatabase() async {
    final doc = await pUserRef.document(userId).get();
    Puser pUser = Puser.fromDocument(doc);
    DateTime dateTime = DateTime.now();
    for (int i = 0; i < mediaUrl.length; i++) {
     cvRef
          .document(userId)
          .collection("cv images")
          .document(cvId)
          .setData({
        "city": pUser.city,
        "fullName": pUser.fullName,
        "userId": userId,
        "email": pUser.email,
        "interestedCompany": pUser.interestedCompany,
        "mediaUrl": mediaUrl[i],
        "photoUrl": pUser.photoUrl,
        "dateTime": dateTime,
        "gender": pUser.gender,
        "isVIP": false,
        "isAdvertise": false,
        "savedDateTime": {},
        "cvId": cvId,
      });
      cvId = Uuid().v4();
    }
    Navigator.pop(context, false);
    setState(() {
      isUploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: <Widget>[
          Expanded(
            child: FlatButton(
              onPressed: isUploading
                  ? () {}
                  : () {
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
              onPressed: isUploading
                  ? () {}
                  : () async {
                      await compresImage();
                      await uploadCv();
                      await saveToDatabase();
                    },
              child: Text(
                "Upload",
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: isUploading
                    ? Center(child: CircularProgressIndicator())
                    : gridView(),
              ),
            ),
    );
  }

  photoViewGallery(int n) {
    PhotoViewController photoViewController = PhotoViewController();
    PageController pageController = PageController(initialPage: n);

    return Container(
      child: PhotoViewGallery.builder(
        itemCount: widget.cvImage.length,
        pageController: pageController,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            controller: photoViewController,
            filterQuality: FilterQuality.high,
            imageProvider: FileImage(widget.cvImage[index]),
            minScale: PhotoViewComputedScale.contained,
            initialScale: PhotoViewComputedScale.contained,
          );
        },
      ),
    );
  }

  gridView() {
    return GridView.count(
      mainAxisSpacing: 5,
      crossAxisSpacing: 5,
      crossAxisCount: 3,
      children: List.generate(widget.cvImage.length, (index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Scaffold(
                    backgroundColor: Colors.black,
                    body: photoViewGallery(index)),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 0.3, color: Colors.grey),
              image: DecorationImage(
                image: FileImage(widget.cvImage[index]),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      }),
    );
  }
}
