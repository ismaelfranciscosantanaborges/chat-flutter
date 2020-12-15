import 'dart:io';

import 'package:chat_flutter/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  static final String route = 'ChatPage';

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  TextEditingController _textController;
  FocusNode _focusNode = FocusNode();
  bool _isReading;

  List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _messages = [];
    _isReading = false;
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    for (ChatMessage message in _messages) {
      message.controller.dispose();
    }
    //TODO:OFF the socket
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue[100],
              child: Text(
                'Al',
                style: TextStyle(fontSize: 12),
              ),
              maxRadius: 14,
            ),
            SizedBox(height: 3),
            Text(
              'Alisia Duran',
              style: TextStyle(color: Colors.black87, fontSize: 12),
            )
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (_, i) => _messages[i],
              ),
            ),
            Divider(
              height: 1,
            ),
            _buildInputChat(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputChat() {
    return SafeArea(
      child: Container(
        height: 50, //70
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                focusNode: _focusNode,
                onChanged: (value) {
                  if (value.trim().length > 0) {
                    _isReading = true;
                  } else {
                    _isReading = false;
                  }
                  setState(() {});
                },
                onSubmitted: _handleSubmitted,
                decoration:
                    InputDecoration.collapsed(hintText: 'Send Messages ...'),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              child: Platform.isIOS
                  ? CupertinoButton(
                      child: Text('Send'),
                      onPressed: _isReading
                          ? () => _handleSubmitted(_textController.text.trim())
                          : null,
                    )
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      child: IconTheme(
                        data: IconThemeData(color: Colors.blue[400]),
                        child: IconButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          icon: Icon(Icons.send),
                          onPressed: _isReading
                              ? () =>
                                  _handleSubmitted(_textController.text.trim())
                              : null,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  _handleSubmitted(String text) {
    print(_textController.text);
    _textController.clear();
    _focusNode.requestFocus();

    final ChatMessage newMessage = ChatMessage(
      controller: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 400),
      ),
      uid: '123',
      text: text,
    );

    _messages.insert(0, newMessage);

    newMessage.controller.forward();

    setState(() => _isReading = false);
  }
}
