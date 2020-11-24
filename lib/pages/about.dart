import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutPage extends StatefulWidget {
  AboutPage({Key key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(designSize: Size(360, 640), allowFontScaling: true);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey.shade700),
        title: Text(
          "About",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        backgroundColor: Colors.white,
        elevation: 0.4,
      ),
      body: SingleChildScrollView(
              child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(children: [
              Text(
                "Job In Iraq (JII) is a mobile application which used to finding jobs or hiring an employees ,"
                "the application is available for any one who either lives in iraq or kurdistan. If you are searching for a job we can help you to build your CV and find a job,"
                "And if you own a company we can help you to find the best employee that fits your requirement.\n\n"
                "Also we have a VIP package for our premium members, what's VIP package? If you upload CV or Job hiring then it shows in the top 10 trendings for one week and it helps you to get a job or employee as quickly as possible,"
                "Why top 10 or why we will give just 10 accounts? because we create this application for everyone, that means if the number of our VIP package is more than 10 then our goal will fail,"
                " Our goals is to help all jobless people in iraq and Kurdistan to find a job without any difference "
                "And the application income is used for improving the application (JII) and our employee salary .",
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: ScreenUtil().setSp(14),
                ),
                textAlign: TextAlign.justify,
                softWrap: true,
              ),
              SizedBox(height: ScreenUtil().setHeight(30)),
             
              Text(
                "Contact us ",
                style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: ScreenUtil().setSp(16),
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: ScreenUtil().setHeight(20)),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                GestureDetector(
                  onTap: () async {
                    await launch("https://www.facebook.com/raman.kanabi");
                  },
                  child: Chip(
                    backgroundColor: Colors.blueAccent.shade700,
                    label: Text("Facebook"),
                    labelStyle: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    elevation: 3,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    launch("https://www.instagram.com/1ramaan/");
                  },
                  child: Chip(
                    backgroundColor: Colors.pink,
                    label: Text("Instagram"),
                    labelStyle: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    elevation: 3,
                  ),
                ),
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
              ])
            ]),
          ),
        ),
      ),
    );
  }
}
