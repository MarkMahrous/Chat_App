import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var messageController = TextEditingController();

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  void sendMessage() async {
    final message = messageController.text;

    if (message.trim().isEmpty) {
      return;
    }

    messageController.clear();
    FocusScope.of(context).unfocus();

    final userId = FirebaseAuth.instance.currentUser!.uid;

    final userData =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    FirebaseFirestore.instance.collection('chat').add({
      'text': message,
      'createdAt': Timestamp.now(),
      'userId': userId,
      'username': userData['username'],
      'imageUrl': userData['imageUrl'],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 10, right: 1),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: const InputDecoration(labelText: 'Send message'),
              controller: messageController,
              autocorrect: true,
              enableSuggestions: true,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: sendMessage,
          ),
        ],
      ),
    );
  }
}
