import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final textController = TextEditingController();
  var _enterMessage = '';
  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    final userdata = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    print('userData' + userdata.toString());
    // var a = await FirebaseFirestore.instance
    //     .collection('chatapp/lYbZgKN3UPp7lb7HKJts/messages')
    //     .snapshots()
    //     .listen((event) {
    //   print(event.docs[0]['text']);
    // });

    // print(a);
    FirebaseFirestore.instance.collection('chat').add({
      'text': _enterMessage,
      'createAt': Timestamp.now(),
      'userId': user.uid, //This object holds current Id
      'username': userdata['username'],
      'userImage':userdata['image_url'],
    });
    textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(9),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textController,
              decoration: InputDecoration(hintText: 'Add new message'),
              onChanged: (value) {
                _enterMessage = value;
              },
            ),
          ),
          IconButton(
              color: Theme.of(context).colorScheme.onPrimary,
              onPressed: () {
                _enterMessage.trim().isEmpty ? null : _sendMessage();
              },
              icon: Icon(Icons.send)),
        ],
      ),
    );
  }
}
