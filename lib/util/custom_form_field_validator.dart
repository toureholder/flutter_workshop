class CustomFormFieldValidator {
  static String validateEmail(String input) {
    String message;

    const Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    final RegExp regex = RegExp(pattern);

    if (input.trim().isEmpty)
      message = 'validation_message_email_required';
    else if (!regex.hasMatch(input)) {
      message = 'validation_message_email_invalid';
    }
    return message;
  }

  static String validatePassword(String input) {
    String message;

    if (input.trim().isEmpty)
      message = 'validation_message_password_required';
    else if (input.length < 6) {
      message = 'validation_message_password_too_short';
    }
    return message;
  }
}
