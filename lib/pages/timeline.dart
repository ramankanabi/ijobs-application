
import 'package:flutter/material.dart';
import 'package:iraqijob/pages/personal_timeline.dart';

import 'company_timeline.dart';
import 'home.dart';

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  

  @override
  Widget build(BuildContext context) {
    return isCompany==null?Scaffold(body: CircularProgressIndicator(),): (isCompany ? CompanyTimeline() : PersonalTimeline());
  }
}
