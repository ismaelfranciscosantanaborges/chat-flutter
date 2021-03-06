import 'dart:io';

import 'package:chat_flutter/pages/pages.dart';
import 'package:chat_flutter/services/auth_service.dart';
import 'package:chat_flutter/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SingUpPage extends StatelessWidget {
  static const String route = 'SingUpPage';
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
                const Logo(title: 'Register'),
                _Form(),
                const Labels(title: 'Ingresar una cuenta!', route: 'atras'),
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
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.person_outline,
            placeholder: 'nombre',
            textController: nameCtrl,
          ),
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
            title: 'Registrarte',
            onPressed: () async {
              print(nameCtrl.text);
              print(emailCtrl.text);
              print(passCtrl.text);

              final isOk = await authService.register(nameCtrl.text.trim(),
                  emailCtrl.text.trim(), passCtrl.text.trim());

              if (isOk) {
                Navigator.pop(context);
              } else {
                _customShowDialog(
                    title: 'Error in the register',
                    subTitle: 'dont can saved this register in the database.');
              }
            },
          ),
        ],
      ),
    );
  }

  _customShowDialog({String title, String subTitle}) {
    if (Platform.isIOS) {
      return showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: Text(title),
          content: Text(subTitle),
          actions: [
            CupertinoDialogAction(
              child: Text('Ok'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }

    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(subTitle),
        actions: [
          MaterialButton(
            child: Text('Ok'),
            onPressed: () => Navigator.pop(context),
            textColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}
