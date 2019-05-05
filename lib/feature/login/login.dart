import 'package:flutter/material.dart';
import 'package:flutter_workshop/config/l10n.dart';
import 'package:flutter_workshop/custom/custom_app_bar.dart';
import 'package:flutter_workshop/feature/login/login_bloc.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();
  LoginBloc bloc;

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: L10n.getString(context, 'login_title'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        child: _form(context),
      ),
    );
  }

  Form _form(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          _emailField(context),
          SizedBox(height: 40),
          _passwordField(context),
          SizedBox(height: 60),
          _button(context)
        ],
      ),
    );
  }

  TextFormField _passwordField(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          labelText: L10n.getString(context, 'login_password'),
          suffixIcon: _visibilityToggle()),
      obscureText: !_isPasswordVisible,
      validator: _validatePassword,
    );
  }

  Widget _visibilityToggle() {
    return IconButton(
      icon: _isPasswordVisible
          ? Icon(Icons.visibility)
          : Icon(Icons.visibility_off),
      onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
    );
  }

  TextFormField _emailField(BuildContext context) {
    return TextFormField(
        decoration:
            InputDecoration(labelText: L10n.getString(context, 'login_email')),
        validator: _validateEmail);
  }

  Widget _button(BuildContext context) {
    return ButtonTheme(
      height: 48.0,
      minWidth: double.maxFinite,
      child: FlatButton(
          child: Text(L10n.getString(context, 'login_title')),
          color: Theme.of(context).primaryColor,
          textColor: Colors.white,
          onPressed: () {
            if (_formKey.currentState.validate())
              print('the form is OK');
            else
              print('nah, the form is not valid');
          }),
    );
  }

  String _validateEmail(String input) {
    String message;

    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);

    if (input.trim().isEmpty)
      message = L10n.getString(context, 'validation_message_email_required');
    else if (!regex.hasMatch(input))
      message = L10n.getString(context, 'validation_message_email_invalid');
    return message;
  }

  String _validatePassword(String input) {
    String message;

    if (input.trim().isEmpty)
      message = L10n.getString(context, 'validation_message_password_required');
    else if (input.length < 6)
      message =
          L10n.getString(context, 'validation_message_password_too_short');
    return message;
  }
}
