import 'package:flutter/material.dart';
import 'package:iraqijob/pages/login_page.dart';

void main() {
  runApp(Jii());
}

class Jii extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Color.fromRGBO(83, 117, 241, 1),
          accentColor: Colors.blue,
          ),
      home: LoginPage(),
    );
  }
}
