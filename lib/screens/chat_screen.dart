import 'package:chat_app/components/custom_textfield.dart';
import 'package:chat_app/components/chat_bubble.dart';
import 'package:chat_app/models.dart/message.dart';
import 'package:chat_app/models.dart/user.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/services/conversation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.sender,
    required this.reciever,
    required this.docID,
  });
  final User sender, reciever;
  final String docID;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController textEditingController = TextEditingController();
  late Stream<QuerySnapshot<Object?>> myStream;

  @override
  void initState() {
    super.initState();
    myStream = ChatService.get(
      widget.reciever.id,
      widget.sender.id,
      widget.docID,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(widget.reciever.name),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        color: Colors.white,
        padding: EdgeInsets.all(12.sp),
        child: Row(
          children: [
            Expanded(
              child: CustomTextField(
                hintText: 'type your message...',
                controller: textEditingController,
                onEditingComplete: sendMessage,
              ),
            ),
            SizedBox(width: 16.w),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                onPressed: sendMessage,
                icon: const Icon(Icons.send_rounded),
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: myStream,
              builder: (context, snapshot) {
                ConversationService.markAsSeen(widget.sender.id, widget.docID);

                if (snapshot.hasError) {
                  return const Text(
                    'An error occurred while attempting to retrieve the data',
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: 40.sp,
                    width: 40.sp,
                    child: const FittedBox(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    Message message = Message.fromJson(snapshot.data!.docs
                        .elementAt(index)
                        .data() as Map<String, dynamic>);
                    return ChatBubble(
                      message: message,
                      isMine: widget.sender.id == message.senderID,
                    );
                  },
                );
              },
            ),
          ),
          Container(
            color: Colors.white,
            height: MediaQuery.of(context).viewPadding.bottom,
          ),
        ],
      ),
    );
  }

  void sendMessage() async {
    // I added this variable because there is delay to clear the controller
    String message = textEditingController.text;
    textEditingController.clear();

    if (message.isNotEmpty) {
      await ChatService.create(
        widget.reciever.id,
        widget.sender.id,
        message,
        widget.docID,
      );
      await ConversationService.update(
        widget.reciever.id,
        message,
        widget.docID,
      );
    }
  }
}
