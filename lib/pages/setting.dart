import 'package:flutter/material.dart';
import 'package:iraqijob/pages/about.dart';
import 'package:iraqijob/pages/advertise_setting_page.dart';
import 'package:iraqijob/pages/build_cv.dart';
import 'package:iraqijob/pages/vip_package.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'change_password.dart';
import 'edit_profile.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  
  @override
  Widget build(BuildContext context) {
     ScreenUtil.init(designSize: Size(360, 640), allowFontScaling: true);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey.shade700),
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          "Settings",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ),
      body: ListView(
        children: <Widget>[
          listTile("Edit profile", OMIcons.person, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditProfile(),
              ),
            );
          }),
          listTile("Language", OMIcons.translate, () {}),
          listTile("Password", OMIcons.vpnKey, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChangePassword(),
              ),
            );
          }),
          listTile("Build a CV", OMIcons.receipt, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => BuildCV(),
              ),
            );
          }),
          listTile("VIP package", OMIcons.stars, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => VIPpackage(),
              ),
            );
          }),
          listTile("Advertise", OMIcons.redeem, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => AdvertisePage(),
              ),
            );
          }),
          listTile("Report a problem", OMIcons.reportProblem, () async {
            await launch(
              "mailto:ramankanabi@gmail.com?subject= report a problem &body=",
            );
          }),
          listTile("About", OMIcons.info, () {
            try {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => AboutPage(),
                ),
              );
            } catch (er) {}
          }),
        ],
      ),
    );
  }

  listTile(String title, IconData icon, Function action) {
    return Container(
      child: ListTile(
        contentPadding: EdgeInsets.only(
          left: 10,
          right: 10,
        ),
        isThreeLine: false,
        title: Text(title, style: TextStyle(fontSize: ScreenUtil().setSp(14))),
        onTap: action,
        leading: Icon(icon, color: Colors.grey.shade800, size: 25),
        trailing: Icon(OMIcons.arrowForwardIos, color: Colors.grey, size: 13),
      ),
    );
  }
}
