import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderID;
  final String recieverID;
  final String message;
  final DateTime createdAt;

  Message({
    required this.senderID,
    required this.recieverID,
    required this.message,
    required this.createdAt,
  });

  Map<String, dynamic> get toMap {
    return {
      'senderID': senderID,
      'recieverID': recieverID,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      senderID: json['senderID'],
      recieverID: json['recieverID'],
      message: json['message'],
      createdAt: json['timestamp'] == null
          ? DateTime.now()
          : (json['timestamp'] as Timestamp).toDate(),
    );
  }
}
