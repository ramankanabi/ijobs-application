import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iraqijob/pages/login_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:connectivity/connectivity.dart';
class AdvertisePost extends StatefulWidget {
  final String mediaUrl;
  final String name;
  final String description;
  final String pageUrl;
  final String advertiseId;
  AdvertisePost({
    @required this.advertiseId,
    @required this.mediaUrl,
    @required this.name,
    @required this.description,
    @required this.pageUrl,
  });

  factory AdvertisePost.fromDocument(doc) {
    return AdvertisePost(
      advertiseId: doc["advertiseId"],
      mediaUrl: doc["mediaUrl"],
      name: doc["name"],
      description: doc["description"],
      pageUrl: doc["pageUrl"],
    );
  }

  @override
  _AdvertisePostState createState() => _AdvertisePostState();
}

class _AdvertisePostState extends State<AdvertisePost>
    with AutomaticKeepAliveClientMixin<AdvertisePost> {
  bool isLoading = false;
  bool isCounting = true;
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
}


  buildPostHeader() {
    return ListTile(
      contentPadding: EdgeInsets.only(left: 5),
      leading: CircleAvatar(
        backgroundColor: Colors.grey.shade100,
        backgroundImage: NetworkImage(
         "https://firebasestorage.googleapis.com/v0/b/job-in-iraq-cb304.appspot.com/o/advertise%20media%2Fadvertise%20profile.png?alt=media&token=96d5ce76-1840-455b-aff2-beec6972750d"
        ),
      ),
      title: Text(
        widget.name,
        style: TextStyle(
            fontSize: ScreenUtil().setSp(13), color: Colors.black, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        "Sponsored",
        style: TextStyle(color: Colors.grey.shade800, fontSize: ScreenUtil().setSp(10)),
      ),
    );
  }

  buildPostMiddle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AspectRatio(
          aspectRatio: 3 / 2,
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: widget.mediaUrl,
            alignment: Alignment.center,
          ),
        ),
        SizedBox(height: ScreenUtil().setHeight(10)),
        Text.rich(
          TextSpan(children: [
            TextSpan(
              text: widget.name + " : ",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: widget.description,
              style: TextStyle(color: Colors.grey.shade700),
            )
          ]),
          textAlign: TextAlign.start,
          softWrap: true,
        ),
      ],
    );
  }

  buildPostFooter() {
    // bool isOwenrPost = widget.userId == userId;
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Container(
        // alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 0.5, color: Colors.grey),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: ListTile(
            isThreeLine: false,
            dense: false,
            onTap: () async {
              if (await canLaunch(widget.pageUrl)) {
                await launch(widget.pageUrl);
              }
            },
            contentPadding: EdgeInsets.only(left: 5),
            leading: Text(
              "Visit",
              style: TextStyle(color: Colors.blue),
            ),
            trailing:
                Icon(Icons.arrow_forward_ios, size: 13, color: Colors.blue),
          ),
        ),
      ),
    );
  }

  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    ScreenUtil.init(designSize: Size(360, 640), allowFontScaling: true);
    return Listener(
      onPointerMove: (event) {
        if (isCounting) {
          countingView();
          isCounting = false;
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            buildPostHeader(),
            buildPostMiddle(),
            SizedBox(height: ScreenUtil().setHeight(40)),
            buildPostFooter(),
          ],
        ),
      ),
    );
  }

  countingView() async {
    
    if(isWifi){
    await advertiseRef.document(widget.advertiseId).updateData(
      {
        "views.${DateTime.now()}": userId,
      },
    );
      print("count");
    
    }
  }
}
