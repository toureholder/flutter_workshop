import 'package:flutter/material.dart';
import 'package:flutter_workshop/config/platform_independent_constants.dart';
import 'package:flutter_workshop/values/custom_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  static const Key githubButtonKey = Key(appBarGithubButtonValueKey);
  static const _GITHUB_URL = 'https://github.com/toureholder/flutter_workshop';

  const CustomAppBar({
    Key? key,
    this.actions,
    this.title,
  }) : super(key: key);

  final List<Widget>? actions;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final String computedTitle = title == null ? '' : title!;
    final finalActions = <Widget>[
      IconButton(
        key: githubButtonKey,
        onPressed: _launchURL,
        icon: const Icon(CustomIcons.github),
        color: Theme.of(context).primaryColor,
      )
    ];

    if (actions != null) {
      finalActions.addAll(actions!);
    }

    return AppBar(
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.grey),
      title: Text(
        computedTitle,
        style: TextStyle(color: Colors.grey[800]),
      ),
      elevation: 0,
      actions: finalActions,
      bottom: CustomAppBarBottom(),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  void _launchURL() async => await launch(_GITHUB_URL);
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
