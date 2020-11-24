import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class Cuser {
  final String userId;
  final String fullName;
  final String email;
  final String photoUrl;
  final String city;
  final String address;
  final String description;
  final String typeCompany;
  final bool isCompany;
  final String phoneNumber;

  Cuser({
    @required this.userId,
    @required this.fullName,
    @required this.email,
    @required this.photoUrl,
    @required this.city,
    @required this.address,
    @required this.description,
    @required this.typeCompany,
    @required this.isCompany,
    @required this.phoneNumber,
  });

  factory Cuser.fromDocument(doc) {
    return Cuser(
      userId: doc["userId"],
      fullName: doc["fullName"],
      email: doc["email"],
      photoUrl: doc["photoUrl"],
      city: doc["city"],
      address: doc["address"],
      description: doc["description"],
      typeCompany: doc["typeCompany"],
      isCompany: doc["isCompany"],
      phoneNumber: doc["phoneNumber"],
    );
  }
}
