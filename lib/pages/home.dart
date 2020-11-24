import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iraqijob/model.dart/company_user.dart';
import 'package:iraqijob/model.dart/person_user.dart';
import 'package:iraqijob/pages/cv.dart';
import 'package:iraqijob/pages/explorer.dart';
import 'package:iraqijob/pages/my_jobs_hiring.dart';
import 'package:iraqijob/pages/profile.dart';
import 'package:iraqijob/pages/saved.dart';
import 'package:iraqijob/widget/loader.dart';
import 'package:iraqijob/widget/splash_screen.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'login_page.dart' as login;
import 'package:iraqijob/pages/timeline.dart';
import '../signup_pages/p_c_information2.dart' as signup;
import 'package:shared_preferences/shared_preferences.dart' as shared;

class Home extends StatefulWidget {
  final int numPage;
  Home([this.numPage]);
  @override
  _HomeState createState() => _HomeState();
}

bool isCompany;
Cuser cUser;
Puser pUser;
GlobalKey<ScaffoldState> homeScaffoldKey;
var photoUrl;

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin<Home> {
  int pageIndex = 0;
  PageController pageController;
  bool isLoading = false;
  shared.SharedPreferences prefs;

  @override
  void initState() {
    // checkWifi();
    if (signup.userId != null) {
      setState(() {
        login.userId = signup.userId;
      });
    }
    homeScaffoldKey = GlobalKey();
    pageController = PageController(
        initialPage: widget.numPage != null ? widget.numPage : 0);
    pageIndex = widget.numPage != null ? widget.numPage : 0;
    getDoc();

    super.initState();
  }

  getDoc() async {
    setState(() {
      isLoading = true;
    });
    prefs = await shared.SharedPreferences.getInstance();
    DocumentSnapshot doc;
    try {
      doc = await login.cUserRef.document(login.userId).get();
      if (doc.exists) {
        print("isCompany");
        cUser = Cuser.fromDocument(doc);
        isCompany = cUser.isCompany;
        prefs.setString("photoUrl", cUser.photoUrl);
        prefs.setString("fullName", cUser.fullName);
        prefs.setString("email", cUser.email);
        prefs.setString("city", cUser.city);
        prefs.setString("address", cUser.address);
        prefs.setString("phoneNumber", cUser.phoneNumber);
        prefs.setString("typeCompany", cUser.typeCompany);
        prefs.setString("userId", cUser.userId);
        prefs.setBool("isCompany", cUser.isCompany);
        photoUrl = ValueNotifier(prefs.getString("photoUrl"));
      } else {
        print("is not Company");
        doc = await login.pUserRef.document(login.userId).get();
        pUser = Puser.fromDocument(doc);
        isCompany = pUser.isCompany;
        prefs.setString("photoUrl", pUser.photoUrl);
        prefs.setString("fullName", pUser.fullName);
        prefs.setString("email", pUser.email);
        prefs.setString("city", pUser.city);
        prefs.setString("address", pUser.address);
        prefs.setString("phoneNumber", pUser.phoneNumber);
        prefs.setString("interestedCompany", pUser.interestedCompany);
        prefs.setString("userId", pUser.userId);
        prefs.setString("gender", pUser.gender);
        prefs.setBool("isCompany", pUser.isCompany);

        photoUrl = ValueNotifier(prefs.getString("photoUrl"));
      }

      setState(() {
        isLoading = false;
      });
    } catch (er) {
      print("kuy");
    }
  }

  onPageChanged(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  onTap(int index) {
    pageController.jumpToPage(index);
  }

  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      key: homeScaffoldKey,
      body: isLoading || isCompany == null
          ? (login.isShowSplash ? SplashScreen() : Loader())
          : PageView(
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                Timeline(),
                Explorer(),
                if (isCompany) ...{
                  MyJobsHiring()
                } else ...{
                  CV(login.userId, true)
                },
                Saved(),
                Profile(login.userId, false),
              ],
              controller: pageController,
              onPageChanged: onPageChanged,
            ),
      bottomNavigationBar: isLoading
          ? null
          : CupertinoTabBar(
              backgroundColor: Colors.white,
              currentIndex: pageIndex,
              onTap: onTap,
              activeColor: Theme.of(context).primaryColor,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(icon: Icon(OMIcons.home)),
                BottomNavigationBarItem(icon: Icon(OMIcons.explore)),
                BottomNavigationBarItem(
                  icon: Icon(
                    isCompany ? OMIcons.addBox : OMIcons.receipt,
                    color: Colors.black,
                    size: 35,
                  ),
                ),
                BottomNavigationBarItem(
                    icon: Icon(
                  OMIcons.bookmarkBorder,
                )),
                BottomNavigationBarItem(
                  icon: ValueListenableBuilder<String>(
                    valueListenable: photoUrl,
                    builder: (context, value, _) {
                      if (value == null) {
                        return CircleAvatar(
                          child: Center(
                            child: FittedBox(child: Icon(Icons.person)),
                          ),
                          backgroundColor: Colors.grey.shade100,
                          radius: 15,
                        );
                      } else {
                        return CircleAvatar(
                          backgroundImage: NetworkImage(
                            prefs.getString("photoUrl"),
                          ),
                          backgroundColor: Colors.grey.shade100,
                          radius: 15,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
