import 'package:flutter/material.dart';
import 'package:flutter_workshop/base/dependency_provider.dart';
import 'package:flutter_workshop/config/l10n.dart';
import 'package:flutter_workshop/custom/custom_app_bar.dart';
import 'package:flutter_workshop/custom/custom_alert_dialog.dart';
import 'package:flutter_workshop/feature/detail/detail.dart';
import 'package:flutter_workshop/feature/home/home_bloc.dart';
import 'package:flutter_workshop/feature/login/login.dart';
import 'package:flutter_workshop/model/donation/donation.dart';
import 'package:flutter_workshop/model/user/user.dart';
import 'package:flutter_workshop/util/navigation.dart';

class Home extends StatefulWidget {
  static const Key loginButtonKey = Key('home_login_button');

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  HomeBloc _bloc;
  Navigation _navigation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _navigation = Navigation(context);
    _bloc = DependencyProvider.of(context).dependencies.homeBloc;
    _bloc.loadDonations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        actions: _appBarActions(),
        title: L10n.getString(context, 'home_title'),
      ),
      body: _listStreamBuilder(),
    );
  }

  StreamBuilder<List<Donation>> _listStreamBuilder() =>
      StreamBuilder<List<Donation>>(
          stream: _bloc.stream,
          builder:
              (BuildContext context, AsyncSnapshot<List<Donation>> snapshot) {
            Widget widget = Center(child: const CircularProgressIndicator());

            if (snapshot.hasData)
              widget = _listView(snapshot.data);
            else if (snapshot.hasError) {
              widget = Center(child: Text(snapshot.error.toString()));
            }
            return widget;
          });

  ListView _listView(List<Donation> list) {
    return ListView.builder(
        padding: const EdgeInsets.only(top: 8),
        itemCount: list.length,
        itemBuilder: (BuildContext context, int i) {
          final Donation listItem = list[i];
          return _listItem(listItem);
        });
  }

  Widget _listItem(Donation listItem) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      leading: _image(listItem),
      title: _title(listItem),
      subtitle: _subtitle(listItem),
      onTap: () => _navigateToDetail(listItem),
    );
  }

  Text _title(Donation listItem) {
    return Text(
      listItem.title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _subtitle(Donation listItem) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Text(
        listItem.description,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _image(Donation listItem) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: Image.network(
        listItem.images.last.url,
        height: 75,
        width: 75,
        fit: BoxFit.cover,
      ),
    );
  }

  List<Widget> _appBarActions() {
    return <Widget>[
      FutureBuilder<User>(
          future: _bloc.loadCurrentUser(),
          builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
            return snapshot.hasData
                ? _userAvatar(snapshot.data)
                : _loginButton();
          })
    ];
  }

  Widget _userAvatar(User user) {
    Widget child = Text(user.name.substring(0, 1).toUpperCase());
    ImageProvider backgroundImage;

    if (user.avatarUrl != null && user.name.isNotEmpty) {
      child = null;
      backgroundImage = NetworkImage(user.avatarUrl);
    }

    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: CircleAvatar(
          child: child,
          backgroundImage: backgroundImage,
        ),
      ),
      onTap: _showLogoutConfirmationDialog,
    );
  }

  FlatButton _loginButton() {
    return FlatButton(
        key: Home.loginButtonKey,
        onPressed: _navigateToLogin,
        child: Text(
          L10n.getString(context, 'login_title'),
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold),
        ));
  }

  Future _logout() async {
    await _bloc.logout();
    setState(() {});
    return Navigator.of(context).pop();
  }

  Future _navigateToDetail(Donation donation) =>
      _navigation.push(Detail(donation: donation));

  Future _navigateToLogin() => _navigation.push(Login());

  Future _showLogoutConfirmationDialog() => showDialog(
      context: context,
      builder: (BuildContext context) => CustomAlertDialog(
            titleText: L10n.getString(context, 'logout_confirmation_title'),
            hasCancelButton: true,
            confirmationText: L10n.getString(context, 'logout_confirmation'),
            onConfirmed: () => _logout(),
          ));
}
