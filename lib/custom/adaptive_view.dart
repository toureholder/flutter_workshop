import 'package:flutter/material.dart';

const double MEDUIM_SCREEN_MIN_WIDTH = 720;
const double LARGE_SCREEN_MIN_WIDTH = 1200;

class AdaptiveView extends StatelessWidget {
  final Widget smallView;
  final Widget mediumView;
  final Widget largeView;
  final FormFactor forcedFormFactor;

  const AdaptiveView({
    Key key,
    this.smallView,
    this.mediumView,
    this.largeView,
    this.forcedFormFactor,
  })  : assert(!(smallView == null && mediumView == null && largeView == null)),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final formFactor =
        forcedFormFactor ?? _getFormFactor(MediaQuery.of(context).size.width);

    return _getView(formFactor);
  }

  FormFactor _getFormFactor(double width) {
    if (width > LARGE_SCREEN_MIN_WIDTH) {
      return FormFactor.large;
    }

    if (width > MEDUIM_SCREEN_MIN_WIDTH) {
      return FormFactor.medium;
    }

    return FormFactor.small;
  }

  Widget _getView(FormFactor formFactor) {
    switch (formFactor) {
      case FormFactor.large:
        return largeView ?? mediumView ?? smallView;
        break;
      case FormFactor.medium:
        return mediumView ?? largeView ?? smallView;
        break;
      default:
        return smallView ?? mediumView ?? largeView;
    }
  }
}

enum FormFactor { small, medium, large }
