import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class VIPpackage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   ScreenUtil.init(designSize: Size(360, 640), allowFontScaling: true);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "VIP Package",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        elevation: 0.4,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.grey.shade800),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              Text(
                "What's VIP package? If you upload CV or Job hiring then it shows in the top 10 trendings for one week and it helps you to get a job or employee as quickly as possible,"
                "Why top 10 or why we will give just 10 accounts? because we create this application for everyone, that means if the number of our VIP package is more than 10 then our goal will fail,"
                " Our goals is to help all jobless people in iraq and Kurdistan to find a job without any difference ",
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: ScreenUtil().setSp(14),
                ),
                textAlign: TextAlign.justify,
                softWrap: true,
              ),
              SizedBox(height: ScreenUtil().setHeight(30)),
              Text(
                "Contact the below telegram account for getting a VIP package .",
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
    );
  }
}
