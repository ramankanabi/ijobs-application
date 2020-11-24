import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iraqijob/pages/login_page.dart' as login;
import 'package:iraqijob/pages/profile.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:clipboard/clipboard.dart';
import '../pages/home.dart' as home;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JobPost extends StatefulWidget {
  final String position;
  final String times;
  final String city;
  final String address;
  final String gender;
  final String salary;
  final String jobDescription;
  final String qualities;
  final String ownerId;
  final String jobId;
  final Map savedDateTime;
  final Timestamp dateTime;
  final bool isVIP;

  JobPost(
      {@required this.isVIP,
      @required this.jobId,
      @required this.position,
      @required this.times,
      @required this.city,
      @required this.address,
      @required this.gender,
      @required this.salary,
      @required this.jobDescription,
      @required this.qualities,
      @required this.ownerId,
      @required this.savedDateTime,
      @required this.dateTime});

  factory JobPost.fromDocument(doc) {
    return JobPost(
      isVIP: doc["isVIP"],
      ownerId: doc["ownerId"],
      savedDateTime: doc["savedDateTime"],
      address: doc["address"],
      city: doc["city"],
      jobDescription: doc["jobDescription"],
      position: doc["position"],
      qualities: doc["qualities"],
      salary: doc["salary"],
      gender: doc["gender"],
      times: doc["times"],
      jobId: doc["jobId"],
      dateTime: doc["dateTime"],
      // photoUrl: personalDoc["photoUrl"],
      // companyName: personalDoc["companyName"],
    );
  }

  @override
  _JobPostState createState() => _JobPostState();
}

class _JobPostState extends State<JobPost>
    with AutomaticKeepAliveClientMixin<JobPost> {
  bool isSaved = false;
  bool isLoading = false;
  DocumentSnapshot companyDoc;

  @override
  void initState() {
    super.initState();
    getResultSaved();

    getDoc();
  }

  getDoc() async {
    try {
      
      setState(() {
        isLoading = true;
      });

      companyDoc = await login.cUserRef.document(widget.ownerId).get();

      setState(() {
        isLoading = false;
      });
    } catch (er) {}
  }

  getResultSaved() async {
    if (widget.savedDateTime.containsKey(login.userId)) {
      setState(() {
        isSaved = true;
      });
    } else {
      setState(() {
        isSaved = false;
      });
    }
  }

  _showProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) {
          return Profile(widget.ownerId, true);
        },
      ),
    );
  }

  buildPostHeader() {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.only(left: 5),
      leading:isLoading?
      GestureDetector(
        onTap: _showProfile,
              child: CircleAvatar(
          backgroundColor: Colors.grey.shade100,
        ),
      )
      : companyDoc["photoUrl"] == null
          ? GestureDetector(
              onTap: _showProfile,
              child: CircleAvatar(
                backgroundColor: Colors.grey.shade100,
                child: FittedBox(
                  child: Text(companyDoc["fullName"]),
                ),
              ),
            )
          : GestureDetector(
              onTap: _showProfile,
              child: CircleAvatar(
                backgroundImage: NetworkImage(companyDoc["photoUrl"]),
                backgroundColor: Colors.grey.shade100,
              ),
            ),
      title: GestureDetector(
        onTap: _showProfile,
        child: Text(
          isLoading?"":companyDoc["fullName"],
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: ScreenUtil().setSp(13)),
        ),
      ),
      subtitle: widget.isVIP
          ? Text("VIP",
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(12), color: Colors.blue))
          : Text(
              timeago.format(
                widget.dateTime.toDate(),
              ),
              style: TextStyle(fontSize: ScreenUtil().setSp(10))),
      trailing: PopupMenuButton(
        elevation: 2,
        icon: Icon(Icons.more_horiz, color: Colors.grey.shade800, size: 20),
        onSelected: (slec) async {
          if (slec == "delete") {
            _showDialog();
          } else if (slec == "report") {
            if (await canLaunch(
              "mailto:ramankanabi@gmail.com?subject= <reporting> JobId  ${widget.jobId} &body=Reason : ",
            )) {
              await launch(
                  "mailto:ramankanabi@gmail.com?subject= <reporting> JobId  ${widget.jobId} &body=Reason:  ");
            }
          } else if (slec == "copy id") {
            FlutterClipboard.copy(widget.jobId);
            home.homeScaffoldKey.currentState.showSnackBar(
              SnackBar(
                elevation: 0,
                backgroundColor: Colors.black87.withOpacity(0.8),
                content: Text("Job id copied to clipboard "),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
        itemBuilder: (_) => [
          if (login.userId == widget.ownerId) ...{
            PopupMenuItem(
              height: ScreenUtil().setHeight(30),
              child: Center(
                child: Text(
                  "Copy id",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              value: "copy id",
            ),
            PopupMenuItem(
              height: ScreenUtil().setHeight(30),
              child: Center(
                child: Text(
                  "Delete",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
              value: "delete",
            ),
          },
          PopupMenuItem(
            height: ScreenUtil().setHeight(30),
            child: Center(
              child: Text(
                "Report",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            value: "report",
          ),
        ],
      ),
    );
  }

  buildPostMiddle() {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <
        Widget>[
      RichText(
        textAlign: TextAlign.start,
        text: TextSpan(children: [
          TextSpan(
            text: "Position : ",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: widget.position,
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          )
        ]),
      ),
      SizedBox(height: ScreenUtil().setHeight(10)),
      RichText(
        textAlign: TextAlign.start,
        text: TextSpan(children: [
          TextSpan(
            text: "Times : ",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: widget.times,
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          )
        ]),
      ),
      SizedBox(height: ScreenUtil().setHeight(10)),
      RichText(
        textAlign: TextAlign.start,
        text: TextSpan(children: [
          TextSpan(
            text: "City : ",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: widget.city,
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          )
        ]),
      ),
      SizedBox(height: ScreenUtil().setHeight(10)),
      RichText(
        textAlign: TextAlign.start,
        text: TextSpan(children: [
          TextSpan(
            text: "Address : ",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: widget.address,
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          )
        ]),
      ),
      SizedBox(height: ScreenUtil().setHeight(10)),
      RichText(
        textAlign: TextAlign.start,
        text: TextSpan(children: [
          TextSpan(
            text: "Gender : ",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: widget.gender,
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          )
        ]),
      ),
      SizedBox(height: ScreenUtil().setHeight(10)),
      RichText(
        textAlign: TextAlign.start,
        text: TextSpan(children: [
          TextSpan(
            text: "Salary : ",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: widget.salary,
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          )
        ]),
      ),
      SizedBox(height: ScreenUtil().setHeight(10)),
      RichText(
        textAlign: TextAlign.start,
        text: TextSpan(children: [
          TextSpan(
            text: "Job Description : ",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: widget.jobDescription,
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
        ]),
      ),
      SizedBox(height: ScreenUtil().setHeight(10)),
      RichText(
        textAlign: TextAlign.start,
        text: TextSpan(children: [
          TextSpan(
            text: "Qualities : ",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: widget.qualities,
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
        ]),
      ),
    ]);
  }

  buildPostFooter() {
    bool isOwenrPost = widget.ownerId == login.userId;
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 0.5, color: Colors.grey),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Row(children: [
          if (!isOwenrPost) ...{
            Expanded(
              child: FlatButton.icon(
                onPressed: isLoading ? () {} : savingPost,
                icon: Icon(isSaved ? OMIcons.bookmark : OMIcons.bookmarkBorder),
                label: Text(isSaved ? "Saved" : "Save"),
              ),
            ),
          },
          Expanded(
            child: FlatButton.icon(
              onPressed: isLoading ? () {} : sendEmailAction,
              icon: Icon(OMIcons.email),
              label: Text("Email"),
            ),
          ),
        ]),
      ),
    );
  }

  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    ScreenUtil.init(designSize: Size(360, 640), allowFontScaling: true);
    return Container(
      padding: EdgeInsets.only(top: 10, left: 10, right: 10),
      color: Colors.white,
      alignment: Alignment.center,
      child:  Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              buildPostHeader(),
              SizedBox(height: ScreenUtil().setHeight(5)),
              buildPostMiddle(),
              SizedBox(height: ScreenUtil().setHeight(30)),
              buildPostFooter(),
            ]),
    );
  }

  loadingPost() {
    return Column(children: [
      ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey.shade100,
        ),
        title: Text(
          "Company name",
          style: TextStyle(color: Colors.grey.shade50),
        ),
        subtitle: Text(
          "Time ago",
          style: TextStyle(color: Colors.grey.shade50),
        ),
      ),
      SizedBox(height: ScreenUtil().setHeight(5)),
      Container(
        height: ScreenUtil().setHeight(300),
        width: double.infinity,
        color: Colors.grey.shade100,
      ),
      SizedBox(height: ScreenUtil().setHeight(30)),
      buildPostFooter(),
    ]);
  }

  savingPost() async {
    try {
      if (!isSaved) {
        setState(() {
          isSaved = true;
        });
        await login.jobRef
            .document(widget.jobId)
            .updateData({"savedDateTime.${login.userId}": DateTime.now()});
      } else if (isSaved) {
        setState(() {
          isSaved = false;
        });
        await login.jobRef
            .document(widget.jobId)
            .updateData({"savedDateTime.${login.userId}": FieldValue.delete()});
      }
    } catch (er) {}
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text("Deleting Job Hiring"),
              content: Text("Do yo want to delete the job hiring ?"),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.grey.shade600),
                    )),
                FlatButton(
                    onPressed: () async {
                      Navigator.of(ctx).pop();
                      setState(() {
                        isLoading = true;
                      });
                      await login.jobRef.document(widget.jobId).delete();
                      setState(() {
                        isLoading = false;
                      });
                    },
                    child: Text(
                      "Delete",
                      style: TextStyle(color: Colors.red),
                    )),
              ],
            ));
  }

  void callAction() async {
    if (await canLaunch("tel:${companyDoc.data["phoneNumber"]}")) {
      await launch("tel:${companyDoc.data["phoneNumber"]}");
    }
  }

  void sendEmailAction() async {
    if (await canLaunch("mailto:${companyDoc.data["email"]}?subject=&body=")) {
      await launch("mailto:${companyDoc.data["email"]}?subject=&body=");
    }
  }
}
