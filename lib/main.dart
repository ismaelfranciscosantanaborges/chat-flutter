import 'package:chat_flutter/pages/pages.dart';
import 'package:chat_flutter/routes/routes.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      initialRoute: ChatPage.route,
      routes: appRouter,
    );
  }
}
