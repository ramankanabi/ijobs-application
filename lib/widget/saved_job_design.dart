import 'package:flutter/material.dart';
import 'package:iraqijob/pages/login_page.dart';
import 'package:iraqijob/pages/profile.dart';
import 'package:iraqijob/pages/tap_saved_job.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SavedJobDesign extends StatefulWidget {
  final DocumentSnapshot postData;

  SavedJobDesign(this.postData);

  @override
  _SavedJobDesignState createState() => _SavedJobDesignState();
}

class _SavedJobDesignState extends State<SavedJobDesign>
    with AutomaticKeepAliveClientMixin<SavedJobDesign> {
  DocumentSnapshot companyData;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getDoc();
  }

  getDoc() async {
    try {
      isLoading = true;
      companyData = await cUserRef.document(widget.postData["ownerId"]).get();
      setState(() {
        isLoading = false;
      });
    } catch (er) {}
  }

  bool get wantKeepAlive => true;
  Widget build(BuildContext context) {
    super.build(context);
    return isLoading
        ? Card(elevation: 2,
                  child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey.shade200,
              ),
              title: Text(
                "company name",
                style: TextStyle(color: Colors.grey.shade200),
              ),
              subtitle: Text(
                "position",
                style: TextStyle(color: Colors.grey.shade200),
              ),
            ),
        )
        : Card(
            elevation: 2,
            child: ListTile(
              leading: companyData["photoUrl"] == null
                  ? GestureDetector(
                      onTap: () {
                        _showProfile(widget.postData["ownerId"]);
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.grey.shade100,
                        child: FittedBox(
                          child: Text(companyData["fullName"]),
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        _showProfile(widget.postData["ownerId"]);
                      },
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(companyData["photoUrl"]),
                        backgroundColor: Colors.grey.shade100,
                      ),
                    ),
              title: Text(companyData["fullName"]),
              subtitle: Text(
                widget.postData["position"],
                style: TextStyle(color: Colors.blue),
              ),
              onTap: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => TapSavedJob(
                      widget.postData,
                    ),
                  ),
                );
              },
            ),
          );
  }

  _showProfile(String profileId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) {
          return Profile(profileId, true);
        },
      ),
    );
  }
}
