import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iraqijob/pages/login_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iraqijob/widget/loader.dart';
class ChangePassword extends StatefulWidget {
  ChangePassword({Key key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController currentController = TextEditingController();
  TextEditingController newController = TextEditingController();

  String currentPasswordValue;
  String newPasswordValue;
  GlobalKey<FormState> formKey = GlobalKey();
  bool currentPassHidden = true;
  bool newPassHidden = true;
  FocusNode passNode = FocusNode();
  bool isLoading = false;
  _save() async {
    if (!formKey.currentState.validate()) {
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });
      formKey.currentState.save();
      final auth = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: user.email, password: currentPasswordValue);
      auth.user.updatePassword(newPasswordValue);
      setState(() {
        isLoading = false;
        Navigator.pop(context);
      });
    } catch (e) {
      String errorMessage = "";
      print(e);
      if (e.message.toString().contains(
          "The password is invalid or the user does not have a password")) {
        setState(() {
          errorMessage = "The current password is wrong ";
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
      setState(() {
        isLoading = false;
      });
      _showErrorDialog(errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(designSize: Size(360, 640), allowFontScaling: true);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey.shade700),
        title: Text(
          "Change Password",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        backgroundColor: Colors.white,
        elevation: 0.4,
        actions: [
          FlatButton(
            child: Text(
              "Save",
              style: TextStyle(color: Colors.blue),
            ),
            onPressed: isLoading ? null : _save,
          ),
        ],
      ),
      body: isLoading
          ? Loader()
          : SingleChildScrollView(
                      child: Padding(
                padding: EdgeInsets.all(15),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: currentPassHidden,
                        controller: currentController,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              icon: Icon(
                                currentPassHidden
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  currentPassHidden = !currentPassHidden;
                                });
                              }),
                          labelText: "Current password",
                          labelStyle: TextStyle(color: Colors.grey),
                        ),
                        validator: (val) {
                          if (val.isEmpty) {
                            return "enter a password .";
                          }
                        },
                        onSaved: (val) {
                          currentPasswordValue = val;
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(passNode);
                        },
                      ),
                      SizedBox(height:  ScreenUtil().setHeight(5)),
                      TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: newPassHidden,
                        controller: newController,
                        focusNode: passNode,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              icon: Icon(
                                newPassHidden
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  newPassHidden = !newPassHidden;
                                });
                              }),
                          labelText: "New password",
                          labelStyle: TextStyle(color: Colors.grey),
                        ),
                        validator: (val) {
                          if (val.length < 6) {
                            return "Password must be at least 6 characters .";
                          }
                        },
                        onSaved: (val) {
                          newPasswordValue = val;
                        },
                      ),
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
              title: Text("Changing password "),
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
