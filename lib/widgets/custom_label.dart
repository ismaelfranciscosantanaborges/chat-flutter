import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  const Labels({@required this.route, @required this.title});
  final String route;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            'No tienes una cuenta?',
            style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 15,
                color: Colors.black54),
          ),
          SizedBox(height: 10),
          GestureDetector(
            child: Text(
              this.title ?? '',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.blue[600],
              ),
            ),
            onTap: () => route == 'atras'
                ? Navigator.pop(context)
                : Navigator.pushNamed(context, this.route),
          )
        ],
      ),
    );
  }
}
