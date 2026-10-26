import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();
  var _isSending = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    final enteredMessage = _messageController.text.trim();

    if (enteredMessage.isEmpty || _isSending) {
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please log in to send a support message.'),
        ),
      );
      return;
    }

    FocusScope.of(context).unfocus();
    _messageController.clear();

    setState(() {
      _isSending = true;
    });

    try {
      String username = user.displayName ?? '';
      String? userImage = user.photoURL;

      try {
        final userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userData.exists && userData.data() != null) {
          final data = userData.data()!;
          if ((data['username'] as String?)?.isNotEmpty == true) {
            username = data['username'];
          }
          if ((data['image_url'] as String?)?.isNotEmpty == true) {
            userImage = data['image_url'];
          }
        }
      } catch (_) {
        // Fallback to user auth details if Firestore users collection is unavailable
      }

      if (username.isEmpty) {
        if (user.email != null && user.email!.contains('@')) {
          username = user.email!.split('@')[0];
        } else {
          username = 'Customer';
        }
      }

      userImage ??= 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(username)}&background=1E824C&color=fff';

      await FirebaseFirestore.instance.collection('chat').add({
        'text': enteredMessage,
        'createdAt': Timestamp.now(),
        'userId': user.uid,
        'username': username,
        'userImage': userImage,
      });
    } catch (error) {
      if (mounted) {
        // Restore message so user doesn't lose what they typed
        _messageController.text = enteredMessage;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not send message: $error'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 8, bottom: 14, top: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.08),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: const InputDecoration(
                hintText: 'Ask FreshMart customer support...',
                border: InputBorder.none,
              ),
              onSubmitted: (_) => _submitMessage(),
            ),
          ),
          IconButton(
            color: const Color(0xFF2ECC71),
            icon: _isSending
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.send),
            onPressed: _isSending ? null : _submitMessage,
          ),
        ],
      ),
    );
  }
}
