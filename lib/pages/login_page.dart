import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iraqijob/signup_pages/forget_password.dart';
import 'package:iraqijob/signup_pages/option_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:iraqijob/widget/loader.dart';
import '../signup_pages/verification.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'home.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPage createState() => _LoginPage();
}

final pUserRef = Firestore.instance.collection("personal user");
final cUserRef = Firestore.instance.collection("company user");
final cvRef = Firestore.instance.collection("cv");
final jobRef = Firestore.instance.collection("job hiring");
final jobSavedRef = Firestore.instance.collection("searching company user");
final advertiseRef = Firestore.instance.collection("advertise");
final storageRef = FirebaseStorage.instance.ref();

String userId;
FirebaseUser user;
FirebaseAuth auth = FirebaseAuth.instance;
bool isLogged = false;
bool isShowSplash = false;

class _LoginPage extends State<LoginPage> {
  TextEditingController emailController;
  TextEditingController passController;
  FocusNode passNode = FocusNode();
  bool isLoading = false;
  bool passHidden = true;
  bool isShowSplashScreen = false;
  String emailSaved;
  String passSaved;

  @override
  void initState() {
    emailController = TextEditingController();
    passController = TextEditingController();
    try {
      autoSignIn();
    } catch (er) {
      setState(() {
        isLoading = false;
      });
      print(er);
      print("raman kuy");
    }

    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  autoSignIn() async {
    setState(() {
      isShowSplash = true;
      isLoading = true;
    });
    
    auth.onAuthStateChanged.listen((currentUser) {
      if (currentUser != null && currentUser.isEmailVerified) {
        setState(() {
          user = currentUser;
          userId = currentUser.uid;
          isLoading = false;
          isLogged = true;
        });
      } else {
        setState(() {
          isShowSplash = false;
          isLoading = false;
          isLogged = false;
        });
      }
    });
  }

////////////////////////////////////SIGN IN/////////////////////////////////////////////////
  Future<void> signin(String email, String password) async {
    setState(() {
      isLoading = true;
    });
    try {
      isShowSplash = false;
      await auth.signInWithEmailAndPassword(email: email, password: password);
      user = await auth.currentUser();
      userId = user.uid;

      if (!user.isEmailVerified) {
        user.sendEmailVerification();

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (ctx) => Verification(user, false)),
            (f) => false);
        // Future(() async {
        //   _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
        //     user = await FirebaseAuth.instance.currentUser()
        //       ..reload();

        //     if (user.isEmailVerified) {
        //       setState(() {
        //         isVerified = user.isEmailVerified;
        //       });
        //       timer.cancel();
        //     }
        //   });
        // });
      } else {
        setState(() {
          isLogged = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        auth=null;
        isLoading = false;
        isLogged = false;
      });
      String errorMessage = "";

      if (e.message.toString().contains(
          "The password is invalid or the user does not have a password")) {
        setState(() {
          errorMessage = "The Password is wrong ";
        });
      } else if (e.message.toString().contains(
          "There is no user record corresponding to this identifier. The user may have been deleted.")) {
        setState(() {
          errorMessage = "Could not find a user with that email";
        });
      } else if (e.message
          .toString()
          .contains("The user account has been disabled by an administrator")) {
        setState(() {
          errorMessage = "The user has been disabled";
        });
      } else {
        errorMessage = "Failed";
      }
      _showErrorDialog(errorMessage);
    }
  }

////////////////////////////////////BUILD AUTH PAGE/////////////////////////////////////////////////
  buildAuthPage() {
    return Home();
  }

////////////////////////////////////MAIN WIDGET/////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(designSize: Size(360, 640), allowFontScaling: true);
    return (isLogged ? (buildAuthPage()) : buildUnauthPage());
  }

//////////////////////////////////// BUILD UNAUTH  PAGE/////////////////////////////////////////////////

  buildUnauthPage() {
    return WillPopScope(
      onWillPop: () {
        return exit(0);
      },
      child: Scaffold(
          body: isLoading
              ? Loader()
              : Container(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ListView(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Container(
                            width: ScreenUtil().setHeight(220),
                            height: ScreenUtil().setHeight(200),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image:
                                    AssetImage("asset/images/firstImage.png"),
                              ),
                            ),
                          ),
                        ),
                        Text(
                          "Welcome Back !",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: ScreenUtil().setSp(25),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Form(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              TextFormField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context).requestFocus(passNode);
                                },
                                decoration: InputDecoration(
                                  labelText: "E-Mail",
                                  labelStyle: TextStyle(color: Colors.grey),
                                ),
                              ),
                              TextFormField(
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: passHidden,
                                controller: passController,
                                focusNode: passNode,
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
                                  labelStyle: TextStyle(color: Colors.grey),
                                ),
                              ),
                              Row(children: [
                                Spacer(),
                                Container(
                                  child: FlatButton(
                                      child: Text(
                                        "Forgot Password ?",
                                        style: TextStyle(
                                            color: Colors.grey.shade800,
                                            fontSize: ScreenUtil().setSp(10)),
                                        textAlign: TextAlign.end,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ForgetPassword()));
                                      }),
                                )
                              ]),
                              SizedBox(height: ScreenUtil().setHeight(15)),
                              Container(
                                width: ScreenUtil().setWidth(200),
                                height: ScreenUtil().setHeight(40),
                                child: RaisedButton(
                                  color: Theme.of(context).primaryColor,
                                  child: Text(
                                    "LOGIN",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  onPressed: () async {
                                    await signin(emailController.text.trim(),
                                        passController.text);
                                  },
                                ),
                              ),
                              SizedBox(height: ScreenUtil().setHeight(15)),
                              Container(
                                width: ScreenUtil().setWidth(200),
                                height: ScreenUtil().setHeight(40),
                                child: FlatButton(
                                  highlightColor: Colors.white12,
                                  splashColor: Colors.white12,
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (ctx) => OptionPage()));
                                  },
                                  child: Text(
                                    "Create Account",
                                    style: TextStyle(
                                        color: Colors.grey.shade900,
                                        fontSize: ScreenUtil().setSp(12)),
                                  ),
                                ),
                              ),
                            ],
                          )),
                        )
                      ],
                    ),
                  ))),
    );
  }

  splashScreen() {
    return Center(
      child: Text("splash Screen "),
    );
  }
////////////////////////////////////SHOW ERROR DIALOG /////////////////////////////////////////////////

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
