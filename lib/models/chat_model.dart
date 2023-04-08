import 'dart:convert';
import 'package:quickchat/models/message_model.dart';
import 'package:quickchat/models/user_model.dart';

class ChatModel {
  String chatId;
  List<MessageModel> messages;
  UserModel targetUser;
  MessageModel lastMessage;
  ChatModel({
    required this.chatId,
    required this.messages,
    required this.targetUser,
    required this.lastMessage,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'chatId': chatId,
      'messages': messages.map((x) => x.toMap()).toList(),
      'targetUser': targetUser.toMap(),
      'lastMessage': lastMessage.toMap(),
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      chatId: map['chatId'] as String,
      messages: List<MessageModel>.from(
        (map['messages'] as List<int>).map<MessageModel>(
          (x) => MessageModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      targetUser: UserModel.fromMap(map['targetUser'] as Map<String, dynamic>),
      lastMessage: MessageModel.fromMap(map['lastMessage'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatModel.fromJson(String source) => ChatModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
