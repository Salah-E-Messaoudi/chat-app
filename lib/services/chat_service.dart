import 'dart:developer';

import 'package:chat_app/models.dart/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  // create new message and send it to the other user
  static Future<void> create(
    String recieverID,
    String senderID,
    String message,
    String docID,
  ) async {
    try {
      Message newMessage = Message(
        senderID: senderID,
        recieverID: recieverID,
        message: message,
        createdAt: DateTime.now(),
      );
      await FirebaseFirestore.instance
          .collection('conversations')
          .doc(docID)
          .collection('messages')
          .add(newMessage.toMap);
    } catch (e) {
      log("Error creating message: $e");
    }
  }

  // get conversation messages
  static Stream<QuerySnapshot> get(
      String recieverID, String senderID, String docID) {
    try {
      return FirebaseFirestore.instance
          .collection('conversations')
          .doc(docID)
          .collection('messages')
          .orderBy('timestamp', descending: false)
          .snapshots();
    } catch (e) {
      log("Error getting messages: $e");
      rethrow;
    }
  }

  // store last message readed by the users
  static Future<void> setLastMessageReadID(
    String docID,
    String uid,
    String lastMessageID,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('conversations')
          .doc(docID)
          .collection('users')
          .doc(uid)
          .set({'lastReadMessageID': lastMessageID}, SetOptions(merge: true));
    } catch (e) {
      log("Error setting last read message ID: $e");
    }
  }

  // calculate the number of unread messages by the users
  static Future<int> getUnreadMessagesLength(
    String docID,
    String uid,
    String lastReadMessageId,
  ) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('conversations')
          .doc(docID)
          .collection('messages')
          .where('id', isGreaterThan: lastReadMessageId)
          .get();

      return snapshot.size;
    } catch (e) {
      log("Error getting unread messages length: $e");
      rethrow;
    }
  }
}
