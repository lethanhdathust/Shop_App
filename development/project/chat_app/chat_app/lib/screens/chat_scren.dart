import 'dart:math';

import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/widgets/chat/mesages.dart';
import 'package:chat_app/widgets/chat/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

// ...

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    final fbm = FirebaseMessaging.instance;
    fbm.requestPermission();

 
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('"Flutter Chat"'),
        actions: [
          DropdownButton(
            items: [
              DropdownMenuItem(
                value: 'logout',
                child: Container(
                    child: Row(
                  children: [
                    Icon(Icons.exit_to_app),
                    SizedBox(
                      width: 8,
                    ),
                    Text('Logout'),
                  ],
                )),
              )
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
            icon: Icon(Icons.more_vert),
          )
        ],
      ),
      // body: StreamBuilder(
      //     stream: FirebaseFirestore.instance
      //         .collection('chatapp/lYbZgKN3UPp7lb7HKJts/messages')
      //         .snapshots(),
      //     builder: (context, streamsnapShot) {
      //       if (streamsnapShot.connectionState == ConnectionState.waiting) {
      //         return Center(child: CircularProgressIndicator());
      //       }
      //       final documents = streamsnapShot.data?.docs;
      //       return ListView.builder(
      //           itemCount: documents?.length,
      //           itemBuilder: ((context, index) {
      //             return Container(
      //               padding: EdgeInsets.all(0),
      //               child: Text(documents?[index]['text']),
      //             );
      //           }));
      //     }),
      body: Container(
          child: Column(
        children: [
          Expanded(
              child:
                  Messages()), //Use Listview in a column will not work well because this will take up the height as much as it has
          //* we must use expanded to make sure that the list view only takes as much space as available on the screen
          NewMessage(),
        ],
      )),
      // floatingActionButton: FloatingActionButton(
      //     child: Icon(Icons.add),
      //     onPressed: () {
      //       FirebaseFirestore.instance
      //           .collection('chatapp/lYbZgKN3UPp7lb7HKJts/messages')
      //           .add({'text': 'This was added by clocking the button!'});
      //     }),
    );
  }
}
