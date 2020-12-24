import 'package:chat_flutter/global/environment.dart';
import 'package:chat_flutter/models/user.dart';
import 'package:chat_flutter/models/user_response.dart';
import 'package:chat_flutter/services/auth_service.dart';
import 'package:http/http.dart' as http;

class UsersServices {
  Future<List<User>> getUsers() async {
    final resp = await http.get('${Environment.apiUrl}/users', headers: {
      'x-token': await AuthService.getToken(),
      'Content-Type': 'application/json'
    });

    return userResponseFromJson(resp.body).users;
  }
}
