import 'package:flutter/material.dart';
import 'package:flutter_workshop/model/donation.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Início'),
        actions: _appBarActions(),
      ),
      body: _listView(Donation.fakeList()),
    );
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
        subtitle: _subtitle(listItem));
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
}
