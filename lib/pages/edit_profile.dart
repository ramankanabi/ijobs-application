import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iraqijob/pages/change_interested_type_company.dart';
import 'package:iraqijob/pages/change_profile_photo.dart';
import 'package:iraqijob/widget/loader.dart';
import 'package:iraqijob/widget/textfield_search_packages.dart';
import 'login_page.dart'as login;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'home.dart'as home;

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile>
    with AutomaticKeepAliveClientMixin<EditProfile> {
  GlobalKey<FormState> formKey = GlobalKey();

  RegExp validateFullName = RegExp(r"^[a-zA-Z\s]+$");
  RegExp validateCity = RegExp(r"^[a-zA-Z\s]+$");
  RegExp validateSpace = RegExp(r"^[\s]+$");
  RegExp validateAddress = RegExp(r"^[\w\s]+$");
  RegExp validatePhone = RegExp(r"^[0-9\s]+$");

  bool isLoading = false;
  FocusNode addressNode = FocusNode();
  FocusNode cityNode = FocusNode();
  FocusNode phoneNode = FocusNode();
  File imageProfile;


  List<String> genderList = [
    "male",
    "female",
  ];
  TextEditingController cityController = TextEditingController();

  List<String> cityList = [
      "al anbar",
    "al najaf",
    "al fallujah",
    "al muthanna",
    "al basrah",
    "al qadisiyah",
    "babil",
    "baghdad",
    "duhok",
    "diyala",
    "hawler",
    "halabja",
    "karbala",
    "kirkuk",
    "misan",
    "mosul",
    "ninewa",
    "sulaymani",
    "thi qar",
  ];
  bool showErrorText = false;
///////////////////////////////////////////////

  imageFromCamera() async {
    Navigator.pop(context);
    try {
      File imageProfile =
          // ignore: deprecated_member_use
          await ImagePicker.pickImage(source: ImageSource.camera);
      if (imageProfile != null) {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChangeProfilePhoto(imageProfile),
          ),
        ).then((value) => getData());
      }
    } catch (er) {}
  }

  imageFromGallary() async {
    Navigator.pop(context);
    try {
      File imageProfile =
// ignore: deprecated_member_use
          await ImagePicker.pickImage(source: ImageSource.gallery);
      if (imageProfile != null) {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChangeProfilePhoto(imageProfile),
          ),
        ).then((value) => getData());
      }
    } catch (er) {}
  }

///////////////////////////////////////////////

  _save() async {
    if (!formKey.currentState.validate()) {
      return;
    }

    if (!cityList.contains(cityController.text) ||
        validateSpace.hasMatch(cityController.text)) {
      setState(() {
        showErrorText = true;
      });
      return;
    }
    try{
    setState(() {
      isLoading = true;
    });

    formKey.currentState.save();

    if (home.isCompany) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("city", cityController.text);

      await login.cUserRef.document(login.userId).updateData({
        "fullName": fullName.toLowerCase(),
        "city": cityController.text.toLowerCase(),
        "address": address.toLowerCase(),
        "phoneNumber": phoneNumber,
      });
    } else {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("city", cityController.text);
      prefs.setString("gender", gender);

      await login.pUserRef.document(login.userId).updateData({
        "fullName": fullName.toLowerCase(),
        "city": cityController.text.toLowerCase(),
        "address": address.toLowerCase(),
        "phoneNumber": phoneNumber,
        "gender": gender.toLowerCase(),
      });
    }
    setState(() {
      isLoading = false;
    });
    Navigator.pop(context);}catch(er){
      print(er);
    }
  }


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
    checkWifi();
    getData();
    super.initState();
  }



  String photoUrl;
  String fullName;
  String email;
  String phoneNumber;
  String city;
  String address;
  String gender;
  String typeCompany;
  String interestedCompany;

  getData() async {
    setState(() {
      isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    photoUrl = prefs.getString("photoUrl");
    fullName = prefs.getString("fullName");
    email = prefs.getString("email");
    phoneNumber = prefs.getString("phoneNumber");
    cityController.text = prefs.getString("city");
    address = prefs.getString("address");
    gender = prefs.getString("gender");
    typeCompany = prefs.getString("typeCompany");
    interestedCompany = prefs.getString("interestedCompany");

    setState(() {
      isLoading = false;
    });
  }

  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    ScreenUtil.init(designSize: Size(360, 640), allowFontScaling: true);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.4,
        iconTheme: IconThemeData(color: Colors.grey.shade600),
        backgroundColor: Colors.white,
        title: Text(
          "Edit Profile",
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: ScreenUtil().setSp(17)),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: isLoading ||!isWifi? () {} : _save,
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
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, bottom: 40, right: 15, top: 15),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      if (photoUrl != null) ...{
                        CircleAvatar(
                          backgroundImage: NetworkImage(photoUrl),
                          radius: 40,
                          backgroundColor: Colors.grey.shade100,
                        )
                      } else ...{
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey.shade100,
                          child: Center(child: Text(fullName,textAlign:TextAlign.center)),
                        ),
                      },
                      FlatButton(
                        onPressed:!isWifi?(){}: () async {
                          await dialog(context);
                        },
                        child: Text(
                          "Change Profile Photo",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: ScreenUtil().setSp(11)),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(10),
                      ),
                      TextFormField(
                        initialValue: fullName,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: home.isCompany ? "Company Name" : "Full Name",
                          labelStyle: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                        ),
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(cityNode);
                        },
                        validator: (val) {
                          if (val.isEmpty) {
                            return "please write your full name .";
                          } else if (validateSpace.hasMatch(val)) {
                            return "Sorry you can't enter empty space .";
                          } else if (!validateFullName.hasMatch(val)) {
                            return "Sorry you must type only characters .";
                          }else if(val.length>50){
                            return "Sorry, max character limit has been reached .";
                          }
                        },
                        onSaved: (val) async {
                          final prefs = await SharedPreferences.getInstance();
                          prefs.setString("fullName", val);
                          fullName = val;
                        },
                      ),
                      TextFieldSearch(
                        isAddJob: false,
                        controller: cityController,
                        label: "City",
                        initialList: cityList,
                        isCity: true,
                      ),
                      if (showErrorText) ...{
                        SizedBox(height: ScreenUtil().setHeight(5)),
                        Row(children: [
                          Text(
                            "This city is'nt found",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: ScreenUtil().setSp(10)),
                          ),
                        ]),
                      },
                      TextFormField(
                        initialValue: address,
                        textInputAction: TextInputAction.next,
                        focusNode: addressNode,
                        decoration: InputDecoration(
                          labelText: "Address",
                          labelStyle: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                        ),
                        validator: (val) {
                          if (val.isEmpty) {
                            return "Please write your Address .";
                          } else if (validateSpace.hasMatch(val)) {
                            return "Sorry you can't enter empty space .";
                          } else if (!validateAddress.hasMatch(val)) {
                            return "Sorry only characters and numbers are allowed .";
                          }else if(val.length>50){
                            return "Sorry, max character limit has been reached .";
                          }
                        },
                        onSaved: (val) async {
                          final prefs = await SharedPreferences.getInstance();
                          prefs.setString("address", val);
                          address = val;
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(phoneNode);
                        },
                      ),
                      TextFormField(
                        initialValue: phoneNumber,
                        textInputAction: TextInputAction.done,
                        focusNode: phoneNode,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: home.isCompany
                              ? "e.g. (066 or 0700)1234567"
                              : "e.g. 07001234567",
                          hintStyle: TextStyle(color: Colors.grey),
                          labelText: "Phone Number",
                          labelStyle: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                        ),
                        validator: (val){
                          if (val.isEmpty) {
                            return "Please write your phone number .";
                          } else if (validateSpace.hasMatch(val)) {
                            return "Sorry you can't enter empty space .";
                          } else if (!validatePhone.hasMatch(val)) {
                            return "Sorry only numbers are allowed";
                          }
                          if (!home.isCompany) {
                            if (val.length != 11) {
                              return "Please enter the correct phone number .";
                            }
                          } else if (home.isCompany) {
                            if (val.length != 10 && val.length != 11) {
                              return "Please enter the correct phone number .";
                            }
                          }
                        },
                        onSaved: (val) async {
                          final prefs = await SharedPreferences.getInstance();
                          prefs.setString("phoneNumber", val);
                          phoneNumber = val;
                        },
                      ),
                      if (!home.isCompany) ...{
                        DropdownButtonFormField<String>(
                          style: TextStyle(color: Colors.black),
                          iconEnabledColor: Colors.grey,
                          isExpanded: true,
                          value: gender,
                          decoration: InputDecoration(
                            labelText: "Gender",
                            labelStyle: TextStyle(color: Colors.grey.shade700),
                          ),
                          icon: Icon(Icons.arrow_drop_down),
                          items: genderList.map((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String value) async {
                            setState(() {
                              gender = value;
                            });
                          },
                          validator: (val) {
                            if (val == null) {
                              return "Please choose your gender .";
                            }
                          },
                        )
                      },
                      ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => ChangeITCompany(
                                  home.isCompany ? typeCompany : interestedCompany),
                            ),
                          );
                        },
                        isThreeLine: false,
                        dense: true,
                        contentPadding: EdgeInsets.only(top: 15, right: 4),
                        title: Text(
                          home.isCompany ? "Type of company" : "Interested company",
                          style: TextStyle(color: Colors.blue),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  dialog(context) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text("Changing Profile Photo"),
            children: <Widget>[
              SimpleDialogOption(
                child: Text("image from camera"),
                onPressed: imageFromCamera,
              ),
              SimpleDialogOption(
                child: Text("image from Gallary"),
                onPressed: imageFromGallary,
              ),
              SimpleDialogOption(
                child: Text("cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
