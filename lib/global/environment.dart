import 'dart:io';

class Environment {
  static String port = '3001';
  static String apiUrl = Platform.isIOS
      ? 'http://localhost:$port/api'
      : 'http://10.0.2.2:$port/api';
  static String urlSocket =
      Platform.isIOS ? 'http://localhost:$port' : 'http://10.0.2.2:$port';
}
