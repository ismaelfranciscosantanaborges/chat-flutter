import 'dart:io';

import 'package:chat_flutter/pages/pages.dart';
import 'package:chat_flutter/services/auth_service.dart';
import 'package:chat_flutter/services/socket_service.dart';
import 'package:chat_flutter/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  static const String route = 'LoginPage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * .9,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Logo(title: 'Messager'),
                _Form(),
                const Labels(title: 'Crea una ahora!', route: SingUpPage.route),
                Text(
                  'Terminos y condiciones de uso',
                  style: TextStyle(color: Colors.black38, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  _Form({Key key}) : super(key: key);

  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.email_outlined,
            placeholder: 'Correo',
            textController: emailCtrl,
            keyboardType: TextInputType.emailAddress,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeholder: 'Contraseña',
            textController: passCtrl,
            isPassword: true,
          ),
          ButtonBlue(
            title: 'Ingresar',
            onPressed: authService.autenticando
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    final resp = await authService.login(
                        emailCtrl.text.trim(), passCtrl.text.trim());

                    if (resp) {
                      socketService.connect();
                      Navigator.pushReplacementNamed(context, UsersPage.route);
                    } else {
                      _showDialog(
                        context,
                        'Error for Authentications',
                        'The email or password is invalidate',
                      );
                    }
                  },
          ),
        ],
      ),
    );
  }

  _showDialog(BuildContext context, String title, String subTitle) {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          content: Text(subTitle),
          title: Text(title),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              child: Text('Ok'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(title),
          content: Text(subTitle),
          actions: [
            MaterialButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Ok'),
              textColor: Colors.blue,
            ),
          ],
        ),
      );
    }
  }
}
