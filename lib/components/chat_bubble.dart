import 'package:chat_app/models.dart/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
    required this.isMine,
  });
  final Message message;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
          padding: EdgeInsets.all(8.sp),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.sp),
            color: isMine
                ? Theme.of(context).primaryColor
                : Theme.of(context).primaryColor.withOpacity(0.2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 0.8.sw,
                  minWidth: 0.2.sw,
                ),
                child: Text(
                  message.message,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isMine ? Colors.white : Colors.black,
                  ),
                ),
              ),
              Text(
                DateFormat('hh:mm').format(message.createdAt),
                style: TextStyle(
                  fontSize: 10.sp,
                  color: isMine ? Colors.white : Colors.black,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
