import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:iraqijob/pages/upload_job.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddJob2 extends StatefulWidget {
  @override
  _AddJob2State createState() => _AddJob2State();
}

String jobDescription;
String qualities;

class _AddJob2State extends State<AddJob2> {
  RegExp validateSpace = RegExp(r"^[\s]+$");
  GlobalKey<FormBuilderState> formKey = GlobalKey();

  _next() async {
    if (!formKey.currentState.validate()) {
      return;
    }
    await SystemChannels.textInput.invokeMethod("TextInput.hide");
    formKey.currentState.save();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => UploadJob()));
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(designSize: Size(360, 640), allowFontScaling: true);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey.shade800),
        elevation: 0,
        backgroundColor: Colors.white,
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
        padding: EdgeInsets.all(20),
        child: FormBuilder(
            key: formKey,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FormBuilderTextField(
                        minLines: 3,
                        maxLines: 4,
                        textInputAction: TextInputAction.newline,
                        attribute: "Job Description",
                        decoration: InputDecoration(
                          labelText: "Job Description",
                          labelStyle:
                              TextStyle(fontSize: ScreenUtil().setSp(22)),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        validators: [
                          FormBuilderValidators.required(
                              errorText: "Please fill the field ."),
                          FormBuilderValidators.pattern(r"(\w+)",
                              errorText: "Sorry you can't enter empty space ."),
                          FormBuilderValidators.maxLength(500,
                              errorText:
                                  "Sorry, max character limit has been reached .")
                        ],
                        onSaved: (val) {
                          jobDescription = val;
                        },
                      ),
                      SizedBox(height: ScreenUtil().setHeight(5)),
                      FormBuilderTextField(
                        textInputAction: TextInputAction.newline,
                        attribute: "Qualities",
                        minLines: 3,
                        maxLines: 4,
                        decoration: InputDecoration(
                          labelText: "Qualities",
                          labelStyle:
                              TextStyle(fontSize: ScreenUtil().setSp(22)),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        validators: [
                          FormBuilderValidators.required(
                              errorText: "Please fill the field ."),
                          FormBuilderValidators.pattern(r"(\w+)",
                              errorText: "Sorry you can't enter empty space ."),
                               FormBuilderValidators.maxLength(500,
                              errorText:
                                  "Sorry, max character limit has been reached .")
                        ],
                        onSaved: (val) {
                          qualities = val;
                        },
                      ),
                    ]),
              ),
            )),
      ),
    );
  }
}
