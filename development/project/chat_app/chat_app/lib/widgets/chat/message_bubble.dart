import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String username;
  final String userImage;
  final Key key;
  MessageBubble(this.message, this.isMe, this.username, this.userImage,
      {required this.key});
  @override
  Widget build(BuildContext context) {
    return Stack(

      clipBehavior: Clip.none,//Equal visible
            children: [
      Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: isMe ? Colors.blueGrey : Colors.lime[400],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(12),
                bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
              ),
            ),
            width: 140,
            padding: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 16,
            ),
            margin: EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 10,
            ),
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                // if (snapshot.connectionState == ConnectionState.waiting) {
                //   return Text('Loading');
                // }
                Text(
                  username,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                Text(
                  message,
                  style: TextStyle(
                    color: isMe ? Colors.black : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      Positioned(
        child: CircleAvatar(backgroundImage: NetworkImage(userImage),),
        top: 0, 
        left: isMe? null:120,
        right:  isMe?120 : null,
      ),
      
    ],
    
    
    );
  }
}
