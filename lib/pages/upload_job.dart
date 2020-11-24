import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iraqijob/model.dart/company_user.dart';
import 'package:iraqijob/pages/add_job_2.dart';
import 'package:iraqijob/pages/home.dart';
import 'package:iraqijob/widget/loader.dart';
import 'package:iraqijob/widget/post_template.dart';
import 'add_job.dart';
import 'login_page.dart';
import 'package:uuid/uuid.dart';
import 'package:connectivity/connectivity.dart';

class UploadJob extends StatefulWidget {
  @override
  _UploadJobState createState() => _UploadJobState();
}

class _UploadJobState extends State<UploadJob> {
  String jobId = Uuid().v4();
  DocumentSnapshot doc;
  Cuser cUser;
  bool isLoading = false;

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
  void initState() {
    checkWifi();
    super.initState();
  }

  @override
  void dispose() {
    wifiListen.cancel();
    super.dispose();
  }

  upload() async {
    setState(() {
      isLoading = true;
    });

    doc = await cUserRef.document(userId).get();
    cUser = Cuser.fromDocument(doc);

    await jobRef.document(jobId).setData({
      "ownerId": userId,
      "fullName": cUser.fullName,
      "email": cUser.email,
      "jobId": jobId,
      "position": position,
      "times": times,
      "city": city,
      "address": address,
      "gender": gender,
      "salary": salary,
      "jobDescription": jobDescription,
      "qualities": qualities,
      "dateTime": DateTime.now(),
      "typeCompany": cUser.typeCompany,
      "isVIP": false,
      "isAdvertise": false,
      "savedDateTime": {},
    });
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (ctx) => Home(2),
      ),
      (r) => false,
    );
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.grey.shade800),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            FlatButton(
              onPressed: isWifi?upload:null,
              child: Text(
                "Done",
                style: TextStyle(color: isWifi?Colors.blue:Colors.grey),
              ),
            ),
          ]),
      body: SingleChildScrollView(
              child: Column(
          mainAxisAlignment:isWifi?MainAxisAlignment.start: MainAxisAlignment.center,
          children: <Widget>[
            !isWifi
                ? Loader()
                : isLoading
                    ? LinearProgressIndicator()
                    : Padding(
                        padding: EdgeInsets.all(30),
                        child: Center(
                          child: PostTemplate(
                            position: position,
                            times: times,
                            city: city,
                            address: address,
                            gender: gender,
                            salary: salary,
                            jobDescription: jobDescription,
                            qualities: qualities,
                          ),
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
