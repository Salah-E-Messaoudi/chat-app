import 'package:chat_app/components/conversation_tile.dart';
import 'package:chat_app/data/users_list.dart';
import 'package:chat_app/models.dart/conversation.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/services/conversation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserAScreen extends StatefulWidget {
  const UserAScreen({
    super.key,
    required this.tabController,
  });

  final TabController tabController;

  @override
  State<UserAScreen> createState() => _UserAScreenState();
}

class _UserAScreenState extends State<UserAScreen> {
  late Stream<QuerySnapshot<Object?>> myStream;

  @override
  void initState() {
    super.initState();
    myStream = ConversationService.get();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.sp),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Text(
                    'Conversations',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Divider(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder(
              stream: myStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('ERROR');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                return ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: snapshot.data!.docs.map(
                    (doc) {
                      Conversation conversation =
                          Conversation.fromDocumentSnapshot(doc);
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              sender: listUsers[widget.tabController.index],
                              reciever:
                                  listUsers[1 - widget.tabController.index],
                              docID: doc.id,
                            ),
                          ),
                        ),
                        child: ConversationTile(
                          conversation: conversation,
                          tabController: widget.tabController,
                        ),
                      );
                    },
                  ).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
