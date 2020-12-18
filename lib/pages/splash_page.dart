import 'package:chat_flutter/models/user.dart';
import 'package:chat_flutter/pages/pages.dart';
import 'package:chat_flutter/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatelessWidget {
  static final String route = 'SplashPage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (_, __) => Center(
          child: Text('Loading...'),
        ),
      ),
    );
  }

  Future checkLoginState(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);

    final isAuth = await authService.isLoginIn();

    if (isAuth) {
      // Navigator.pushReplacementNamed(context, UsersPage.route);
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => UsersPage(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => LoginPage(),
        ),
      );
    }
  }
}
