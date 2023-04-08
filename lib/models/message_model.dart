import 'dart:convert';

class MessageModel {
  String id;
  String content;
  String senderMail;
  String messageDate;
  bool hasImage;
  String imageUrl;

  MessageModel({
    required this.id,
    required this.content,
    required this.senderMail,
    required this.messageDate,
    this.hasImage = false,
    this.imageUrl = "",
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'content': content,
      'senderMail': senderMail,
      'messageDate': messageDate,
      'hasImage': hasImage,
      'imageUrl': imageUrl,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] as String,
      content: map['content'] as String,
      senderMail: map['senderMail'] as String,
      messageDate: map['messageDate'] as String,
      hasImage: map['hasImage'] as bool,
      imageUrl: map['imageUrl'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) => MessageModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
