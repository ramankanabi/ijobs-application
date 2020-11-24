import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class BuildCV extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(designSize: Size(360, 640), allowFontScaling: true);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Build a CV",
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
                  "Nowdays in order to get any job you will have to have a proffesional CV ,if you don't have a personal CV or  a nonproffesional one "
                  "don't worry you can contact us and we are like JII staff can create a proffesional CV for you at a shortest amount time "
                  "with a good price (7000 IQD) .",
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: ScreenUtil().setSp(14),
                  ),
                  textAlign: TextAlign.justify,
                  softWrap: true,
                ),
                SizedBox(height:ScreenUtil().setHeight(30)),
                Text(
                  "Contact the below telegram account for building a personal CV .",
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: ScreenUtil().setSp(14),
                  ),
                  textAlign: TextAlign.justify,
                  softWrap: true,
                ),
                SizedBox(height:ScreenUtil().setHeight(20)),
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
