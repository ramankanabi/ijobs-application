import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdvertisePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(designSize: Size(360, 640), allowFontScaling: true);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Advertise",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        elevation: 0.4,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.grey.shade800),
      ),
      body: SingleChildScrollView(
              child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                Text(
                  "We provide advertisement in our application, so that you can request your Brand, Account or"
                  "anything else to be advertised in our application."
                  "Your Ad will be showing up to all the users that are registered in the app,"
                  "you are going to get charged 15\$ for every 500 views .",
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: ScreenUtil().setSp(14),
                  ),
                  textAlign: TextAlign.justify,
                  softWrap: true,
                ),
                SizedBox(height: ScreenUtil().setHeight(30)),
                Text(
                  "Contact the below telegram account for Advertising .",
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: ScreenUtil().setSp(14),
                  ),
                  textAlign: TextAlign.justify,
                  softWrap: true,
                ),
                SizedBox(height: ScreenUtil().setHeight(20)),
                GestureDetector(
                  onTap: () {
                    launch(
                      "https://t.me/raman_kanabi",
                    );
                  },
                  child: Chip(
                    backgroundColor: Colors.blue,
                    label: Text(
                      "Telegram",
                    ),
                    labelStyle: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    elevation: 3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
