import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickchat/constants/image_constants.dart';

class UserModel {
  String email;
  String password;
  String firstName;
  String lastName;
  String userName;
  String photoUrl;
  String? createdDate;
  String notificationToken;

  UserModel({
    required this.email,
    required this.password,
    this.firstName = "",
    this.lastName = "",
    this.userName = "",
    this.photoUrl = ImageAssetKeys.defaultProfilePhotoUrl,
    this.createdDate,
    this.notificationToken = "",
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'userName': userName,
      'photoUrl': photoUrl,
      'createdDate': createdDate ?? DateTime.now().toString(),
      'notificationToken': notificationToken,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] as String,
      password: map['password'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      userName: map['userName'] as String,
      photoUrl: map['photoUrl'] as String,
      createdDate: map['createdDate'] != null ? map['createdDate'] as String : null,
      notificationToken: map['notificationToken'] as String,
    );
  }

  factory UserModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return UserModel(
      email: data['email'],
      password: data['password'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      userName: data['userName'],
      photoUrl: data['photoUrl'],
      createdDate: data['createdDate'],
      notificationToken: data['notificationToken'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
