import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:iraqijob/model.dart/company_user.dart';
import 'package:iraqijob/model.dart/person_user.dart';
import 'package:iraqijob/pages/edit_profile.dart';
import 'package:iraqijob/pages/login_page.dart';
import 'package:iraqijob/pages/seejobs.dart';
import 'package:iraqijob/pages/setting.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:url_launcher/url_launcher.dart' as url;
import 'cv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Profile extends StatefulWidget {
  final String profileId;
  final bool isVisit;

  Profile(this.profileId, this.isVisit);

  @override
  _ProfileState createState() => _ProfileState();
}

Puser pUser;
Cuser cUser;

class _ProfileState extends State<Profile>
    with AutomaticKeepAliveClientMixin<Profile> {
  bool profileIsCompany;
  bool isLoading = false;
  BuildContext ctx;

  String photoUrl;
  String fullName;
  String email;
  String phoneNumber;
  bool isCompany;

  @override
  void initState() {
    getDoc();
    super.initState();
  }

  getDoc() async {
    bool isOwnerProfile = widget.profileId == userId;
    try {
      setState(() {
        isLoading = true;
      });

      if (!isOwnerProfile) {
        DocumentSnapshot doc;
        doc = await cUserRef.document(widget.profileId).get();

        if (doc.exists) {
          cUser = Cuser.fromDocument(doc);
          profileIsCompany = true;
        } else {
          doc = await pUserRef.document(widget.profileId).get();
          pUser = Puser.fromDocument(doc);
          profileIsCompany = false;
        }
      } else {
        final prefs = await SharedPreferences.getInstance();
        photoUrl = prefs.getString("photoUrl");
        fullName = prefs.getString("fullName");
        email = prefs.getString("email");
        phoneNumber = prefs.getString("phoneNumber");
        isCompany = prefs.getBool("isCompany");
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {}
  }

  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    ctx = context;
    super.build(context);
    ScreenUtil.init(designSize: Size(360, 640), allowFontScaling: true);
    bool isOwnerProfile = widget.profileId == userId;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: !widget.isVisit
            ? null
            : AppBar(
                iconTheme: IconThemeData(color: Colors.grey.shade700),
                backgroundColor: Colors.white,
                elevation: 0,
              ),
        body: SingleChildScrollView(
                  child: Padding(
            padding: !widget.isVisit
                ? const EdgeInsets.only(top: 70.0)
                : EdgeInsets.only(top: 1),
            child: Container(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  isOwnerProfile ? ownerButtons() : otherButton()
                ],
              ),
            ),
          ),
        ));
  }

  otherButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        if (isLoading) ...{
          CircleAvatar(
            radius: 55,
            backgroundColor: Colors.grey.shade100,
          ),
        } else if (profileIsCompany
            ? cUser.photoUrl != null
            : pUser.photoUrl != null) ...{
          CircleAvatar(
            backgroundImage: NetworkImage(
                profileIsCompany ? cUser.photoUrl : pUser.photoUrl),
            radius: 55,
            backgroundColor: Colors.grey.shade100,
          ),
        } else ...{
          CircleAvatar(
            child: FittedBox(
                child:
                    Text(profileIsCompany ? cUser.fullName : pUser.fullName)),
            radius: 55,
            backgroundColor: Colors.grey.shade100,
          )
        },
        SizedBox(height: ScreenUtil().setHeight(15)),
        Text(
          isLoading
              ? "User name"
              : (profileIsCompany ? cUser.fullName : pUser.fullName),
          style: TextStyle(
            color: isLoading ? Colors.grey.shade100 : Colors.black,
            fontSize: ScreenUtil().setSp(18),
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          isLoading
              ? "example@ex.com"
              : profileIsCompany ? cUser.email : pUser.email,
          style: TextStyle(
            color: isLoading ? Colors.grey.shade100 : Colors.grey,
            fontSize: ScreenUtil().setSp(15),
          ),
        ),
        SizedBox(
          height: ScreenUtil().setHeight(30),
        ),
        Container(
          width: ScreenUtil().setWidth(220),
          height: ScreenUtil().setHeight(40),
          child: RaisedButton(
            highlightElevation: 0,
            elevation: 0,
            color: isLoading
                ? Colors.grey.shade100
                : Color.fromRGBO(255, 240, 90, 0.8),
            child: isLoading
                ? null
                : FittedBox(
                                  child: Text(
                      profileIsCompany ? "See Jobs" : "See CV",
                      style: TextStyle(
                          color: Colors.black, fontSize: ScreenUtil().setSp(15)),
                    ),
                ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            onPressed: isLoading
                ? () {}
                : () {
                    profileIsCompany
                        ? Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (coontext) => SeeJobs(widget.profileId),
                            ),
                          )
                        : Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (coontext) =>
                                  CV(widget.profileId, false),
                            ),
                          );
                  },
          ),
        ),
        SizedBox(height: ScreenUtil().setHeight(30)),
        buttons("Send E-Mail", sendEmailAction, OMIcons.email,
            Icons.arrow_forward_ios),
        SizedBox(
          height: ScreenUtil().setHeight(20),
        ),
        buttons("Call", callAction, OMIcons.call, Icons.arrow_forward_ios),
        SizedBox(
          height: ScreenUtil().setHeight(20),
        ),
        buttons(
            "Report", reportAction, OMIcons.report, Icons.arrow_forward_ios),
        SizedBox(
          height: ScreenUtil().setHeight(20),
        ),
      ],
    );
  }

  void sendEmailAction() async {
    if (profileIsCompany) {
      if (await url.canLaunch("mailto:${cUser.email}?subject=&body=")) {
        await url.launch("mailto:${cUser.email}?subject=&body=");
      }
    } else {
      if (await url.canLaunch("mailto:${pUser.email}?subject=&body=")) {
        await url.launch("mailto:${pUser.email}?subject=&body=");
      }
    }
  }

  void callAction() async {
    if (profileIsCompany) {
      if (await url.canLaunch("tel:${cUser.phoneNumber}")) {
        await url.launch("tel:${cUser.phoneNumber}");
      }
    } else {
      if (await url.canLaunch("tel:${pUser.phoneNumber}")) {
        await url.launch("tel:${pUser.phoneNumber}");
      }
    }
  }

  void reportAction() async {
    if (profileIsCompany) {
      if (await url.canLaunch(
          "mailto:ramankanabi@gmail.com?subject=reporting ${cUser.email}&body=")) {
        await url.launch(
            "mailto:ramankanabi@gmail.com?subject=reporting ${cUser.email}&body=");
      }
    } else {
      if (await url.canLaunch(
          "mailto:ramankanabi@gmail.com?subject=reporting ${pUser.email}&body=")) {
        await url.launch(
            "mailto:ramankanabi@gmail.com?subject=reporting ${pUser.email}&body=");
      }
    }
  }

  void editProfileAction() async {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => EditProfile(),
          ),
        )
        .then((value) => getDoc());
  }

  ownerButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        if (isLoading) ...{
          CircleAvatar(
            radius: 55,
            backgroundColor: Colors.grey.shade100,
          ),
        } else if (photoUrl != null) ...{
          CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(photoUrl),
            radius: 55,
            backgroundColor: Colors.grey.shade100,
          ),
        } else ...{
          CircleAvatar(
            child: FittedBox(child: Text(fullName)),
            radius: 55,
            backgroundColor: Colors.grey.shade100,
          )
        },
        SizedBox(height: ScreenUtil().setHeight(15)),
        Text(
          isLoading ? "User name" : (fullName),
          style: TextStyle(
            color: isLoading ? Colors.grey.shade100 : Colors.black,
            fontSize: ScreenUtil().setSp(18),
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          isLoading ? "example@ex.com" : email,
          style: TextStyle(
            color: isLoading ? Colors.grey.shade100 : Colors.grey,
            fontSize: ScreenUtil().setSp(15),
          ),
        ),
        SizedBox(
          height: ScreenUtil().setHeight(30),
        ),
        Container(
          width: ScreenUtil().setWidth(220),
          height: ScreenUtil().setHeight(45),
          child: RaisedButton(
            highlightElevation: 0,
            elevation: 0,
            color: isLoading
                ? Colors.grey.shade100
                : Color.fromRGBO(255, 240, 90, 0.8),
            child: isLoading
                ? null
                : FittedBox(
                  child: Text(
                      (isCompany ? "Your Jobs" : "Your CV"),
                      style: TextStyle(
                          color: Colors.black, fontSize: ScreenUtil().setSp(15)),
                    ),
                ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            onPressed: isLoading
                ? () {}
                : () {
                    isCompany
                        ? Navigator.of(context).push(MaterialPageRoute(
                            builder: (coontext) => SeeJobs(widget.profileId)))
                        : Navigator.of(context).push(MaterialPageRoute(
                            builder: (coontext) => CV(widget.profileId, true)));
                  },
          ),
        ),
        SizedBox(height: ScreenUtil().setHeight(30)),
        buttons(
          "Edit Profile ",
          editProfileAction,
          OMIcons.person,
          Icons.arrow_forward_ios,
        ),
        SizedBox(
          height: ScreenUtil().setHeight(20),
        ),
        buttons(
          "Settings",
          () {
            try {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => SettingPage(),
                ),
              ).then((value) => getDoc());
            } catch (er) {}
          },
          OMIcons.settings,
          Icons.arrow_forward_ios,
        ),
        SizedBox(
          height: ScreenUtil().setHeight(20),
        ),
        buttons(
          "Logout",
          _logOutDialog,
          OMIcons.exitToApp,
          null,
        ),
        SizedBox(
          height: ScreenUtil().setHeight(20),
        )
      ],
    );
  }

  buttons(String title, Function action, IconData icon1, IconData icon2) {
    return Container(
      width: ScreenUtil().setWidth(300),
      height: ScreenUtil().setHeight(50),
      child: RaisedButton(
          highlightElevation: 0,
          elevation: 0,
          color:
              isLoading ? Colors.grey.shade100 : Colors.blue.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: isLoading
                ? null
                : Row(children: [
                    Icon(icon1, color: Colors.grey.shade800, size: 18),
                    SizedBox(
                      width: ScreenUtil().setWidth(15),
                    ),
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.grey.shade800,
                      ),
                    ),
                    Spacer(),
                    Icon(icon2, color: Colors.grey, size: 13),
                  ]),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          onPressed: isLoading ? () {} : action),
    );
  }

  void _logOutDialog() {
    showDialog(
        context: ctx,
        builder: (ctx) => AlertDialog(
              title: Text("Log out"),
              content: Text("Do yo want to log out ?"),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
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
                        await auth
                            .signOut()
                            .then((_) async{ 
                              await SharedPreferences.getInstance().then((value) => value.clear());
                              
                              Navigator.of(ctx).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (ctx) => LoginPage(),
                                ),
                                (e) => false);});

                        setState(() {
                          isLoading = false;
                        });
                      } catch (er) {}
                    },
                    child: Text(
                      "Sign out",
                      style: TextStyle(color: Colors.red),
                    )),
              ],
            ));
  }
}
