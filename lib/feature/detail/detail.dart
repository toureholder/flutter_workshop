import 'package:flutter/material.dart';
import 'package:flutter_workshop/custom/custom_app_bar.dart';
import 'package:flutter_workshop/model/donation/donation.dart';
import 'package:flutter_workshop/model/user/user.dart';

class Detail extends StatelessWidget {
  final Donation donation;

  const Detail({Key key, this.donation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: _body(),
    );
  }

  Widget _body() {
    return Container(
      padding: EdgeInsets.all(20),
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
    return Row(
      children: <Widget>[
        CircleAvatar(
          backgroundImage: NetworkImage(user.avatarUrl),
          backgroundColor: Colors.grey,
        ),
        SizedBox(
          width: 16,
        ),
        Text(user.name)
      ],
    );
  }

  SizedBox _verticalMargin() {
    return SizedBox(
      height: 24,
    );
  }

  Text _description() => Text(donation.description);

  Text _title() => Text(
        donation.title,
        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
      );

  Widget _carousel() {
    final size = 300.0;
    return SizedBox(
      height: size,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: donation.images.length,
          itemBuilder: (context, index) {
            String url = donation.images[index].url;
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
