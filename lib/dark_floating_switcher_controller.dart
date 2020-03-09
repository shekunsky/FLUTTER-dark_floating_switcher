import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'dark_floating_switcher_state.dart';

class DarkFloatingSwitcherController extends ChangeNotifier {
  static const int durationDefault = 600; //Default animation duration
  static const double valueStart = 0.0; //Default start value
  static const double valueEnd = 1.0; //Default end value

  final AnimationController controller;
  Animation colorTween;

  DarkFloatingSwitcherState state = DarkFloatingSwitcherState.on;
  DarkFloatingSwitcherState prevState = DarkFloatingSwitcherState.on;

  double get progress => controller.value;

  DarkFloatingSwitcherController({@required TickerProvider vsync, this.state})
      : controller = AnimationController(vsync: vsync) {
    controller.addListener(_onStateUpdate);
    prevState = state;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onStateUpdate() {
    notifyListeners();
  }

  void _startAnimation(double animationTo) {
    controller
      ..duration = const Duration(milliseconds: durationDefault)
      ..animateTo(animationTo);
    notifyListeners();
  }

  void setSwitchOnState() {
    _startAnimation(valueEnd);
    state = DarkFloatingSwitcherState.on;
  }

  void setSwitchOffState() {
    _startAnimation(valueStart);
    state = DarkFloatingSwitcherState.off;
  }
}
