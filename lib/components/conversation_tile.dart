import 'package:chat_app/data/users_list.dart';
import 'package:chat_app/models.dart/conversation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ConversationTile extends StatelessWidget {
  const ConversationTile({
    super.key,
    required this.conversation,
    required this.tabController,
  });
  final Conversation conversation;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    bool hasUnreadMessage =
        conversation.unread[listUsers[tabController.index].id] > 0;

    return Container(
      padding: EdgeInsets.all(16.sp),
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16.sp),
      ),
      height: 72.h,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  conversation.name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w900,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  conversation.lastMessage.isEmpty
                      ? 'Send the first message in this conversation'
                      : conversation.lastMessage,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight:
                        hasUnreadMessage ? FontWeight.bold : FontWeight.normal,
                    color: hasUnreadMessage
                        ? Theme.of(context).primaryColor
                        : Colors.grey[800],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formatDate(conversation.updatedAt),
                style: TextStyle(
                  fontSize: 12.sp,
                  height: 2,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Visibility(
                visible: hasUnreadMessage,
                child: Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Center(
                    child: Text(
                      conversation.unread[listUsers[tabController.index].id]
                          .toString(),
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  String formatDate(DateTime dateTime) {
    DateTime now = DateTime.now();

    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return DateFormat('hh:mm').format(dateTime);
    } else {
      return DateFormat('MM/dd').format(dateTime);
    }
  }
}
