import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iraqijob/model.dart/company_user.dart';
import './profile.dart';
import 'login_page.dart' as login;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Future<QuerySnapshot> searchData;
  TextEditingController searchController = TextEditingController();
  RegExp validateSpace = RegExp(r"^[\s]+$");

  @override
  void initState() {
    super.initState();
    if (searchController.text == null) {
      setState(() {
        searchData = null;
      });
    }
  }

  searching(String input) async {
    if (validateSpace.hasMatch(input) || input.isEmpty) {
      setState(() {
        searchData = null;
      });
      return;
    } else {
      Future<QuerySnapshot> query = login.cUserRef
          .where("fullName",
              isGreaterThanOrEqualTo: input.toLowerCase().trim())
          .limit(5)
          .getDocuments();

      setState(() {
        searchData = query;
      });
    }
  }

  showSearchResult() {
    return FutureBuilder(
      future: searchData,
      builder: (ctx, snapshot) {
        if (!snapshot.hasData) {
          return Column(
            children: <Widget>[
              ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey.shade200,
                  ),
                  title: Text(
                    ".....",
                    style: TextStyle(color: Colors.grey.shade200),
                  )),
              ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey.shade100,
                  ),
                  title: Text(
                    ".....",
                    style: TextStyle(color: Colors.grey.shade100),
                  )),
            ],
          );
        }

        List<UserResult> searchResult = [];
        snapshot.data.documents.forEach((user) {
          final userData = Cuser.fromDocument(user);
          searchResult.add(UserResult(userData));
        });
        return ListView(children: searchResult);
      },
    );
  }

  showNoSearching() {
    return Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal:50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: ScreenUtil().setHeight(200),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("asset/images/search.png"),
                        fit: BoxFit.contain),
                    border: Border(
                      bottom: BorderSide(color: Colors.grey, width: 1),
                    ),
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(10)),
                Text(
                  "Enter a few words\nto search companys",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600),
                )
              ],
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(designSize: Size(360, 640), allowFontScaling: true);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.4,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        actions: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Container(
                alignment: Alignment.center,
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    fillColor: Colors.grey,
                    contentPadding: EdgeInsets.only(left: 10),
                    hintText: "Search for companies",
                    hintStyle: TextStyle(fontSize: ScreenUtil().setSp(14)),
                    border: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onChanged: searching,
                  onSubmitted: (val) {
                    searching(val);
                  },
                  textInputAction: TextInputAction.search,
                ),
              ),
            ),
          ),
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Cancel",
              style: TextStyle(
                  color: Colors.grey.shade800,
                  fontSize: ScreenUtil().setSp(14)),
            ),
          ),
        ],
      ),
      body: searchData == null ? showNoSearching() : showSearchResult(),
    );
  }
}


class UserResult extends StatefulWidget {
  final Cuser userData;
  UserResult(this.userData);

  @override
  _UserResultState createState() => _UserResultState();
}

class _UserResultState extends State<UserResult> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) {
                return Profile(widget.userData.userId, true);
              },
            ),
          );
        },
        leading: CircleAvatar(
            backgroundColor: Colors.grey.shade100,
            backgroundImage: widget.userData.photoUrl == null
                ? null
                : CachedNetworkImageProvider(widget.userData.photoUrl),
            child: widget.userData.photoUrl != null
                ? null
                : Center(
                    child: FittedBox(
                      child: Text(
                        widget.userData.fullName,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  )),
        title: Text(
          widget.userData.fullName,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(widget.userData.typeCompany),
      ),
    );
  }
}
