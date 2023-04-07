import 'dart:convert';

class MessageModel {
  String id;
  String content;
  String senderMail;
  String messageDate;

  MessageModel({
    required this.id,
    required this.content,
    required this.senderMail,
    required this.messageDate,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'content': content,
      'senderMail': senderMail,
      'messageDate': messageDate,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] as String,
      content: map['content'] as String,
      senderMail: map['senderMail'] as String,
      messageDate: map['messageDate'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) => MessageModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
