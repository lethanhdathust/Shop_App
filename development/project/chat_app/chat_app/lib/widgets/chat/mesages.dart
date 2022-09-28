import 'package:chat_app/widgets/chat/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.value(
          FirebaseAuth.instance.currentUser), //Convert user to future
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // print('CurrentUser: ' +
          //     FirebaseAuth.instance.currentUser.toString());
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('chat')
                .orderBy('createAt', descending: true)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                    chatSnapshop) {
              if (chatSnapshop.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final chatDocs = chatSnapshop.data!.docs;
              // print(ValueKey(chatDocs[0].id));

              return ListView.builder(
                reverse: true,
                itemBuilder: (ctx, index) {
                  return MessageBubble(
                    chatDocs[index]['text'],
                    chatDocs[index]['userId'] == snapshot.data!.uid,
                    chatDocs[index]['username'],
                    chatDocs[index]['userImage'],
                    key: ValueKey(chatDocs[index].id),
                  );
                },
                itemCount: chatDocs.length,
              );
            });
      },
    );
  }
}
