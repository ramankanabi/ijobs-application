import 'package:flutter/material.dart';
import 'package:iraqijob/widget/loader.dart';
import 'package:iraqijob/widget/textfield_search_packages.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'home.dart' as home;
import 'login_page.dart' as login;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';

class ChangeITCompany extends StatefulWidget {
  final String type;

  ChangeITCompany(this.type);

  @override
  _ChangeITCompanyState createState() => _ChangeITCompanyState();
}

class _ChangeITCompanyState extends State<ChangeITCompany> {
  List<String> typeOfCompany = [
   "airline company",
    "car company",
    "cafe",
    "cleaning service company",
    "clothing company",
    "computer store",
    "concrete factory",
    "construction company",
    "delivery service",
    "educational segments",
    "electric company",
    "finance and banking company",
    "food company",
    "furniture company",
    "glass industrial",
    "market",
    "media company",
    "medical group",
    "mobile store",
    "oil company",
    "print shop",
    "restaurant",
    "shopping mall",
    "software company",
    "steel company",
    "telecommunication company",
    "transportation service",
    "other",
  ];
  TextEditingController typeController = TextEditingController();
  bool showErrorText = false;
  RegExp validateSpace = RegExp(r"^[\s]+$");
  bool isLoading = false;

   bool isWifi = false;
  var wifiListen;
  checkWifi() async {
    var connection = await Connectivity().checkConnectivity();

    if (connection == ConnectivityResult.none) {
      setState(() {
        isWifi = false;
      });
    } else {
      setState(() {
        isWifi = true;
      });
    }
    wifiListen = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      try {
        if (result == ConnectivityResult.none) {
          setState(() {
            isWifi = false;
          });
        } else {
          setState(() {
            isWifi = true;
          });
        }
      } catch (er) {}
    });
  }

  @override
  void dispose() {
    wifiListen.cancel();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    checkWifi();
    typeController.text = widget.type;
  }

  save() async {
    if (!typeOfCompany.contains(typeController.text) ||
        validateSpace.hasMatch(typeController.text)) {
      setState(() {
        showErrorText = true;
      });
    } else {
      setState(() {
        isLoading = true;
      });
      if (home.isCompany) {
        await login.cUserRef
            .document(login.userId)
            .updateData({"typeCompany": typeController.text});
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("typeCompany", typeController.text);

        Navigator.pop(context);
      } else {
        await login.pUserRef
            .document(login.userId)
            .updateData({"interestedCompany": typeController.text});
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("interestedCompany", typeController.text);
        Navigator.pop(context);
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(designSize: Size(360, 640), allowFontScaling: true);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey.shade600),
        backgroundColor: Colors.white,
        title: Text(
          home.isCompany ? "Company type" : "Intrested Company",
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: ScreenUtil().setSp(17)),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: isLoading||!isWifi
                ? null
                : () async {
                    try {
                      save();
                    } catch (er) {
                      print(er);
                    }
                  },
            child: Text(
              "Save",
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
          )
        ],
      ),
      body: isLoading
          ? Loader()
          : SingleChildScrollView(
                      child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFieldSearch(
                        isAddJob: false,
                        controller: typeController,
                        label: home.isCompany
                            ? "Type Of Company"
                            : "Interested Companys",
                        initialList: typeOfCompany,
                        isCity: false,
                      ),
                      if (showErrorText) ...{
                        SizedBox(height: ScreenUtil().setHeight(5)),
                        Text(
                          home.isCompany
                              ? "This type is'nt found"
                              : "this company is'nt found",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: ScreenUtil().setSp(10)),
                        ),
                      },
                      SizedBox(height: ScreenUtil().setHeight(13)),
                      Text(
                        home.isCompany
                            ? "Important, Please fill the following field properly Because of the following field you will get to see all the cvs from people related to your company as well as them to see your company"
                            : "IMPORTANT, Please fill the following field properly because it defines how you will get to see Company jobs As well as companies seeing"
                                "the cv you have shared .",
                        style: TextStyle(
                            color: Colors.grey, fontSize: ScreenUtil().setSp(12)),
                        textAlign: TextAlign.justify,
                      )
                    ]),
              ),
          ),
    );
  }
}
