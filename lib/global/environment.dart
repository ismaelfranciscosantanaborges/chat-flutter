import 'dart:io';

class Environment {
  static String apiUrl =
      Platform.isIOS ? 'http://localhost:3000/api' : 'http://10.0.2.2:3000/api';
  static String urlSocket =
      Platform.isIOS ? 'http://localhost:3000' : 'http://10.0.2.2:3000';
}
