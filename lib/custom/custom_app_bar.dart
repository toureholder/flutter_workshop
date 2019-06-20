import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key key, this.actions, this.title}) : super(key: key);

  final List<Widget> actions;
  final String title;

  @override
  Widget build(BuildContext context) {
    final String computedTitle = title == null ? '' : title;

    return AppBar(
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.grey),
      title: Text(
        computedTitle,
        style: TextStyle(color: Colors.grey[800]),
      ),
      elevation: 0,
      actions: actions,
      bottom: CustomAppBarBottom(),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomAppBarBottom extends StatelessWidget
    implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      height: 1,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(1);
}
