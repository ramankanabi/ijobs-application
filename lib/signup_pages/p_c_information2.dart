import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iraqijob/pages/login_page.dart';
import 'package:iraqijob/signup_pages/create_account.dart';
import 'package:iraqijob/signup_pages/verification.dart';
import 'package:iraqijob/widget/loader.dart';
import 'package:iraqijob/widget/textfield_search_packages.dart';
import 'p_c_information1.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'option_page.dart' as option;
import 'package:connectivity/connectivity.dart';

class PCinformation2 extends StatefulWidget {
  @override
  _PCinformation2State createState() => _PCinformation2State();
}

String userId;

class _PCinformation2State extends State<PCinformation2> {
  ///////////////////////// VARIABLES ///////////////////////////////////////////

  FocusNode passNode = FocusNode();
  FocusNode emailNode = FocusNode();

  FirebaseUser user;

  GlobalKey<FormState> formKey = GlobalKey();
  // bool isTry = false;
  bool isLoading = false;

  bool passHidden = true;
  String describe;
  String dropDownValue;
  bool showErrorText = false;
  TextEditingController controller = TextEditingController();

  List<String> typeOfCompany = [
    "airline company",
    "car company",
    "cafe",
    "cleaning service company",
    "clothing company",
    "computer store",
    "concrete factory",
    "construction company",
    "delivery service",
    "educational segments",
    "electric company",
    "finance and banking company",
    "food company",
    "furniture company",
    "glass industrial",
    "market",
    "media company",
    "medical group",
    "mobile store",
    "oil company",
    "print shop",
    "restaurant",
    "shopping mall",
    "software company",
    "steel company",
    "telecommunication company",
    "transportation service",
    "other",
  ];

////////////////////////////////DONE/////////////////////////////////////////////////////////////////////////////
  done() async {
    if (!formKey.currentState.validate()) {
      return;
    } else if (!typeOfCompany.contains(controller.text) ||
        controller.text == null) {
      setState(() {
        showErrorText = true;
      });
      return;
    }
    formKey.currentState.save();

    setState(() {
      showErrorText = false;
      isLoading = true;

      // isTry = false;
    });

    try {
      user = (await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: eMail, password: password))
          .user;

      userId = user.uid;
      await saveToDatabase();
      await user.sendEmailVerification();

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Verification(user, true),
          ),
          (e) => false);

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      String errMessage = "";

      if (e.message
          .toString()
          .contains("The email address is already in use by another account")) {
        errMessage = "The email address is already in use";
      } else if (e.message
          .toString()
          .contains("The email address is badly formatted")) {
        errMessage = "The email is bad";
      } else if (e.message
          .toString()
          .contains("The given password is invalid")) {
        errMessage = "Password should be at least 6 charachters";
      } else {
        errMessage = "Sign up is failed";
      }
      setState(() {
        isLoading = false;
      });
      await _showErrorDialog(errMessage);
      setState(() {
        isLoading = false;
      });
    }
  }

///////////////////////// MAIN WIDGET ///////////////////////////////////////////
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

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(designSize: Size(360, 640), allowFontScaling: true);
    return Scaffold(
      body: isLoading || !isWifi
          ? WillPopScope(onWillPop: () {}, child: Loader())
          : Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Container(
                    alignment: Alignment.center,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Text(
                              option.isCompany
                                  ? "Company\ninformation"
                                  : "Personal\ninformation",
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: ScreenUtil().setSp(33),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(40)),
                          Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFieldSearch(
                                  controller: controller,
                                  label: option.isCompany
                                      ? "Type Of Company"
                                      : "Interested Companys",
                                  initialList: typeOfCompany,
                                  isAddJob: false,
                                  isCity: false,
                                ),
                                if (showErrorText) ...{
                                  SizedBox(height: ScreenUtil().setHeight(5)),
                                  Text(
                                    option.isCompany
                                        ? "This type is'nt found"
                                        : "this company is'nt found",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: ScreenUtil().setSp(10)),
                                  ),
                                },
                                if (option.isCompany) ...{
                                  TextFormField(
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                      labelText: "Describe the company ",
                                      labelStyle: TextStyle(
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                    onSaved: (val) {
                                      describe = val;
                                    },
                                    validator: (val) {
                                      if (val.length > 400) {
                                        return "Sorry, max character limit has been reached .";
                                      }
                                    },
                                  ),
                                },
                              ],
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(80),
                          ),
                          buttons()
                        ]),
                  ),
                ),
              ),
            ),
    );
  }

  /////////////////////////////// BUTTONS /////////////////////////////////////////////////////

  Widget buttons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: ScreenUtil().setWidth(200),
          height: ScreenUtil().setHeight(40),
          child: RaisedButton(
            color: Theme.of(context).primaryColor,
            child: Text(
              "Done",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onPressed: () {
              done();
            },
          ),
        ),
        SizedBox(
          height: ScreenUtil().setHeight(20),
        ),
        Container(
          width: ScreenUtil().setWidth(200),
          height: ScreenUtil().setHeight(40),
          child: FlatButton(
              child: Text(
                "Go Back ",
                style: TextStyle(
                  color: Colors.grey.shade600.withOpacity(0.9),
                  fontWeight: FontWeight.bold,
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ),
      ],
    );
  }

  ///////////////////////// SAVE TO DATABSE /////////////////////////////////////////////////////

  saveToDatabase() async {
    if (!option.isCompany) {
      await pUserRef.document(userId).setData({
        "userId": userId,
        "email": eMail.toLowerCase(),
        "fullName": fullName.toLowerCase(),
        "city": city.toLowerCase(),
        "address": address.toLowerCase(),
        "birthYear": birthYear,
        "interestedCompany": controller.text,
        "isCompany": option.isCompany,
        "photoUrl": null,
        "phoneNumber": phoneNumber,
        "gender": genderValue.toLowerCase(),
        "dateTime": DateTime.now(),
      });
    } else if (option.isCompany) {
      await cUserRef.document(userId).setData({
        "userId": userId,
        "email": eMail.toLowerCase(),
        "fullName": fullName.toLowerCase(),
        "city": city.toLowerCase(),
        "address": address.toLowerCase(),
        "typeCompany": controller.text,
        "isCompany": option.isCompany,
        "description": describe,
        "photoUrl": null,
        "phoneNumber": phoneNumber,
        "dateTime": DateTime.now(),
      });
    }
  }

///////////////////////////////////////////////////SHOW ERROR DIALOGG///////////////////////////////////////////////////
  _showErrorDialog(String message) async {
    await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text("Failed"),
              content: Text(message),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text("OKEY"))
              ],
            ));
  }
}
