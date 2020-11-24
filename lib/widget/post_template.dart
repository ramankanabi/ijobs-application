import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostTemplate extends StatelessWidget {
  final String position;
  final String times;
  final String city;
  final String address;
  final String gender;
  final String salary;
  final String jobDescription;
  final String qualities;

  PostTemplate({
    @required this.position,
    @required this.times,
    @required this.city,
    @required this.address,
    @required this.gender,
    @required this.salary,
    @required this.jobDescription,
    @required this.qualities,
  });

  factory PostTemplate.fromDocument(doc) {
    return PostTemplate(
      position: doc["position"],
      times: doc["times"],
      city: doc["city"],
      address: doc["address"],
      gender: doc["gender"],
      salary: doc["salary"],
      jobDescription: doc["jobDescription"],
      qualities: doc["qualities"],
    );
  }
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(designSize: Size(360, 640), allowFontScaling: true);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <
        Widget>[
      RichText(
        textAlign: TextAlign.start,
        text: TextSpan(children: [
          TextSpan(
            text: "Position : ",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: ScreenUtil().setSp(16)),
          ),
          TextSpan(
            text: position,
            style: TextStyle(
              color: Colors.grey.shade600,fontSize: ScreenUtil().setSp(16)
            ),
          )
        ]),
      ),
      SizedBox(height: ScreenUtil().setHeight(10)),
      RichText(
        textAlign: TextAlign.start,
        text: TextSpan(children: [
          TextSpan(
            text: "Times : ",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: ScreenUtil().setSp(16)),
          ),
          TextSpan(
            text: times,
            style: TextStyle(
              color: Colors.grey.shade600,fontSize: ScreenUtil().setSp(16)
            ),
          )
        ]),
      ),
      SizedBox(height: ScreenUtil().setHeight(10)),
      RichText(
        textAlign: TextAlign.start,
        text: TextSpan(children: [
          TextSpan(
            text: "City : ",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: ScreenUtil().setSp(16)),
          ),
          TextSpan(
            text: city,
            style: TextStyle(
              color: Colors.grey.shade600,fontSize: ScreenUtil().setSp(16)
            ),
          )
        ]),
      ),
      SizedBox(height: ScreenUtil().setHeight(10)),
      RichText(
        textAlign: TextAlign.start,
        text: TextSpan(children: [
          TextSpan(
            text: "Address : ",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: ScreenUtil().setSp(16)),
          ),
          TextSpan(
            text: address,
            style: TextStyle(
              color: Colors.grey.shade600,fontSize: ScreenUtil().setSp(16)
            ),
          )
        ]),
      ),
      SizedBox(height: ScreenUtil().setHeight(10)),
      RichText(
        textAlign: TextAlign.start,
        text: TextSpan(children: [
          TextSpan(
            text: "Gender : ",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: ScreenUtil().setSp(16)),
          ),
          TextSpan(
            text: gender,
            style: TextStyle(
              color: Colors.grey.shade600,fontSize: ScreenUtil().setSp(16)
            ),
          )
        ]),
      ),
      SizedBox(height: ScreenUtil().setHeight(10)),
      RichText(
        textAlign: TextAlign.start,
        text: TextSpan(children: [
          TextSpan(
            text: "Salary : ",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: ScreenUtil().setSp(16)),
          ),
          TextSpan(
            text: salary,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: ScreenUtil().setSp(16)
            ),
          )
        ]),
      ),
      SizedBox(height: ScreenUtil().setHeight(10)),
      RichText(
        textAlign: TextAlign.start,
        text: TextSpan(children: [
          TextSpan(
            text: "Job Description : ",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: ScreenUtil().setSp(16)),
          ),
          TextSpan(
            text: jobDescription,
            style: TextStyle(
              color: Colors.grey.shade600,fontSize: ScreenUtil().setSp(16)
            ),
          ),
        ]),
      ),
      SizedBox(height: ScreenUtil().setHeight(10)),
      RichText(
        textAlign: TextAlign.start,
        text: TextSpan(children: [
          TextSpan(
            text: "Qualities : ",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: ScreenUtil().setSp(16)),
          ),
          TextSpan(
            text: qualities,
            style: TextStyle(
              color: Colors.grey.shade600,fontSize: ScreenUtil().setSp(16)
            ),
          ),
        ]),
      ),
    ]);
  }
}
