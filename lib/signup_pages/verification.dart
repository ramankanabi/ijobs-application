import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iraqijob/pages/home.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iraqijob/pages/login_page.dart';
class Verification extends StatefulWidget {
  final bool isRegister;
  final FirebaseUser user;
  Verification(this.user, this.isRegister);
  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  Timer _timer;
  bool isVerified = false;
  bool isPressed = false;
  GlobalKey<ScaffoldState> _scaffold = GlobalKey();

  @override
  void initState() {
    FirebaseUser user = widget.user;

    Future(() async {
      _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
        user = await FirebaseAuth.instance.currentUser()
          ..reload();

        if (user.isEmailVerified) {
          Navigator.of(context)
              .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Home()),(e)=>false);
          timer.cancel();
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  }

  resend() async {
    setState(() {
      isPressed = true;
    });

    Timer(Duration(seconds: 60), () {
      widget.user.sendEmailVerification();
      setState(() {
        isPressed = false;
      });
    });
    return _scaffold.currentState.showSnackBar(SnackBar(
      content: Text("You will get verification code in one minute ."),
      duration: Duration(seconds: 8),
    ));
  }

  @override
  Widget build(BuildContext context) {
     ScreenUtil.init(designSize: Size(360, 640), allowFontScaling: true);
    return WillPopScope(
      onWillPop: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage()
          ),(_)=>false
        );
      },
      child: Scaffold(
        key: _scaffold,
        body: Container(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  FittedBox(
                    child: Text(
                      widget.isRegister
                          ? "Registered successfully\nplease verify your email ."
                          : " please verify your email .",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: ScreenUtil().setSp(23),
                      ),
                    ),
                  ),
                  CircularProgressIndicator(),
                  // SizedBox(height: 30),
                  Column(
                    children: [
                      FlatButton(
                          onPressed: isPressed
                              ? () {}
                              : () {
                                  resend();
                                },
                          child: Text(
                            "Resend",
                            style: TextStyle(
                                color: isPressed ? Colors.grey : Colors.blue,
                                fontSize: ScreenUtil().setSp(15)),
                          )),
                    
                  SizedBox(height: ScreenUtil().setHeight(10)),
                  FlatButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),(er)=>false);
                      },
                      child: Text(
                        "Login page",
                        style: TextStyle(color: Colors.grey, fontSize: ScreenUtil().setSp(15)),
                      )),
                ],
              ),],
                  ),
            )),
      ),
    );
  }
}
