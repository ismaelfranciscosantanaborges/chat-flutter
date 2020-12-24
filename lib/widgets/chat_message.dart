import 'package:chat_flutter/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatMessage extends StatelessWidget {
  final String text;
  final String uid;
  final AnimationController controller;

  const ChatMessage({
    @required this.text,
    @required this.uid,
    @required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return FadeTransition(
      opacity: controller,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(
          parent: controller,
          curve: Curves.easeOut,
        ),
        child: Container(
          child: uid == authService.user.uid
              ? _buildMyMessage()
              : _buildNotMyMessage(),
        ),
      ),
    );
  }

  Widget _buildMyMessage() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.only(left: 50, right: 5, bottom: 5),
        decoration: BoxDecoration(
          color: Colors.blue[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          this.text,
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
    );
  }

  _buildNotMyMessage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.only(left: 5, right: 50, bottom: 5),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          this.text,
          style: TextStyle(color: Colors.black87, fontSize: 16),
        ),
      ),
    );
  }
}
