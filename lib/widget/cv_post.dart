import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iraqijob/pages/login_page.dart' as login;
import 'package:iraqijob/pages/profile.dart';
import 'package:iraqijob/widget/slide_dots.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CVPost extends StatefulWidget {
  final String userId;
  final List mediaUrl;
  final String interestJob;
  final Timestamp dateTime;
  final bool isVIP;
  final Map savedDateTime;
  CVPost({
    @required this.isVIP,
    @required this.dateTime,
    @required this.userId,
    @required this.mediaUrl,
    @required this.interestJob,
    @required this.savedDateTime,
  });

  factory CVPost.fromDocument(
    doc,
  ) {
    return CVPost(
      isVIP: doc["isVIP"],
      dateTime: doc["dateTime"],
      userId: doc["userId"],
      mediaUrl: doc["mediaUrl"],
      interestJob: doc["ineterestJob"],
      savedDateTime: doc["savedDateTime"],
    );
  }

  @override
  _CVPostState createState() => _CVPostState();
}

class _CVPostState extends State<CVPost>
    with AutomaticKeepAliveClientMixin<CVPost> {
  bool isSaved;
  bool isLoading = false;
  DocumentSnapshot personalDoc;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    getDoc();
    getResultSaved();
  }

  getDoc() async {
    try {
      setState(() {
        isLoading = true;
      });
      personalDoc = await login.pUserRef.document(widget.userId).get();
      print(personalDoc["fullName"]);
      setState(() {
        isLoading = false;
      });
    } catch (er) {}
  }

  getResultSaved() {
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
          return Profile(widget.userId, true);
        },
      ),
    );
  }

  buildPostHeader() {
    return ListTile(
        leading: isLoading
            ? GestureDetector(
                onTap: _showProfile,
                child: CircleAvatar(
                  backgroundColor: Colors.grey.shade100,
                ),
              )
            : personalDoc["photoUrl"] == null
                ? GestureDetector(
                    onTap: _showProfile,
                    child: CircleAvatar(
                      backgroundColor: Colors.grey.shade100,
                      child: FittedBox(
                        child: Text(personalDoc["fullName"]),
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: _showProfile,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(personalDoc["photoUrl"]),
                      backgroundColor: Colors.grey.shade100,
                    ),
                  ),
        title: GestureDetector(
          onTap: _showProfile,
          child: Text(
            isLoading ? "" : personalDoc["fullName"],
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
            if (slec == "report") {
              if (await canLaunch(
                "mailto:ramankanabi@gmail.com?subject= <reporting cv> CvId  ${widget.userId} &body=Reason : ",
              )) {
                await launch(
                    "mailto:ramankanabi@gmail.com?subject= <reporting cv> CvId  ${widget.userId} &body=Reason:  ");
              }
            }
          },
          itemBuilder: (_) => [
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
        ));
  }

  buildPostImage() {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            // scrollDirection: Axis.horizontal,
            itemCount: widget.mediaUrl.length,
            itemBuilder: (context, index) {
              return AspectRatio(
                aspectRatio: 4 / 5,
                child: CachedNetworkImage(
                    // width: 300,
                    // height: double.infinity,
                    imageUrl: widget.mediaUrl[index],
                    fit: BoxFit.cover),
              );
            },
          ),
        ),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < widget.mediaUrl.length; i++) ...{
              if (i == currentPage)
                SlideDots(true, i + 1)
              else
                SlideDots(false, i + 1)
            }
          ],
        )
      ],
    );
  }

  buildPostFooter() {
    bool isOwenrPost = widget.userId == login.userId;
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 0.5, color: Colors.grey),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Row(children: [
            Expanded(
              child: FlatButton.icon(
                onPressed: isLoading ? () {} : sendEmailAction,
                icon: Icon(OMIcons.email),
                label: Text("Email"),
              ),
            ),
            if (!isOwenrPost) ...{
              Expanded(
                child: FlatButton.icon(
                  onPressed: isLoading ? () {} : savingPost,
                  icon:
                      Icon(isSaved ? OMIcons.bookmark : OMIcons.bookmarkBorder),
                  label: Text(isSaved ? "Saved" : "Save"),
                ),
              ),
            }
          ]),
        ),
      ),
    );
  }

  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    ScreenUtil.init(designSize: Size(360, 640), allowFontScaling: true);
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        buildPostHeader(),
        SizedBox(height: ScreenUtil().setHeight(5)),
        buildPostImage(),
        SizedBox(height: ScreenUtil().setHeight(10)),
        buildPostFooter(),
        SizedBox(height: ScreenUtil().setHeight(20))
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
          "Personal name",
          style: TextStyle(color: Colors.grey.shade50),
        ),
        subtitle: Text(
          "Time ago",
          style: TextStyle(color: Colors.grey.shade50),
        ),
      ),
      SizedBox(height: ScreenUtil().setHeight(5)),
      Container(
        height: ScreenUtil().setHeight(400),
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
        await login.cvRef.document(widget.userId).updateData({
          "savedDateTime.${login.userId}": DateTime.now(),
        });
      } else if (isSaved) {
        setState(() {
          isSaved = false;
        });

        await login.cvRef.document(widget.userId).updateData(
          {
            "savedDateTime.${login.userId}": FieldValue.delete(),
          },
        );
      }
    } catch (er) {}
  }

  void sendEmailAction() async {
    if (await canLaunch("mailto:${personalDoc.data["email"]}?subject=&body=")) {
      await launch("mailto:${personalDoc.data["email"]}?subject=&body=");
    }
  }
}
