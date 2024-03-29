import 'package:flutter/material.dart';
import 'package:flutter_workshop/config/l10n.dart';
import 'package:flutter_workshop/custom/custom_button.dart';

import 'package:flutter_workshop/config/platform_independent_constants.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    Key? key,
    this.onConfirmed,
    this.confirmationText,
    this.cancellationText,
    this.titleText,
    this.contentText,
    this.hasCancelButton = false,
  }) : super(key: key);

  final VoidCallback? onConfirmed;
  final String? confirmationText;
  final String? cancellationText;
  final String? titleText;
  final String? contentText;
  final bool hasCancelButton;

  @override
  Widget build(BuildContext context) {
    final Text? title = titleText == null ? null : Text(titleText!);
    final Text? content = contentText == null ? null : Text(contentText!);

    return AlertDialog(
      title: title,
      content: content,
      actions: <Widget>[
        if (hasCancelButton || cancellationText != null) _cancelButton(context),
        _confirmButton(context)
      ],
    );
  }

  Widget _confirmButton(BuildContext context) => PrimaryTextButton(
        text: confirmationText ?? L10n.getString(context, 'common_ok'),
        onPressed: onConfirmed ?? () => _closeDialog(context),
      );

  Widget _cancelButton(BuildContext context) => PrimaryTextButton(
        key: const Key(logoutDialogCancelButton),
        text: cancellationText ?? L10n.getString(context, 'common_cancel'),
        onPressed: () => _closeDialog(context),
      );

  void _closeDialog(BuildContext context) => Navigator.of(context).pop();
}
