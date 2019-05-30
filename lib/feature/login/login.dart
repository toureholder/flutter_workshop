import 'package:flutter/material.dart';
import 'package:flutter_workshop/base/dependency_provider.dart';
import 'package:flutter_workshop/config/l10n.dart';
import 'package:flutter_workshop/custom/custom_app_bar.dart';
import 'package:flutter_workshop/feature/home/home.dart';
import 'package:flutter_workshop/feature/login/login_bloc.dart';
import 'package:flutter_workshop/model/login/login_response.dart';
import 'package:flutter_workshop/util/custom_form_field_validator.dart';
import 'package:flutter_workshop/util/http_event.dart';
import 'package:flutter_workshop/util/navigation.dart';

class Login extends StatefulWidget {
  static const submitButtonKey = Key('login_submit_button');
  static const emailFieldKey = Key('email_field_button');
  static const passwordFieldKey = Key('password_fieldbutton');

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  LoginBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = DependencyProvider.of(context).dependencies.loginBloc;
    _listenForLoginSuccess();
  }

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
          _emailField(),
          SizedBox(height: 40),
          _passwordField(),
          SizedBox(height: 60),
          StreamBuilder<HttpEvent<LoginResponse>>(
              stream: _bloc.stream,
              builder:
                  (context, AsyncSnapshot<HttpEvent<LoginResponse>> snapshot) {
                bool isLoading = snapshot.hasData && snapshot.data.isLoading;
                return _button(context, isLoading);
              })
        ],
      ),
    );
  }

  TextFormField _passwordField() {
    return TextFormField(
      key: Login.passwordFieldKey,
      controller: _passwordController,
      decoration: InputDecoration(
          labelText: L10n.getString(context, 'login_password'),
          suffixIcon: _visibilityToggle()),
      obscureText: !_isPasswordVisible,
      validator: (input) => L10n.getString(
          context, CustomFormFieldValidator.validatePassword(input)),
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

  TextFormField _emailField() {
    return TextFormField(
        key: Login.emailFieldKey,
        controller: _emailController,
        decoration:
            InputDecoration(labelText: L10n.getString(context, 'login_email')),
        validator: (input) => L10n.getString(
            context, CustomFormFieldValidator.validateEmail(input)));
  }

  Widget _button(BuildContext context, bool isLoading) {
    final child = isLoading
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
            if (_formKey.currentState.validate()) _sendLoginRequest();
          }),
    );
  }

  Widget _circularProgressIndicator() {
    return SizedBox(
      height: 26.0,
      width: 26.0,
      child: CircularProgressIndicator(
          strokeWidth: 3.0,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
    );
  }

  _sendLoginRequest() {
    _bloc.login(
        email: _emailController.text, password: _passwordController.text);
  }

  _listenForLoginSuccess() {
    _bloc.stream.listen((HttpEvent<LoginResponse> event) {
      if (event.isDone) _onLoginSuccess();
    });
  }

  _onLoginSuccess() {
    Navigation(context).push(Home(), clearStack: true);
  }
}
