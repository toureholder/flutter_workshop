import 'package:flutter/material.dart';
import 'package:flutter_workshop/config/l10n.dart';
import 'package:flutter_workshop/config/platform_independent_constants.dart';
import 'package:flutter_workshop/custom/adaptive_view.dart';
import 'package:flutter_workshop/custom/custom_alert_dialog.dart';
import 'package:flutter_workshop/custom/custom_app_bar.dart';
import 'package:flutter_workshop/custom/custom_button.dart';
import 'package:flutter_workshop/feature/detail/detail.dart';
import 'package:flutter_workshop/feature/home/home_bloc.dart';
import 'package:flutter_workshop/feature/login/login.dart';
import 'package:flutter_workshop/model/donation/donation.dart';
import 'package:flutter_workshop/model/donation/donation_image.dart';
import 'package:flutter_workshop/model/user/user.dart';
import 'package:flutter_workshop/util/navigation.dart';

class Home extends StatefulWidget {
  static const Key loginButtonKey = Key(homeLoginButtonValueKey);
  static const Key largeScreenCTAKey = Key(homeLargeScreenCTAKey);
  static const routeName = '/home';

  final HomeBloc bloc;

  const Home({Key key, this.bloc}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Navigation _navigation;

  @override
  void initState() {
    super.initState();
    _navigation = Navigation(context);
    widget.bloc.loadDonations();
  }

  @override
  Widget build(BuildContext context) {
    final donationListStream = widget.bloc.stream;

    return Scaffold(
      appBar: CustomAppBar(
        actions: _buildAppBarActions(),
        title: L10n.getString(context, 'home_title'),
      ),
      body: donationListStream == null
          ? null
          : _DonationListStreamBuilder(
              onTapListItem: _navigateToDetail,
              stream: donationListStream,
            ),
    );
  }

  List<Widget> _buildAppBarActions() {
    return <Widget>[
      FutureBuilder<User>(
        future: widget.bloc.loadCurrentUser(),
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          return snapshot.hasData
              ? _UserAvatar(
                  user: snapshot.data,
                  onTap: _showLogoutConfirmationDialog,
                )
              : _LoginButton(
                  onPressed: _navigateToLogin,
                );
        },
      )
    ];
  }

  Future _logout() async {
    await widget.bloc.logout();
    setState(() {});
    return Navigator.of(context).pop();
  }

  Future _navigateToDetail(Donation donation) => _navigation.pushNamed(
        Detail.routeName,
        arguments: DetailArguments(donation: donation),
      );

  Future _navigateToLogin() => _navigation.pushNamed(
        Login.routeName,
      );

  Future _showLogoutConfirmationDialog() => showDialog(
        context: context,
        builder: (BuildContext context) => CustomAlertDialog(
          titleText: L10n.getString(context, 'logout_confirmation_title'),
          hasCancelButton: true,
          confirmationText: L10n.getString(context, 'logout_confirmation'),
          onConfirmed: () => _logout(),
        ),
      );
}

class _DonationListStreamBuilder extends StatelessWidget {
  final Stream<List<Donation>> stream;
  final Function(Donation) onTapListItem;

  const _DonationListStreamBuilder({
    Key key,
    @required this.stream,
    @required this.onTapListItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Donation>>(
      stream: stream,
      builder: (
        BuildContext context,
        AsyncSnapshot<List<Donation>> snapshot,
      ) {
        if (snapshot.hasData) {
          return AdaptiveView(
            smallView: _ListView(
              list: snapshot.data,
              onTapItem: onTapListItem,
            ),
            largeView: _LargeScreenView(
              list: snapshot.data,
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              snapshot.error.toString(),
            ),
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class _LargeScreenView extends StatefulWidget {
  final List<Donation> list;

  const _LargeScreenView({
    Key key,
    @required this.list,
  }) : super(key: key);

  @override
  __LargeScreenViewState createState() => __LargeScreenViewState();
}

class __LargeScreenViewState extends State<_LargeScreenView> {
  Donation _selectedDonation;

  @override
  Widget build(BuildContext context) {
    final detailFragment = _selectedDonation == null
        ? const _LargeScreenCTA()
        : Detail(
            donation: _selectedDonation,
            showAppBar: false,
          );

    return Row(
      children: [
        Expanded(
          child: _ListView(
            list: widget.list,
            onTapItem: _selectDonation,
            selectedDonationId: _selectedDonation?.id,
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: Colors.grey[300],
                  width: 1.0,
                ),
              ),
            ),
            child: detailFragment,
          ),
        )
      ],
    );
  }

  void _selectDonation(Donation donation) {
    setState(() {
      _selectedDonation = donation;
    });
  }
}

class _LargeScreenCTA extends StatelessWidget {
  const _LargeScreenCTA({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      key: Home.largeScreenCTAKey,
      child: Text(
        L10n.getString(
          context,
          'home_large_screen_call_to_action',
        ),
      ),
    );
  }
}

class _ListView extends StatelessWidget {
  final List<Donation> list;
  final Function(Donation) onTapItem;
  final int selectedDonationId;

  const _ListView({
    Key key,
    @required this.list,
    @required this.onTapItem,
    this.selectedDonationId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      isAlwaysShown: true,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8),
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          final Donation listItem = list[index];

          final color = listItem.id == selectedDonationId
              ? Theme.of(context).primaryColor.withOpacity(0.25)
              : Colors.transparent;

          return Container(
            color: color,
            child: _ListItemTile(
              index: index,
              donation: listItem,
              onTap: () {
                onTapItem.call(listItem);
              },
            ),
          );
        },
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  final User user;
  final GestureTapCallback onTap;

  const _UserAvatar({
    Key key,
    @required this.user,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      onTap: onTap,
    );
  }
}

class _ListItemTile extends StatelessWidget {
  final int index;
  final Donation donation;
  final GestureTapCallback onTap;

  const _ListItemTile({
    Key key,
    this.index,
    @required this.donation,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: Key('$homeListItemValueKey$index'),
      contentPadding: const EdgeInsets.all(16),
      leading: _DonationImage(images: donation.images),
      title: _DonationTitle(text: donation.title),
      subtitle: _DonationSubtitle(text: donation.description),
      onTap: onTap,
    );
  }
}

class _DonationImage extends StatelessWidget {
  final List<DonationImage> images;

  const _DonationImage({Key key, @required this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: Image.network(
        images.first.url,
        height: 75,
        width: 75,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _DonationTitle extends StatelessWidget {
  final String text;

  const _DonationTitle({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _DonationSubtitle extends StatelessWidget {
  final String text;

  const _DonationSubtitle({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Text(
        text,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _LoginButton({Key key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PrimaryTextButton(
      key: Home.loginButtonKey,
      onPressed: onPressed,
      text: L10n.getString(context, 'login_title'),
    );
  }
}
