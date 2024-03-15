import 'package:cloud_firestore/cloud_firestore.dart';

class Conversation {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String id;
  final String name;
  final String lastMessage;
  final Map<String, dynamic> unread;
  final DateTime updatedAt;
  final DateTime createdAt;
  final DocumentReference reference;

  Conversation({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.unread,
    required this.updatedAt,
    required this.createdAt,
    required this.reference,
  });

  Map<String, dynamic> get toMapInit {
    return {
      'id': id,
      'name': name,
      'lastMessage': lastMessage,
      'unread': unread,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'reference': reference,
    };
  }

  factory Conversation.init({
    required String name,
    required String senderID,
    required String receiverID,
  }) {
    DocumentReference reference =
        FirebaseFirestore.instance.collection('conversations').doc();
    return Conversation(
      id: reference.id,
      name: name,
      lastMessage: '',
      unread: {
        senderID: 0,
        receiverID: 0,
      },
      updatedAt: DateTime.now(),
      createdAt: DateTime.now(),
      reference: reference,
    );
  }

  factory Conversation.fromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> json = doc.data() as Map<String, dynamic>;

    return Conversation(
      id: doc.id,
      name: json['name'],
      lastMessage: json['lastMessage'] ?? '',
      unread: json['unread'],
      createdAt: json['createdAt'] == null
          ? DateTime.now()
          : (json['createdAt'] as Timestamp).toDate(),
      updatedAt: json['updatedAt'] == null
          ? DateTime.now()
          : (json['updatedAt'] as Timestamp).toDate(),
      reference: doc.reference,
    );
  }
}
