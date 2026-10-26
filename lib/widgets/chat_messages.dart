import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:first_app/widgets/message_bubble.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser;
    final myUid = authenticatedUser?.uid ?? '';

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx, chatSnapshots) {
        if (chatSnapshots.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Could not load messages: ${chatSnapshots.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          );
        }

        if (chatSnapshots.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
                SizedBox(height: 12),
                Text(
                  'No messages yet. Send a message to FreshMart support!',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        final loadedMessages = chatSnapshots.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.only(
            bottom: 40,
            left: 13,
            right: 13,
          ),
          reverse: true,
          itemCount: loadedMessages.length,
          itemBuilder: (ctx, index) {
            final chatMessage = loadedMessages[index].data();
            final nextChatMessage = index + 1 < loadedMessages.length
                ? loadedMessages[index + 1].data()
                : null;

            final currentMessageUserId = chatMessage['userId'] as String? ?? '';
            final nextMessageUserId =
                nextChatMessage != null ? (nextChatMessage['userId'] as String? ?? '') : null;
            final nextUserIsSame = nextMessageUserId == currentMessageUserId;
            final isMe = myUid.isNotEmpty && myUid == currentMessageUserId;
            final messageText = chatMessage['text'] as String? ?? '';
            final username = chatMessage['username'] as String? ?? 'User';
            final userImage = chatMessage['userImage'] as String?;

            if (nextUserIsSame) {
              return MessageBubble.next(
                message: messageText,
                isMe: isMe,
              );
            } else {
              return MessageBubble.first(
                userImage: userImage,
                username: username,
                message: messageText,
                isMe: isMe,
              );
            }
          },
        );
      },
    );
  }
}
