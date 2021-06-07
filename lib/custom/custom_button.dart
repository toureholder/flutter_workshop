import 'package:flutter/material.dart';

class PrimaryContainedButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;

  const PrimaryContainedButton({
    Key? key,
    required this.child,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: Theme.of(context).primaryColor,
      primary: Colors.white,
      minimumSize: const Size(double.maxFinite, 48),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2.0)),
      ),
    );

    return TextButton(
      style: flatButtonStyle,
      onPressed: onPressed,
      child: child,
    );
  }
}

class PrimaryTextButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onPressed;

  const PrimaryTextButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      primary: Theme.of(context).primaryColor,
      minimumSize: const Size(88, 36),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2.0)),
      ),
    );

    return TextButton(
      style: flatButtonStyle,
      onPressed: onPressed,
      child: Text(
        text!,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
