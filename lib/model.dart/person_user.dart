import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class Puser {
  final String userId;
  final String fullName;
  final String email;
  final String photoUrl;
  final String phoneNumber;
  final String city;
  final String address;
  final int birthYear;
  final String interestedCompany;
  final bool isCompany;
  final String gender;

  Puser({
    @required this.gender,
    @required this.isCompany,
    @required this.userId,
    @required this.fullName,
    @required this.email,
    @required this.photoUrl,
    @required this.phoneNumber,
    @required this.city,
    @required this.address,
    @required this.birthYear,
    @required this.interestedCompany,
  });

  factory Puser.fromDocument(doc) {
    return Puser(
      gender: doc["gender"],
      userId: doc["userId"],
      fullName: doc["fullName"],
      email: doc["email"],
      photoUrl: doc["photoUrl"],
      phoneNumber: doc["phoneNumber"],
      city: doc["city"],
      address: doc["address"],
      birthYear: doc["birthYear"],
      interestedCompany: doc["interestedCompany"],
      isCompany: doc["isCompany"]
    );
  }
}
