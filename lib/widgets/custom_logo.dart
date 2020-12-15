import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({@required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 60),
        child: Column(
          children: [
            Container(
              width: 150,
              child: Image.asset('assets/tag-logo.png'),
            ),
            SizedBox(height: 20),
            Text(
              this.title ?? '',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
          ],
        ),
      ),
    );
  }
}
