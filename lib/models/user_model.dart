import 'dart:convert';

import 'package:quickchat/constants/image_constants.dart';

class UserModel {
  String email;
  String password;
  String? firstName;
  String? lastName;
  String? photoUrl;
  String? createdDate;
  String? notificationToken;

  UserModel({
    required this.email,
    required this.password,
    this.firstName,
    this.lastName,
    this.photoUrl,
    this.createdDate,
    this.notificationToken,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'photoUrl': photoUrl ?? ImageAssetKeys.defaultProfilePhotoUrl,
      'createdDate': createdDate ?? DateTime.now().toString(),
      'notificationToken': notificationToken,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] as String,
      password: map['password'] as String,
      firstName: map['firstName'] != null ? map['firstName'] as String : null,
      lastName: map['lastName'] != null ? map['lastName'] as String : null,
      photoUrl: map['photoUrl'] != null ? map['photoUrl'] as String : null,
      createdDate: map['createdDate'] != null ? map['createdDate'] as String : null,
      notificationToken: map['notificationToken'] != null ? map['notificationToken'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
