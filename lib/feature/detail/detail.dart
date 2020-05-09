import 'package:flutter/material.dart';
import 'package:flutter_workshop/custom/custom_app_bar.dart';
import 'package:flutter_workshop/model/donation/donation.dart';
import 'package:flutter_workshop/model/user/user.dart';

class Detail extends StatelessWidget {
  static const routeName = '/detail';
  final Donation donation;

  const Detail({Key key, this.donation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: _body(),
    );
  }

  Widget _body() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: ListView(
        children: <Widget>[
          _carousel(),
          _verticalMargin(),
          _title(),
          _verticalMargin(),
          _description(),
          _verticalMargin(),
          _user(donation.user)
        ],
      ),
    );
  }

  Row _user(User user) {
    final ImageProvider backgroundImage =
        user.avatarUrl == null ? null : NetworkImage(user.avatarUrl);
    final Widget child =
        user.avatarUrl == null ? Text(user.name[0].toUpperCase()) : null;

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

  SizedBox _verticalMargin() => const SizedBox(height: 24);

  Text _description() => Text(donation.description);

  Text _title() => Text(
        donation.title,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
      );

  Widget _carousel() {
    const double size = 300.0;
    return SizedBox(
      height: size,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: donation.images.length,
          itemBuilder: (BuildContext context, int index) {
            final String url = donation.images[index].url;
            return _image(url, size);
          }),
    );
  }

  Widget _image(String url, double size) {
    return Padding(
      padding: const EdgeInsets.only(right: 24.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Image.network(url, height: size, width: size, fit: BoxFit.cover),
      ),
    );
  }
}

class DetailArguments {
  final Donation donation;

  DetailArguments({this.donation});
}
