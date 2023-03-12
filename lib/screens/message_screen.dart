import 'package:flutter/material.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Message Screen', style: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold
        )),
      ),
    );
  }
}
