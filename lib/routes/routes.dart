import 'package:chat_flutter/pages/pages.dart';
import 'package:chat_flutter/pages/splash_page.dart';
import 'package:flutter/material.dart';

final appRouter = <String, Widget Function(BuildContext)>{
  LoginPage.route: (_) => LoginPage(),
  ChatPage.route: (_) => ChatPage(),
  SingUpPage.route: (_) => SingUpPage(),
  UsersPage.route: (_) => UsersPage(),
  SplashPage.route: (_) => SplashPage()
};
