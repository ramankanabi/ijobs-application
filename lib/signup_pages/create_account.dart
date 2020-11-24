import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iraqijob/pages/login_page.dart' as login;
import 'package:iraqijob/widget/loader.dart';
import 'p_c_information1.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'option_page.dart' as option;
import 'package:connectivity/connectivity.dart';

class CreatAccount extends StatefulWidget {
  @override
  _CreatAccountState createState() => _CreatAccountState();
}

FirebaseUser user;

String fullName;
String eMail;
String password;

class _CreatAccountState extends State<CreatAccount> {
///////////////////////////////////VARIABLES/////////////////////////////////////
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool passHidden = true;
  bool isLoading = false;
  GlobalKey<FormState> formKey = GlobalKey();
  FocusNode passNode = FocusNode();
  FocusNode emailNode = FocusNode();
  RegExp validateFullName = RegExp(r"^[a-zA-Z\s]+$");
  RegExp validateFullName2 = RegExp(r"^[\s]+$");
  RegExp validateEmail = RegExp(
      r"^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$");

/////////////////////////////////// CHECK SIGN UP/////////////////////////////////////

  checkSignUp() async {
    if (!formKey.currentState.validate()) {
      return;
    }

    formKey.currentState.save();

    setState(() {
      isLoading = true;
    });
    final doc =
        await login.pUserRef.where("email", isEqualTo: eMail).getDocuments();
    final doc2 =
        await login.cUserRef.where("email", isEqualTo: eMail).getDocuments();

    if (doc2.documents.isNotEmpty || doc.documents.isNotEmpty) {
      _showErrorDialog("The email address is already in use .");
    } else {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => PCinformation()));
      passwordController.text = password;
      emailController.text = eMail;
      fullNameController.text = fullName;
    }
    setState(() {
      isLoading = false;
    });
  }

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
    super.initState();
  }

///////////////////////////////////MAIN WIDGET/////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(designSize: Size(360, 640), allowFontScaling: true);
    return Scaffold(
        body: isLoading || !isWifi
            ? Loader()
            : SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 40.0, left: 30, right: 30),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 40.0),
                          child: Text(
                            "It's greate to\nsee you !",
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
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextFormField(
                                  controller: fullNameController,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    labelText: option.isCompany
                                        ? "Company Name"
                                        : "Full Name",
                                    labelStyle: TextStyle(
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(emailNode);
                                  },
                                  validator: (val) {
                                    if (val.isEmpty) {
                                      return "please write your full name .";
                                    } else if (validateFullName2
                                        .hasMatch(val)) {
                                      return "Sorry, you can't enter empty space .";
                                    } else if (!validateFullName
                                        .hasMatch(val)) {
                                      return "Sorry, you must type only characters .";
                                    } else if (val.length > 50) {
                                      return "Sorry, max character limit has been reached .";
                                    }
                                  },
                                  onSaved: (val) {
                                    fullName = val;
                                  },
                                ),
                                TextFormField(
                                  controller: emailController,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    labelText: "E-Mail",
                                    labelStyle: TextStyle(
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  focusNode: emailNode,
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(passNode);
                                  },
                                  validator: (val) {
                                    if (!validateEmail.hasMatch(val)) {
                                      return "Please write the correct E-mail .";
                                    }
                                  },
                                  onSaved: (val) {
                                    eMail = val.trim();
                                  },
                                ),
                                TextFormField(
                                  controller: passwordController,
                                  obscureText: passHidden,
                                  keyboardType: TextInputType.visiblePassword,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                        icon: Icon(
                                          passHidden
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: Colors.grey,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            passHidden = !passHidden;
                                          });
                                        }),
                                    labelText: "Password",
                                    labelStyle: TextStyle(
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  focusNode: passNode,
                                  validator: (val) {
                                    if (val.length < 6) {
                                      return "Password must be at least 6 characters .";
                                    }
                                  },
                                  onSaved: (val) {
                                    password = val;
                                  },
                                ),
                                SizedBox(
                                  height: ScreenUtil().setHeight(60),
                                ),
                                Container(
                                  width: ScreenUtil().setWidth(200),
                                  height: ScreenUtil().setHeight(40),
                                  child: RaisedButton(
                                      color: Theme.of(context).primaryColor,
                                      child: Text(
                                        "Sign Up",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      onPressed: () {
                                        checkSignUp();
                                      }),
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
                                          color: Colors.grey.shade600
                                              .withOpacity(0.9),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      }),
                                ),
                              ]),
                        ),
                      ]),
                ),
              ));
  }

///////////////////////////////////DIALOG ERROR/////////////////////////////////////
  void _showErrorDialog(String message) {
    showDialog(
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
