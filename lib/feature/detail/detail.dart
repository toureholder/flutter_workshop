import 'package:flutter/material.dart';
import 'package:flutter_workshop/custom/custom_app_bar.dart';
import 'package:flutter_workshop/model/donation/donation.dart';
import 'package:flutter_workshop/model/user/user.dart';

class Detail extends StatelessWidget {
  static const routeName = '/detail';
  final Donation donation;
  final bool showAppBar;

  const Detail({
    Key key,
    @required this.donation,
    this.showAppBar = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar ? const CustomAppBar() : null,
      body: _Body(donation: donation),
    );
  }
}

class _Body extends StatelessWidget {
  final Donation donation;

  const _Body({Key key, @required this.donation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: ListView(
        children: <Widget>[
          _Carousel(donation: donation),
          _VerticalMargin(),
          _Title(title: donation.title),
          _VerticalMargin(),
          Text(donation.description),
          _VerticalMargin(),
          _Donator(user: donation.user),
        ],
      ),
    );
  }
}

class _Carousel extends StatelessWidget {
  final Donation donation;

  const _Carousel({
    Key key,
    @required this.donation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double size = 300.0;
    return SizedBox(
      height: size,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: donation.images.length,
        itemBuilder: (BuildContext context, int index) {
          final String url = donation.images[index].url;
          return _Image(
            url: url,
            size: size,
          );
        },
      ),
    );
  }
}

class _Image extends StatelessWidget {
  final String url;
  final double size;

  const _Image({
    Key key,
    @required this.url,
    @required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 24.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Image.network(
          url,
          height: size,
          width: size,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String title;

  const _Title({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _Donator extends StatelessWidget {
  final User user;

  const _Donator({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ImageProvider backgroundImage = user.avatarUrl == null
        ? null
        : NetworkImage(
            user.avatarUrl,
          );

    final Widget child = user.avatarUrl == null
        ? Text(
            user.name[0].toUpperCase(),
          )
        : null;

    return Row(
      children: <Widget>[
        CircleAvatar(
          backgroundImage: backgroundImage,
          child: child,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        const SizedBox(width: 16),
        Text(user.name)
      ],
    );
  }
}

class _VerticalMargin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 24);
  }
}

class DetailArguments {
  final Donation donation;

  DetailArguments({this.donation});
}
