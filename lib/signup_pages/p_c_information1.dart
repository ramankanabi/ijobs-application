import 'package:flutter/material.dart';
import 'package:iraqijob/widget/textfield_search_packages.dart';
import 'p_c_information2.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'option_page.dart' as option;

class PCinformation extends StatefulWidget {
  @override
  _PCinformationState createState() => _PCinformationState();
}

String city;
String address;
String phoneNumber;
int birthYear;
String genderValue;

class _PCinformationState extends State<PCinformation> {
//////////////////////////////// VRIABLES //////////////////////////////////////////////////
  GlobalKey<FormState> formKey = GlobalKey();
  String citySaved;
  String addressSaved;
  String phoneNumberSaved;
  int birthYearSaved;
  FocusNode dateNode = FocusNode();
  FocusNode addressNode = FocusNode();
  FocusNode phoneNode = FocusNode();
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

  RegExp validateCity = RegExp(r"^[a-zA-Z\s]+$");
  RegExp validateSpace = RegExp(r"^[\s]+$");
  RegExp validateAddress = RegExp(r"^[\w\s]+$");
  RegExp validatebirthYear = RegExp(r"^[0-9\s]+$");
  RegExp validatePhone = RegExp(r"^[0-9\s]+$");

////////////////////////////////////////// NEXT //////////////////////////////////////////////////

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

    formKey.currentState.save();

    city = cityController.text;
    address = addressSaved;
    phoneNumber = phoneNumberSaved;
    birthYear = birthYearSaved;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PCinformation2(),
      ),
    );
  }

//////////////////////////////////// MAIN WIDGET ///////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(designSize: Size(360, 640), allowFontScaling: true);
    return Scaffold(
      body: WillPopScope(
        onWillPop: () {},
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 40.0, left: 30, right: 30),
            child: Form(
              key: formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: Text(
                        option.isCompany
                            ? "Company\ninformation"
                            : "Personal\ninformation",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: ScreenUtil().setSp(33),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(20)),
                    TextFieldSearch(
                      controller: cityController,
                      label: "City",
                      initialList: cityList,
                      isAddJob: false,
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
                      textInputAction: TextInputAction.next,
                      focusNode: addressNode,
                      decoration: InputDecoration(
                        labelText: "Address",
                        labelStyle: TextStyle(
                            color: Colors.grey.shade700,),
                      ),
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Please write your Address .";
                        } else if (validateSpace.hasMatch(val)) {
                          return "Sorry, you can't enter empty space .";
                        } else if (!validateAddress.hasMatch(val)) {
                          return "Sorry, only characters and numbers are allowed .";
                        } else if (val.length > 100) {
                          return "Sorry, max character limit has been reached .";
                        }
                      },
                      onSaved: (val) {
                        addressSaved = val;
                      },
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(phoneNode);
                      },
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      focusNode: phoneNode,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: option.isCompany
                            ? "e.g. (066 or 0700)1234567"
                            : "e.g. 07001234567",
                        hintStyle: TextStyle(color: Colors.grey),
                        labelText: "Phone Number",
                        labelStyle: TextStyle(
                          color: Colors.grey.shade700,
                        ),
                      ),
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Please write your phone number .";
                        } else if (validateSpace.hasMatch(val)) {
                          return "Sorry you can't enter empty space .";
                        } else if (!validatePhone.hasMatch(val)) {
                          return "Sorry only numbers are allowed";
                        }
                        if (!option.isCompany) {
                          if (val.length != 11) {
                            return "Please enter the correct phone number .";
                          }
                        } else if (option.isCompany) {
                          if (val.length != 10 && val.length != 11) {
                            return "Please enter the correct phone number .";
                          }
                        }
                      },
                      onSaved: (val) {
                        phoneNumberSaved = val;
                      },
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(dateNode);
                      },
                    ),
                    if (!option.isCompany) ...{
                      DropdownButtonFormField<String>(
                        style: TextStyle(color: Colors.black),
                        iconEnabledColor: Colors.grey,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: "Gender",
                          labelStyle: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                        ),
                        icon: Icon(Icons.arrow_drop_down),
                        items: genderList.map((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String value) {
                          setState(() {
                            genderValue = value;
                          });
                        },
                        validator: (val) {
                          if (val == null) {
                            return "Please choose your gender type .";
                          }
                        },
                      ),
                      TextFormField(
                        focusNode: dateNode,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Birth year",
                          labelStyle: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                        ),
                        validator: (val) {
                          if (val.isEmpty) {
                            return "Please enter your birth year .";
                          } else if (validateSpace.hasMatch(val)) {
                            return "Sorry you can't enter empty space .";
                          } else if (!validatebirthYear.hasMatch(val)) {
                            return "Sorry only numbers are allowed .";
                          } else if (int.parse(val) < 1950 ||
                              int.parse(val) > 2005) {
                            return "Sorry your age should to greater than 15 years\nand less than 70 years .";
                          }
                        },
                        onSaved: (val) {
                          birthYearSaved = int.parse(val);
                        },
                      )
                    },
                    SizedBox(
                      height: option.isCompany
                          ? ScreenUtil().setHeight(60)
                          : ScreenUtil().setHeight(60),
                    ),
                    Container(
                      width: ScreenUtil().setWidth(200),
                      height: ScreenUtil().setHeight(40),
                      child: RaisedButton(
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          "Next",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        onPressed: () {
                          _save();
                        },
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(20),
                    ),
                    Container(
                      width: ScreenUtil().setWidth(200),
                      height: ScreenUtil().setHeight(40),
                      child: FlatButton(
                          child: Text(
                            "Go Back ",
                            style: TextStyle(
                              color: Colors.grey.shade600.withOpacity(0.9),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
