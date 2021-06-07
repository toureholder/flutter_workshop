String? validateEmail(String input) {
  const Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  final RegExp regex = RegExp(pattern as String);

  if (input.trim().isEmpty) {
    return 'validation_message_email_required';
  }

  if (!regex.hasMatch(input)) {
    return 'validation_message_email_invalid';
  }

  return null;
}

String? validatePassword(String input) {
  if (input.trim().isEmpty) {
    return 'validation_message_password_required';
  }

  if (input.length < 6) {
    return 'validation_message_password_too_short';
  }

  return null;
}
