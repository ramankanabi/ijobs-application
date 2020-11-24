import 'package:flutter/material.dart';
import 'company_saved.dart';
import 'home.dart';
import 'personal_saved.dart';

class Saved extends StatefulWidget {
  @override
  _SavedState createState() => _SavedState();
}

class _SavedState extends State<Saved> {
  @override
  Widget build(BuildContext context) {
    return isCompany ? CompanySaved() : PersonalSaved();
  }
}
