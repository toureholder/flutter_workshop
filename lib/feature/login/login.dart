import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_workshop/base/dependency_provider.dart';
import 'package:flutter_workshop/config/l10n.dart';
import 'package:flutter_workshop/custom/custom_alert_dialog.dart';
import 'package:flutter_workshop/custom/custom_app_bar.dart';
import 'package:flutter_workshop/feature/home/home.dart';
import 'package:flutter_workshop/feature/login/login_bloc.dart';
import 'package:flutter_workshop/model/login/login_response.dart';
import 'package:flutter_workshop/util/custom_form_field_validator.dart';
import 'package:flutter_workshop/util/http_event.dart';
import 'package:flutter_workshop/util/navigation.dart';

class Login extends StatefulWidget {
  static const Key submitButtonKey = Key('login_submit_button');
  static const Key emailFieldKey = Key('email_field_button');
  static const Key passwordFieldKey = Key('password_fieldbutton');

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isPasswordVisible = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  LoginBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = DependencyProvider.of(context).dependencies.loginBloc;
    _listenForLoginResponse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: L10n.getString(context, 'login_title'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        child: _form(context),
      ),
    );
  }

  Form _form(BuildContext context) => Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            _emailField(),
            const SizedBox(height: 40),
            _passwordField(),
            const SizedBox(height: 60),
            StreamBuilder<HttpEvent<LoginResponse>>(
                stream: _bloc.stream,
                builder: (BuildContext context,
                    AsyncSnapshot<HttpEvent<LoginResponse>> snapshot) {
                  final bool isLoading =
                      snapshot.hasData && snapshot.data.isLoading;
                  return _button(context, isLoading);
                })
          ],
        ),
      );

  TextFormField _passwordField() => TextFormField(
        key: Login.passwordFieldKey,
        controller: _passwordController,
        decoration: InputDecoration(
            labelText: L10n.getString(context, 'login_password'),
            suffixIcon: _visibilityToggle()),
        obscureText: !_isPasswordVisible,
        validator: (String input) => L10n.getString(
            context, CustomFormFieldValidator.validatePassword(input)),
      );

  Widget _visibilityToggle() => IconButton(
        icon:
            Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
        onPressed: () =>
            setState(() => _isPasswordVisible = !_isPasswordVisible),
      );

  TextFormField _emailField() => TextFormField(
      key: Login.emailFieldKey,
      controller: _emailController,
      decoration:
          InputDecoration(labelText: L10n.getString(context, 'login_email')),
      validator: (String input) => L10n.getString(
          context, CustomFormFieldValidator.validateEmail(input)));

  Widget _button(BuildContext context, bool isLoading) {
    final Widget child = isLoading
        ? _circularProgressIndicator()
        : Text(L10n.getString(context, 'login_title'));

    return ButtonTheme(
      height: 48.0,
      minWidth: double.maxFinite,
      child: FlatButton(
          key: Login.submitButtonKey,
          child: child,
          color: Theme.of(context).primaryColor,
          textColor: Colors.white,
          onPressed: () {
            if (_formKey.currentState.validate())
              _sendLoginRequest();
          }),
    );
  }

  Widget _circularProgressIndicator() => const SizedBox(
        height: 26.0,
        width: 26.0,
        child: CircularProgressIndicator(
            strokeWidth: 3.0,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
      );

  Future<void> _sendLoginRequest() => _bloc.login(
      email: _emailController.text, password: _passwordController.text);

  void _listenForLoginResponse() {
    _bloc.stream.listen((HttpEvent<LoginResponse> event) {
      if (event.isLoading)
        return;
      else if (event.statusCode == HttpStatus.ok)
        _onLoginSuccess();
      else
        _onLoginFailure(event.statusCode);
    });
  }

  Future<void> _onLoginSuccess() =>
      Navigation(context).push(Home(), clearStack: true);

  Future<void> _onLoginFailure(int statusCode) {
    final Map<int, String> map = <int, String>{
      HttpStatus.unprocessableEntity: 'login_error_bad_credentials'
    };

    final String messageKey = map[statusCode] ?? 'common_error_server_generic';

    return showDialog(
        context: context,
        builder: (BuildContext context) => CustomAlertDialog(
              contentText: L10n.getString(context, messageKey),
            ));
  }
}
