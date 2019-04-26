import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Início'),
        actions: _appBarActions(),
      ),
    );
  }

  List<Widget> _appBarActions() {
    return <Widget>[
      IconButton(icon: Icon(Icons.account_circle), onPressed: () {})
    ];
  }
}
