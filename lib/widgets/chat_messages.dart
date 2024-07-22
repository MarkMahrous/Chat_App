import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('createdAt', descending: false)
            .snapshots(),
        builder: (ctx, chatSnapshots) {
          if (chatSnapshots.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (chatSnapshots.hasError) {
            return const Center(
              child: Text('An error occurred!'),
            );
          }

          if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
            return const Center(
              child: Text('No messages yet!'),
            );
          }

          final chatDocs = chatSnapshots.data!.docs;
          return ListView.builder(
              itemCount: chatDocs.length,
              itemBuilder: (ctx, index) {
                return Text(chatDocs[index]['text']);
              });
        });
  }
}
