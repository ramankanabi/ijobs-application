import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(designSize: Size(360, 640), allowFontScaling: true);
    return Center(
      child: Container(
          alignment: Alignment.center,
          height:ScreenUtil().setHeight(85),
          width:ScreenUtil().setWidth(85),
          child: Lottie.asset("asset/loader.json")),
    );
  }
}
