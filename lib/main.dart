import 'package:chat_flutter/pages/pages.dart';
import 'package:chat_flutter/pages/splash_page.dart';
import 'package:chat_flutter/routes/routes.dart';
import 'package:chat_flutter/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthService())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat App',
        initialRoute: SplashPage.route,
        routes: appRouter,
      ),
    );
  }
}
