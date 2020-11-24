import 'package:flutter/material.dart';
import 'package:iraqijob/pages/company_explorer.dart';
import 'package:iraqijob/pages/home.dart'as home;
import 'personal_explorer.dart';

class Explorer extends StatelessWidget {
  const Explorer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return home.isCompany ? CompanyExplorer() : PersonalExplorer();
  }
}
