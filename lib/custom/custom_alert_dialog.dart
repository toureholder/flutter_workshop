import 'package:flutter/material.dart';
import 'package:flutter_workshop/config/l10n.dart';

class CustomAlertDialog extends StatelessWidget {
  final VoidCallback onConfirmed;
  final String confirmationText;
  final String cancellationText;
  final String titleText;
  final String contentText;
  final bool hasCancelButton;

  const CustomAlertDialog(
      {Key key,
      this.onConfirmed,
      this.confirmationText,
      this.cancellationText,
      this.titleText,
      this.contentText,
      this.hasCancelButton = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = titleText == null ? null : Text(titleText);
    final content = contentText == null ? null : Text(contentText);

    return AlertDialog(
      title: title,
      content: content,
      actions: <Widget>[
        if (hasCancelButton || cancellationText != null) _cancelButton(context),
        FlatButton(
          child: Text(confirmationText),
          onPressed: onConfirmed ?? () => _closeDialog(context),
        )
      ],
    );
  }

  Widget _cancelButton(context) => FlatButton(
        child: Text(
          cancellationText ?? L10n.getString(context, 'common_cancel'),
        ),
        onPressed: () => _closeDialog(context),
      );

  _closeDialog(context) => Navigator.of(context).pop();
}
