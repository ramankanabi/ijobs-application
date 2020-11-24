import 'package:flutter/material.dart';
import 'package:iraqijob/pages/add_job_2.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iraqijob/widget/textfield_search_packages.dart';

class AddJob extends StatefulWidget {
  AddJob({Key key}) : super(key: key);

  @override
  _AddJobState createState() => _AddJobState();
}

String position;
String times;
String city;
String address;
String gender;
String salary;

class _AddJobState extends State<AddJob> {
  FocusNode timesNode = FocusNode();
  FocusNode cityNode = FocusNode();
  FocusNode addressNode = FocusNode();
  FocusNode genderNode = FocusNode();
  FocusNode salaryNode = FocusNode();

  TextEditingController cityController = TextEditingController();
  List<String> genderList = [
    "male",
    "female",
  ];
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
  RegExp validateSpace = RegExp(r"^[\w\s]+$");
  RegExp validateSalary = RegExp(r"^[0-9\s]+$");
  GlobalKey<FormBuilderState> formKey = GlobalKey();
  _next() {
    if (!formKey.currentState.validate()) {
      return;
    }

    if (!cityList.contains(cityController.text)) {
      setState(() {
        showErrorText = true;
      });
      return;
    }

    formKey.currentState.save();
    city = cityController.text;
    setState(() {
      showErrorText = false;
    });
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => AddJob2()));
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(designSize: Size(360, 640), allowFontScaling: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey.shade800),
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Add Job",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: _next,
            child: Text(
              "Next",
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: FormBuilder(
              key: formKey,
              child: Column(
                children: <Widget>[
                  FormBuilderTextField(
                    textInputAction: TextInputAction.next,
                    attribute: "Position",
                    decoration: InputDecoration(
                        labelText: "Position",
                        labelStyle: TextStyle(fontSize: ScreenUtil().setSp(22)),
                        floatingLabelBehavior: FloatingLabelBehavior.always),
                    validators: [
                      FormBuilderValidators.required(
                          errorText: "Please fill the field ."),
                      FormBuilderValidators.pattern(r"(\w+)",
                          errorText: "Sorry you can't enter empty space ."),
                    ],
                    onSaved: (val) {
                      position = val;
                    },
                    onFieldSubmitted: (val) {
                      FocusScope.of(context).requestFocus(timesNode);
                    },
                  ),
                  SizedBox(height: ScreenUtil().setHeight(5)),
                  FormBuilderTextField(
                    textInputAction: TextInputAction.next,
                    focusNode: timesNode,
                    attribute: "Time",
                    decoration: InputDecoration(
                        labelText: "Time",
                        labelStyle: TextStyle(fontSize: ScreenUtil().setSp(22)),
                        floatingLabelBehavior: FloatingLabelBehavior.always),
                    validators: [
                      FormBuilderValidators.required(
                          errorText: "Please fill the field ."),
                      FormBuilderValidators.pattern(r"(\w+)",
                          errorText: "Sorry you can't enter empty space ."),
                    ],
                    onSaved: (val) {
                      times = val;
                    },
                    onFieldSubmitted: (val) {
                      FocusScope.of(context).requestFocus(cityNode);
                    },
                  ),
                  SizedBox(height: ScreenUtil().setHeight(5)),
                  TextFieldSearch(
                    isAddJob: true,
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
                  SizedBox(height: ScreenUtil().setHeight(5)),
                  FormBuilderTextField(
                    textInputAction: TextInputAction.next,
                    focusNode: addressNode,
                    attribute: "Address",
                    decoration: InputDecoration(
                        labelText: "Address",
                        labelStyle: TextStyle(fontSize: ScreenUtil().setSp(22)),
                        floatingLabelBehavior: FloatingLabelBehavior.always),
                    validators: [
                      FormBuilderValidators.required(
                          errorText: "Please fill the field ."),
                      FormBuilderValidators.pattern(r"(\w+)",
                          errorText: "Sorry you can't enter empty space ."),
                    ],
                    onSaved: (val) {
                      address = val;
                    },
                    onFieldSubmitted: (val) {
                      FocusScope.of(context).requestFocus(genderNode);
                    },
                  ),
                  SizedBox(height: ScreenUtil().setHeight(5)),
                  DropdownButtonFormField<String>(
                    style: TextStyle(color: Colors.black),
                    iconEnabledColor: Colors.grey,
                    isExpanded: true,
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
                    onChanged: (String value) {
                      setState(() {
                        gender = value;
                      });
                    },
                    validator: (val) {
                      if (val == null) {
                        return "Please choose your gender type .";
                      }
                      // return "";
                    },
                  ),
                  SizedBox(height: ScreenUtil().setHeight(5)),
                  FormBuilderTextField(
                    textInputAction: TextInputAction.done,
                    focusNode: salaryNode,
                    attribute: "Salary",
                    decoration: InputDecoration(
                        labelText: "Salary",
                        labelStyle: TextStyle(fontSize: ScreenUtil().setSp(22)),
                        floatingLabelBehavior: FloatingLabelBehavior.always),
                    validators: [
                      FormBuilderValidators.required(
                          errorText: "Please fill the field ."),
                      FormBuilderValidators.pattern(r"(\w+)",
                          errorText: "Sorry you can't enter empty space ."),
                    ],
                    onSaved: (val) {
                      salary = val;
                    },
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
