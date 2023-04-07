import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickchat/helpers/shared_preferences_helper.dart';
import 'package:quickchat/models/message_model.dart';
import 'package:quickchat/models/response_model.dart';
import 'package:quickchat/models/user_model.dart';
import 'package:quickchat/routes/route_constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_database/firebase_database.dart';

class UserService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference profiles = FirebaseFirestore.instance.collection('profiles');
  CollectionReference notificationTokens = FirebaseFirestore.instance.collection('notificationTokens');

  FirebaseDatabase database = FirebaseDatabase.instance;

  Future<ResponseModel> register(UserModel model) async {
    bool isSucceeded = false;
    await FirebaseFirestore.instance.collection('profiles').where('email', isEqualTo: model.email).get().then((value) async {
      if (value.docs.isEmpty) {
        await FirebaseFirestore.instance.collection('images').doc("profile").get().then((value) {
          model.photoUrl = value.get("defaultProfilePhoto");
        });

        await profiles.doc(model.email).set(model.toMap()).then((value1) {
          debugPrint("User successfully added.");
          isSucceeded = true;
        }).catchError((error) {
          debugPrint("An error occurred while adding the user!");
          isSucceeded = false;
        });
      } else {
        debugPrint("Current user!");
        isSucceeded = false;
      }
    });
    return ResponseModel(isSucceeded: isSucceeded);
  }

  Future<ResponseModel> login(UserModel model) async {
    bool isSucceeded = false;
    UserModel? loggedUserModel;
    await FirebaseFirestore.instance.collection('profiles').where('email', isEqualTo: model.email).get().then((value) async {
      if (value.docs.isEmpty) {
        debugPrint("Non existing user!");
        isSucceeded = false;
      } else {
        await FirebaseFirestore.instance
            .collection('profiles')
            .where('email', isEqualTo: model.email)
            .where('password', isEqualTo: model.password)
            .get()
            .then((value) {
          if (value.docs.isEmpty) {
            debugPrint("Wrong email or password!");
            isSucceeded = false;
          } else {
            debugPrint(value.docs[0].data().toString());
            loggedUserModel = UserModel.fromMap(value.docs[0].data());
            isSucceeded = true;
          }
        });
      }
    });
    return ResponseModel(isSucceeded: isSucceeded, body: loggedUserModel);
  }

  void logout(BuildContext context) {
    SharedPreferencesHelper.remove("loggedUser");
    Navigator.pushNamedAndRemoveUntil(context, loginPageRoute, (route) => false);
  }

  Future<ResponseModel> update(UserModel model) async {
    bool isSucceeded = false;
    await FirebaseFirestore.instance.collection('profiles').where('email', isEqualTo: model.email).get().then((value) async {
      if (value.docs.isNotEmpty) {
        await profiles.doc(model.email).update(model.toMap()).then((value1) {
          debugPrint("Profile updated.");
          isSucceeded = true;
        }).catchError((error) {
          debugPrint("An error occurred while updating the profile!");
          isSucceeded = false;
        });
      } else {
        debugPrint("Non existing user!");
        isSucceeded = false;
      }
    });
    return ResponseModel(isSucceeded: isSucceeded);
  }

  Future<ResponseModel> updatePassword(UserModel model) async {
    bool isSucceeded = false;
    await FirebaseFirestore.instance.collection('profiles').where('email', isEqualTo: model.email).get().then((value) async {
      if (value.docs.isNotEmpty) {
        await profiles.doc(model.email).update({
          "password": model.password,
        }).then((value1) {
          debugPrint("Profile updated.");
          isSucceeded = true;
        }).catchError((error) {
          debugPrint("An error occurred while updating the profile!");
          isSucceeded = false;
        });
      } else {
        debugPrint("Non existing user!");
        isSucceeded = false;
      }
    });
    return ResponseModel(isSucceeded: isSucceeded);
  }

  Future<ResponseModel> setLoggedUser(UserModel model) async {
    return await SharedPreferencesHelper.setString("loggedUser", jsonEncode(model.toJson())).then((value) {
      debugPrint("true");
      return ResponseModel(isSucceeded: true);
    }).onError((error, stackTrace) {
      return ResponseModel(isSucceeded: false);
    });
  }

  Future<bool> hasProfile(String email) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('profiles').where('email', isEqualTo: email).get();
    if (snapshot.docs.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> userInfoFull(String email) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('profiles').where('email', isEqualTo: email).get();
    var userName = snapshot.docs[0].get("userName");
    var firstName = snapshot.docs[0].get("firstName");
    var lastName = snapshot.docs[0].get("lastName");

    if ((userName == null || userName.toString().isEmpty) ||
        (firstName == null || firstName.toString().isEmpty) ||
        (lastName == null || lastName.toString().isEmpty)) {
      debugPrint("null info");
      return false;
    } else {
      debugPrint("not null info");
      return true;
    }
  }

  Future<UserModel> getUser(String email) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('profiles').where('email', isEqualTo: email).get();
    UserModel model = UserModel.fromJson(json.encode(snapshot.docs[0].data()));
    return model;
  }

  Future<String?> uploadImage(File image, String child) async {
    final storageRef = FirebaseStorage.instance.ref();
    try {
      TaskSnapshot snapshot = await storageRef.child(child).putFile(image);
      return await snapshot.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      debugPrint(e.message);
      return null;
    }
  }

  Future<ResponseModel> updateNotificationToken(UserModel model, String token) async {
    bool isSucceeded = false;
    await notificationTokens.doc(model.email).set({'token': token});
    await profiles.where('email', isEqualTo: model.email).get().then((value) async {
      if (value.docs.isNotEmpty) {
        await profiles.doc(model.email).update({
          "notificationToken": token,
        }).then((value1) {
          debugPrint("Notification Token updated.");
          isSucceeded = true;
        }).catchError((error) {
          debugPrint("An error occurred while updating the profile!");
          isSucceeded = false;
        });
      } else {
        debugPrint("Non existing user!");
        isSucceeded = false;
      }
    });
    return ResponseModel(isSucceeded: isSucceeded);
  }

  Future<bool> checkUsername(UserModel model, String username) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('profiles').where('userName', isEqualTo: username).get();
    if (model.userName == username) {
      return true;
    }
    return snapshot.docs.isEmpty;
  }

  Future<ResponseModel> sendMessage(UserModel loggedUser, UserModel targetUser, MessageModel messageModel) async {
    bool isSucceeded = false;
    String chatId = loggedUser.userName.compareTo(targetUser.userName) < 0
        ? "${loggedUser.userName}-${targetUser.userName}"
        : "${targetUser.userName}-${loggedUser.userName}";
    try {
      DatabaseReference messageRef = FirebaseDatabase.instance.ref().child("chats").child(chatId).child(messageModel.id);
      await messageRef.set(messageModel.toJson());
      isSucceeded = true;
    } catch (error) {
      isSucceeded = false;
    }

    return ResponseModel(isSucceeded: isSucceeded);
  }

  Future<List<MessageModel>> getMessages(UserModel loggedUser, UserModel targetUser) async {
    List<MessageModel> messages = [];
    String chatId = loggedUser.userName.compareTo(targetUser.userName) < 0
        ? "${loggedUser.userName}-${targetUser.userName}"
        : "${targetUser.userName}-${loggedUser.userName}";
    try {
      DatabaseReference messagesRef = FirebaseDatabase.instance.ref().child("chats").child(chatId);
      DataSnapshot dataSnapshot = await messagesRef.get();
      if (dataSnapshot.value != null) {
        Map<dynamic, dynamic> messagesMap = dataSnapshot.value as Map<dynamic, dynamic>;
        messagesMap.forEach((key, value) {
          MessageModel message = MessageModel.fromJson(value);
          messages.add(message);
        });
      }
    } catch (error) {
      debugPrint("Error getting messages: $error");
    }
    return messages;
  }
}
