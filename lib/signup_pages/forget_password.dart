import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iraqijob/widget/loader.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  String emailSaved;

  bool isDone = false;
  bool isLoading = false;

  GlobalKey<FormState> formKey = GlobalKey();

  submit() async {
    if (!formKey.currentState.validate()) {
      return;
    }
    setState(() {
      isLoading = true;
    });

    formKey.currentState.save();
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailSaved);
      setState(() {
        isDone = true;
        isLoading = false;
      });
    } catch (err) {
      String errMessage = "Failed";

      if (err.message.contains("The email address is badly formatted")) {
        errMessage = "Please write the correct email address .";
      } else if (err.message.contains(
          "There is no user record corresponding to this identifier. The user may have been deleted.")) {
        errMessage =
            "The email address was not found or it may have been deleted .";
      } else {
        errMessage = err.message;
      }
      _showErrorDialog(errMessage);

      setState(() {
        isDone = false;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(designSize: Size(360, 640), allowFontScaling: true);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(50),
        child: Container(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: isLoading
                  ? Loader()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: ScreenUtil().setHeight(20)),
                        Text(
                          "Reset password",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: ScreenUtil().setSp(26),
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: ScreenUtil().setHeight(50)),
                        if (isDone) ...{
                          if (!isLoading) ...{
                            Container(
                              alignment: Alignment.center,
                              child: Icon(Icons.check_circle, size: 80),
                            ),
                          },
                          SizedBox(height: ScreenUtil().setHeight(30)),
                          isLoading
                              ? Loader()
                              : Text(
                                  "A password reset link has successfully been sent to your email addreess .",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: ScreenUtil().setSp(18),
                                  ),
                                ),
                          SizedBox(height: ScreenUtil().setHeight(20)),
                          Container(
                            height: ScreenUtil().setHeight(40),
                            child: FlatButton(
                                child: Text(
                                  "Login Page ",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                }),
                          ),
                        } else ...{
                          Form(
                            key: formKey,
                            child: TextFormField(
                              decoration: InputDecoration(labelText: "E-Mail"),
                              keyboardType: TextInputType.emailAddress,
                              validator: (val) {
                                if (val.isEmpty) {
                                  return "Please enter your email address .";
                                } else if (!val.contains("@")) {
                                  return "Please enter the correct email address .";
                                }
                              },
                              onSaved: (val) {
                                emailSaved = val;
                              },
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(40),
                          ),
                          Container(
                            height: ScreenUtil().setHeight(40),
                            child: RaisedButton(
                                color: Theme.of(context).primaryColor,
                                child: Text(
                                  "Submit",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                onPressed: () {
                                  submit();
                                }),
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(20),
                          ),
                          Container(
                            height: ScreenUtil().setHeight(40),
                            child: FlatButton(
                                child: Text(
                                  "Go Back ",
                                  style: TextStyle(
                                    color:
                                        Colors.grey.shade600.withOpacity(0.9),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                }),
                          ),
                        },
                      ],
                    ),
            )),
      ),
    );
  }

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
