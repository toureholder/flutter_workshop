import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Início'),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.account_circle), onPressed: () {})
          ],
        ),
      ),
    );
  }
}
