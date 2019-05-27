import 'package:flutter/material.dart';
import 'package:flutter_workshop/base/dependency_provider.dart';
import 'package:flutter_workshop/config/l10n.dart';
import 'package:flutter_workshop/custom/custom_app_bar.dart';
import 'package:flutter_workshop/feature/detail/detail.dart';
import 'package:flutter_workshop/feature/home/home_bloc.dart';
import 'package:flutter_workshop/feature/login/login.dart';
import 'package:flutter_workshop/model/donation/donation.dart';
import 'package:flutter_workshop/util/navigation.dart';

class Home extends StatefulWidget {
  static const loginButtonKey = Key('home_login_button');

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  HomeBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
      body: _listFutureBuilder(),
    );
  }

  StreamBuilder<List<Donation>> _listFutureBuilder() {
    return StreamBuilder(
        stream: _bloc.stream,
        builder:
            (BuildContext context, AsyncSnapshot<List<Donation>> snapshot) {
          Widget widget = Center(child: CircularProgressIndicator());

          if (snapshot.hasData)
            widget = _listView(snapshot.data);
          else if (snapshot.hasError)
            widget = Center(child: Text(snapshot.error.toString()));

          return widget;
        });
  }

  ListView _listView(List<Donation> list) {
    return ListView.builder(
        padding: EdgeInsets.only(top: 8),
        itemCount: list.length,
        itemBuilder: (context, i) {
          final Donation listItem = list[i];
          return _listItem(listItem);
        });
  }

  Widget _listItem(Donation listItem) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
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
      FlatButton(
          key: Home.loginButtonKey,
          onPressed: _navigateToLogin,
          child: Text(
            'Entrar',
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold),
          ))
    ];
  }

  _navigateToDetail(Donation donation) =>
      Navigation(context).push(Detail(donation: donation));

  _navigateToLogin() => Navigation(context).push(Login());
}
