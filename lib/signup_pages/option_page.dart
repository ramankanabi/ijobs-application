import 'package:flutter/material.dart';
import 'create_account.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OptionPage extends StatefulWidget {
  @override
  _OptionPageState createState() => _OptionPageState();
}

bool isCompany;

class _OptionPageState extends State<OptionPage> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(designSize: Size(360, 640), allowFontScaling: true);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.grey,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  width: ScreenUtil().setWidth(250),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image:
                            AssetImage("asset/images/1st_pic_pageOption.png"),
                        fit: BoxFit.contain),
                  ),
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(20)),
              Container(
                width: ScreenUtil().setWidth(190),
                height: ScreenUtil().setHeight(50),
                child: OutlineButton(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onPressed: () {
                    isCompany = false;
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CreatAccount()));
                  },
                  child: FittedBox(
                    child: Text("Looking a new job",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenUtil().setSp(15))),
                  ),
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(30)),
              Expanded(
                child: Container(
                  width: ScreenUtil().setWidth(250),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image:
                            AssetImage("asset/images/2nd_pic_pageOption.png"),
                        fit: BoxFit.contain),
                  ),
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(20)),
              Container(
                width: ScreenUtil().setWidth(190),
                height: ScreenUtil().setHeight(50),
                child: OutlineButton(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onPressed: () {
                    isCompany = true;

                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => CreatAccount()));
                  },
                  child: FittedBox(
                    child: Text("Looking a new employees",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: ScreenUtil().setSp(15),
                        )),
                  ),
                ),
              ),
              Divider(
                height: ScreenUtil().setHeight(30),
              )
            ],
          ),
        ),
      ),
    );
  }
}
