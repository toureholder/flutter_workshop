import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_workshop/config/l10n.dart';
import 'package:flutter_workshop/config/platform_independent_constants.dart';
import 'package:flutter_workshop/custom/adaptive_view.dart';
import 'package:flutter_workshop/custom/custom_alert_dialog.dart';
import 'package:flutter_workshop/custom/custom_app_bar.dart';
import 'package:flutter_workshop/custom/custom_button.dart';
import 'package:flutter_workshop/feature/home/home.dart';
import 'package:flutter_workshop/feature/login/login_bloc.dart';
import 'package:flutter_workshop/model/login/login_response.dart';
import 'package:flutter_workshop/util/custom_form_field_validator.dart';
import 'package:flutter_workshop/util/http_event.dart';
import 'package:flutter_workshop/util/navigation.dart';

class Login extends StatefulWidget {
  static const routeName = '/login';
  static const Key submitButtonKey = Key(loginSubmitButtonValueKey);
  static const Key emailFieldKey = Key(loginEmailFieldValueKey);
  static const Key passwordFieldKey = Key(loginPasswordFieldValueKey);
  static const Key passwordVisibilityToggledKey =
      Key(loginPasswordVisibilityToggleValueKey);

  final LoginBloc bloc;

  const Login({Key key, this.bloc}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
    _listenForLoginResponse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: L10n.getString(context, 'login_title'),
      ),
      body: AdaptiveView(
        smallView: SmallScreenView(bloc: widget.bloc),
        mediumView: LargeScreenView(
          bloc: widget.bloc,
          horizontalPadding: 100,
          formFlexFactor: 2,
          headlineStyle: Theme.of(context).textTheme.headline5,
        ),
        largeView: LargeScreenView(bloc: widget.bloc),
      ),
    );
  }

  void _listenForLoginResponse() {
    widget.bloc.stream.listen((HttpEvent<LoginResponse> event) {
      if (event.isLoading) {
        return;
      }

      if (event.statusCode == HttpStatus.ok) {
        _onLoginSuccess();
        return;
      }

      _onLoginFailure(event.statusCode);
    });
  }

  Future<void> _onLoginSuccess() {
    return Navigation(context).pushNamed(
      Home.routeName,
      clearStack: true,
    );
  }

  Future<void> _onLoginFailure(int statusCode) {
    final Map<int, String> map = <int, String>{
      HttpStatus.badRequest: 'login_error_bad_credentials'
    };

    final String messageKey = map[statusCode] ?? 'common_error_server_generic';

    return showDialog(
      context: context,
      builder: (BuildContext context) => CustomAlertDialog(
        contentText: L10n.getString(context, messageKey),
      ),
    );
  }
}

class SmallScreenView extends StatelessWidget {
  const SmallScreenView({
    Key key,
    @required this.bloc,
    this.horizontalPadding,
  }) : super(key: key);

  final LoginBloc bloc;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding ?? 20.0,
        vertical: 40.0,
      ),
      child: LoginForm(
        bloc: bloc,
      ),
    );
  }
}

class LargeScreenView extends StatelessWidget {
  const LargeScreenView({
    Key key,
    @required this.bloc,
    this.horizontalPadding,
    this.formFlexFactor,
    this.headlineStyle,
  }) : super(key: key);

  final LoginBloc bloc;
  final double horizontalPadding;
  final int formFlexFactor;
  final TextStyle headlineStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final texStyle = headlineStyle ?? theme.textTheme.headline4;

    return Row(
      children: [
        Expanded(
          flex: formFlexFactor ?? 1,
          child: SmallScreenView(
            bloc: bloc,
            horizontalPadding: horizontalPadding ?? 120.0,
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                theme.accentColor,
                theme.primaryColor,
              ],
            )),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    L10n.getString(context, 'login_welcome'),
                    style: texStyle.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class LoginForm extends StatefulWidget {
  final LoginBloc bloc;

  const LoginForm({Key key, @required this.bloc}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          _EmailField(
            controller: _emailController,
          ),
          const _VerticalSpacer(),
          _PasswordField(
            controller: _passwordController,
            isPasswordVisible: _isPasswordVisible,
            onVisibilityTogglePressed: () {
              setState(() => _isPasswordVisible = !_isPasswordVisible);
            },
          ),
          const _VerticalSpacer(),
          StreamBuilder<HttpEvent<LoginResponse>>(
            stream: widget.bloc.stream,
            builder: (
              BuildContext context,
              AsyncSnapshot<HttpEvent<LoginResponse>> snapshot,
            ) {
              final bool isLoading =
                  snapshot.hasData && snapshot.data.isLoading;
              return _SubmitButton(
                formState: _formKey.currentState,
                isLoading: isLoading,
                onPressed: _sendLoginRequest,
              );
            },
          ),
          const _VerticalSpacer(),
          const _CredentialsHint(),
        ],
      ),
    );
  }

  Future<void> _sendLoginRequest() => widget.bloc.login(
        email: _emailController.text,
        password: _passwordController.text,
      );
}

class _EmailField extends StatelessWidget {
  final TextEditingController controller;

  const _EmailField({
    Key key,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: Login.emailFieldKey,
      controller: controller,
      decoration: InputDecoration(
        labelText: L10n.getString(
          context,
          'login_email',
        ),
      ),
      validator: (String input) => L10n.getString(
        context,
        validateEmail(input),
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final bool isPasswordVisible;
  final VoidCallback onVisibilityTogglePressed;

  const _PasswordField({
    Key key,
    @required this.controller,
    @required this.isPasswordVisible,
    @required this.onVisibilityTogglePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: Login.passwordFieldKey,
      controller: controller,
      decoration: InputDecoration(
        labelText: L10n.getString(
          context,
          'login_password',
        ),
        suffixIcon: _PasswordVisibilityToggle(
          isPasswordVisible: isPasswordVisible,
          onPressed: onVisibilityTogglePressed,
        ),
      ),
      obscureText: !isPasswordVisible,
      validator: (String input) => L10n.getString(
        context,
        validatePassword(input),
      ),
    );
  }
}

class _PasswordVisibilityToggle extends StatelessWidget {
  final bool isPasswordVisible;
  final VoidCallback onPressed;

  const _PasswordVisibilityToggle({
    Key key,
    @required this.isPasswordVisible,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData iconData = Icons.visibility_off;
    String iconValueKey = loginPasswordVisibilityToggleObscureValueKey;
    String semanticsLabel = 'login_semantics_password_reveal';

    if (isPasswordVisible) {
      iconData = Icons.visibility;
      iconValueKey = loginPasswordVisibilityToggleVisibleValueKey;
      semanticsLabel = 'login_semantics_password_hide';
    }

    return Semantics(
      label: L10n.getString(
        context,
        semanticsLabel,
      ),
      value: L10n.getString(
        context,
        'login_semantics_password_visibility_toggle',
      ),
      child: IconButton(
        key: const Key(loginPasswordVisibilityToggleValueKey),
        icon: Icon(
          iconData,
          key: Key(iconValueKey),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final bool isLoading;
  final FormState formState;
  final VoidCallback onPressed;

  const _SubmitButton({
    Key key,
    @required this.isLoading,
    @required this.formState,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Widget child = isLoading
        ? const _ButtonProgressIndicator()
        : Text(L10n.getString(context, 'login_title'));

    return PrimaryContainedButton(
      key: Login.submitButtonKey,
      child: child,
      onPressed: () {
        if (formState.validate()) {
          onPressed.call();
        }
      },
    );
  }
}

class _ButtonProgressIndicator extends StatelessWidget {
  const _ButtonProgressIndicator();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 26.0,
      width: 26.0,
      child: CircularProgressIndicator(
        strokeWidth: 3.0,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    );
  }
}

class _CredentialsHint extends StatelessWidget {
  const _CredentialsHint();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          L10n.getString(
            context,
            'login_try_these_creds',
          ),
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}

class _VerticalSpacer extends StatelessWidget {
  const _VerticalSpacer();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 40);
  }
}
