import 'package:flutter/material.dart';
import 'package:flutter_workshop/config/l10n.dart';
import 'package:flutter_workshop/custom/custom_app_bar.dart';
import 'package:flutter_workshop/feature/detail/detail.dart';
import 'package:flutter_workshop/feature/home/home_bloc.dart';
import 'package:flutter_workshop/model/donation/donation.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  HomeBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = HomeBloc();
    bloc.loadDonations();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        actions: _appBarActions(),
        title: L10n.getString(context, 'home_title'),
      ),
      body: _listFutureBuilder(),
    );
  }

  StreamBuilder<List<Donation>> _listFutureBuilder() {
    return StreamBuilder(
        stream: bloc.controller.stream,
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
      onTap: _navigateToDetail,
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
        listItem.images[0].url,
        height: 75,
        width: 75,
        fit: BoxFit.cover,
      ),
    );
  }

  List<Widget> _appBarActions() {
    return <Widget>[
      IconButton(icon: Icon(Icons.account_circle), onPressed: () {})
    ];
  }

  _navigateToDetail() {
    final page = Detail();
    final route = MaterialPageRoute(builder: (context) => page);
    Navigator.push(context, route);
  }
}
