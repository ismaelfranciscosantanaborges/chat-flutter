import 'package:chat_flutter/global/environment.dart';
import 'package:chat_flutter/models/message_response.dart';
import 'package:chat_flutter/models/user.dart';
import 'package:chat_flutter/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatService with ChangeNotifier {
  User userfrom;

  Future<List<Message>> getMessages(String userToId) async {
    final resp = await http.get('${Environment.apiUrl}/messages/$userToId',
        headers: {
          'x-token': await AuthService.getToken(),
          'Content-Type': 'application/json'
        });

    final messages = messageResponseFromJson(resp.body);

    return messages.messages;
  }
}
