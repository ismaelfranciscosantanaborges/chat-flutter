import 'dart:io';

import 'package:chat_flutter/services/auth_service.dart';
import 'package:chat_flutter/services/chat_service.dart';
import 'package:chat_flutter/services/socket_service.dart';
import 'package:chat_flutter/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  ChatService chatService;
  SocketService socketService;
  AuthService authService;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _messages = [];
    _isReading = false;
    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);

    socketService.socket.on('new-message', _listenerMessage);

    _loadMessages();
  }

  _loadMessages() async {
    final messages =
        await this.chatService.getMessages(chatService.userfrom.uid);

    final allMessages = messages
        .map(
          (ms) => ChatMessage(
            text: ms.message,
            uid: ms.from,
            controller: AnimationController(
              vsync: this,
              duration: Duration(seconds: 0),
            ),
          ),
        )
        .toList();

    for (var message in allMessages) {
      message.controller.forward();
    }

    _messages.insertAll(0, allMessages);
    setState(() {});
  }

  void _listenerMessage(dynamic payload) {
    ChatMessage chatMessage = ChatMessage(
      controller: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 300),
      ),
      uid: payload['uid'],
      text: payload['message'],
    );

    _messages.insert(0, chatMessage);
    chatMessage.controller.forward();
    setState(() {});
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    for (ChatMessage message in _messages) {
      message.controller.dispose();
    }
    //TODO:OFF the socket
    socketService.socket.off('new-message');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userFrom = chatService.userfrom;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.blue),
        elevation: 1,
        centerTitle: true,
        title: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue[100],
              child: Text(
                userFrom.name.substring(0, 2),
                style: TextStyle(fontSize: 12),
              ),
              maxRadius: 14,
            ),
            SizedBox(height: 3),
            Text(
              userFrom.name,
              style: TextStyle(color: Colors.black87, fontSize: 14),
            )
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            _buildListMessages(),
            Divider(height: 1),
            _buildInputChat(),
          ],
        ),
      ),
    );
  }

  Flexible _buildListMessages() {
    return Flexible(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              Platform.isIOS
                  ? 'assets/background_ios.jpg'
                  : 'assets/background_android.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.builder(
          reverse: true,
          itemCount: _messages.length,
          itemBuilder: (_, i) => _messages[i],
        ),
      ),
    );
  }

  Widget _buildInputChat() {
    return SafeArea(
      child: Container(
        height: 50, //70
        color: Colors.white,
        padding: EdgeInsets.only(left: 8, right: 8),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                focusNode: _focusNode,
                textCapitalization: TextCapitalization.sentences,
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
                      // margin: EdgeInsets.symmetric(horizontal: 4),
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
    if (text.length <= 0) return;

    socketService.socket.emit('new-message', {
      'from': authService.user.uid,
      'to': chatService.userfrom.uid,
      'message': text
    });

    print(_textController.text);
    _textController.clear();
    _focusNode.requestFocus();

    final ChatMessage newMessage = ChatMessage(
      controller: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 400),
      ),
      uid: authService.user.uid,
      text: text,
    );

    _messages.insert(0, newMessage);

    newMessage.controller.forward();

    setState(() => _isReading = false);
  }
}
