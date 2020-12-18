import 'dart:convert';

import 'package:chat_flutter/global/environment.dart';
import 'package:chat_flutter/models/login_response.dart';
import 'package:chat_flutter/models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthService with ChangeNotifier {
  User user;
  bool _autenticando = false;
  FlutterSecureStorage _storage = FlutterSecureStorage();

  bool get autenticando => this._autenticando;

  set autenticando(bool value) {
    this._autenticando = value;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    autenticando = true;
    final data = {'email': email, 'password': password};

    final response = await http.post('${Environment.apiUrl}/login',
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    print(response.body);
    autenticando = false;
    if (response.statusCode == 200) {
      final loginResponse = loginResponseFromJson(response.body);
      this.user = loginResponse.user;

      print(loginResponse.token);
      _savedToken(loginResponse.token);

      return true;
    } else {
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    Map<String, dynamic> data = {
      'name': name,
      'email': email,
      'password': password
    };

    final resp = await http.post(
      '${Environment.apiUrl}/login/new',
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );

    if (resp.statusCode == 200) {
      LoginResponse loginResponse = loginResponseFromJson(resp.body);
      this.user = loginResponse.user;
      await _savedToken(loginResponse.token);

      return true;
    } else {
      return false;
    }
  }

  Future isLoginIn() async {
    final token = await this._storage.read(key: 'token');

    final resp = await http
        .get('${Environment.apiUrl}/login/renew', headers: {'x-token': token});

    if (resp.statusCode == 200) {
      LoginResponse loginResponse = loginResponseFromJson(resp.body);
      this.user = loginResponse.user;

      await _savedToken(loginResponse.token);
      return true;
    } else {
      return false;
    }
  }

  static Future<String> getToken() async {
    final _storage = FlutterSecureStorage();
    return await _storage.read(key: 'token');
  }

  static Future<void> deleteToken() async {
    final _storage = FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future _savedToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }
}
