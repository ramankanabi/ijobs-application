import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

class CvPostLoader extends StatelessWidget {
  const CvPostLoader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(designSize: Size(360, 640), allowFontScaling: true);
    return Card(
          child: Column(children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey.shade100,
          ),
          title: Text(
            "Personal name",
            style: TextStyle(color: Colors.grey.shade50),
          ),
          subtitle: Text(
            "Time ago",
            style: TextStyle(color: Colors.grey.shade50),
          ),
        ),
        SizedBox(height: ScreenUtil().setHeight(5)),
        Container(
          height: ScreenUtil().setHeight(400),
          width: double.infinity,
          color: Colors.grey.shade100,
        ),
        SizedBox(height: ScreenUtil().setHeight(30)),
        buildPostFooter(),
      ]),
    );
  }

  buildPostFooter() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 0.5, color: Colors.grey),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Row(children: [
            Expanded(
              child: FlatButton.icon(
                onPressed: () {},
                icon: Icon(OMIcons.email),
                label: Text("Email"),
              ),
            ),
            Expanded(
              child: FlatButton.icon(
                onPressed: () {},
                icon: Icon(OMIcons.bookmarkBorder),
                label: Text("Save"),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
