import 'dart:developer';

import 'package:chat_app/models.dart/conversation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConversationService {
  // create new conversation
  static Future<void> create(
      String name, String senderID, String receiverID) async {
    try {
      Conversation conversation = Conversation.init(
        name: name,
        senderID: senderID,
        receiverID: receiverID,
      );
      await conversation.reference.set(conversation.toMapInit);
    } catch (e) {
      log("Error creating conversation: $e");
    }
  }

  // get conversations
  static Stream<QuerySnapshot> get() {
    try {
      return FirebaseFirestore.instance
          .collection('conversations')
          .orderBy('updatedAt', descending: true)
          .snapshots();
    } catch (e) {
      log("Error getting conversations: $e");
      rethrow;
    }
  }

  // update conversation
  static Future<void> update(
      String receiverID, String message, String docID) async {
    try {
      Map<String, dynamic> conversationMapUpdate = {
        'updatedAt': FieldValue.serverTimestamp(),
        'unread.$receiverID': FieldValue.increment(1),
        'lastMessage': message,
      };

      await FirebaseFirestore.instance
          .collection('conversations')
          .doc(docID)
          .update(conversationMapUpdate);
    } catch (e) {
      log("Error updating conversation: $e");
    }
  }

  // user read all messages
  static Future<void> markAsSeen(String uid, String docID) async {
    try {
      Map<String, dynamic> conversationMapUpdate = {
        'unread.$uid': 0,
      };
      await FirebaseFirestore.instance
          .collection('conversations')
          .doc(docID)
          .update(conversationMapUpdate);
    } catch (e) {
      log("Error marking messages as seen: $e");
    }
  }
}
