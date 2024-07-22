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

  void sendMessage() {
    final message = messageController.text;

    if (message.trim().isEmpty) {
      return;
    }

    messageController.clear();
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
