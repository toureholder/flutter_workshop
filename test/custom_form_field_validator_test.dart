import 'package:flutter_workshop/util/custom_form_field_validator.dart';
import 'package:test/test.dart';

void main() {
  test('empty email returns error string', () {
    final result = CustomFormFieldValidator.validateEmail('');
    expect(result, 'validation_message_email_required');
  });

  test('invalid email returns error string', () {
    final result = CustomFormFieldValidator.validateEmail('invalid email');
    expect(result, 'validation_message_email_invalid');
  });

  test('empty password returns error string', () {
    final result = CustomFormFieldValidator.validatePassword('');
    expect(result, 'validation_message_password_required');
  });

  test('short password returns error string', () {
    final result = CustomFormFieldValidator.validatePassword('12345');
    expect(result, 'validation_message_password_too_short');
  });
}