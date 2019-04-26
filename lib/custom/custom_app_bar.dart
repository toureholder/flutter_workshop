import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget> actions;
  final String title;

  const CustomAppBar({Key key, this.actions, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final computedTitle = title == null ? '' : title;

    return AppBar(
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.grey),
      title: Text(computedTitle, style: TextStyle(color: Colors.grey[800]),),
      elevation: 0,
      actions: actions,
      bottom: CustomAppBarBottom(),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class CustomAppBarBottom extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      height: 1,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(1);
}

