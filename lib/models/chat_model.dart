import 'dart:convert';
import 'package:quickchat/models/message_model.dart';

class ChatModel {
  String chatId;
  List<MessageModel> messages;
  ChatModel({
    required this.chatId,
    required this.messages,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'chatId': chatId,
      'messages': messages.map((x) => x.toMap()).toList(),
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
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatModel.fromJson(String source) => ChatModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
