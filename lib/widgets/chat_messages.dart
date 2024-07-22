import 'package:chat_app/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy(
              'createdAt',
              descending: true,
            )
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
              reverse: true,
              itemCount: chatDocs.length,
              itemBuilder: (ctx, index) {
                final chatMessage = chatDocs[index].data();
                final nextChatMessage = index + 1 < chatDocs.length
                    ? chatDocs[index + 1].data()
                    : null;
                final isFirstMessage = nextChatMessage == null ||
                    nextChatMessage['userId'] != chatMessage['userId'];
                final isMe = chatMessage['userId'] == currentUser!.uid;

                if (isFirstMessage) {
                  return MessageBubble.first(
                    userImage: chatMessage['imageUrl'],
                    username: chatMessage['username'],
                    message: chatMessage['text'],
                    isMe: isMe,
                  );
                }

                return MessageBubble.next(
                  message: chatMessage['text'],
                  isMe: isMe,
                );
              });
        });
  }
}
