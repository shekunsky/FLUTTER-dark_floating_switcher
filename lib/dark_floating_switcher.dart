library dark_floating_switcher;

import 'package:flutter/material.dart';
import 'dark_floating_switcher_controller.dart';
import 'dark_floating_switcher_state.dart';
import 'dark_floating_switcher_painter.dart';

typedef ValueChanged = Function(DarkFloatingSwitcherState state);

class DarkFloatingSwitcher extends StatefulWidget {
  static const double widthDefault = 60; //Default width for switcher
  static const double heightDefault = 30; //Default height for switcher
  static const DarkFloatingSwitcherState stateDefault =
      DarkFloatingSwitcherState.off; //Default state for switcher
  static const double heightToRadiusRatioDefault = 0.75;

  static const Color pureColorDefault = Color.fromARGB(255, 224, 224, 224);
  static const Color darkColorDefault = Color.fromARGB(255, 44, 44, 44);

  final double width;
  final double height;
  final double heightToRadiusRatio;
  final DarkFloatingSwitcherState state;
  final Color pureColor;
  final Color darkColor;
  final ValueChanged valueChanged;

  DarkFloatingSwitcher(
      {@required this.valueChanged,
      this.state = stateDefault,
      this.width = widthDefault,
      this.height = heightDefault,
      this.pureColor = pureColorDefault,
      this.darkColor = darkColorDefault,
      this.heightToRadiusRatio = heightToRadiusRatioDefault}) {
    assert(_colorIsValid(pureColor));
    assert(_colorIsValid(darkColor));
    assert(_heightToRadiusIsValid(heightToRadiusRatio));
    assert(_sizeIsValid(width, height));
  }

  @override
  _DarkFloatingSwitcherState createState() => _DarkFloatingSwitcherState();

  bool _sizeIsValid(double width, double height) {
    assert(width != null, 'Width argument was null.');
    assert(height != null, 'Height argument was null.');
    assert(width > height,
        'Width argument should be greater than height argument.');
    return true;
  }

  bool _colorIsValid(Color color) {
    assert(color != null, 'Color argument was null.');
    return true;
  }

  bool _heightToRadiusIsValid(double heightToRadius) {
    assert(heightToRadius != null, 'Height to radius argument was null.');
    assert(heightToRadius > 0 && heightToRadius < 1,
        'Height to radius argument Must be in the range 0 to 1');
    return true;
  }
}

class _DarkFloatingSwitcherState extends State<DarkFloatingSwitcher>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  DarkFloatingSwitcherController _slideController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _slideController =
        DarkFloatingSwitcherController(vsync: this, state: widget.state)
          ..addListener(() => setState(() {}));
    _setSwitcherState();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: GestureDetector(
        onTap: () {
          _updateSwitcherState();
          widget.valueChanged(_slideController.state);
        },
        onHorizontalDragUpdate: _updateStateOnHorizontalDrag,
        child: Container(
          height: widget.height,
          width: widget.width,
          child: CustomPaint(
            painter: DarkFloatingSwitcherPainter(
                _slideController.progress, _slideController.state,
                darkColor: widget.darkColor,
                pureColor: widget.pureColor,
                heightToRadiusRatio: widget.heightToRadiusRatio),
          ),
        ),
      ),
    );
  }

  void _updateSwitcherState() {
    if (_slideController.state == DarkFloatingSwitcherState.on) {
      _slideController.setSwitchOffState();
    } else {
      _slideController.setSwitchOnState();
    }
    setState(() {});
    _slideController.prevState = _slideController.state;
  }

  void _setSwitcherState() {
    if (_slideController.state == DarkFloatingSwitcherState.off) {
      _slideController.setSwitchOffState();
    } else {
      _slideController.setSwitchOnState();
    }
    setState(() {});
  }

  void _updateStateOnHorizontalDrag(DragUpdateDetails details) {
    if (details.delta.dx > 0) {
      // swiping in right direction
      _slideController.setSwitchOnState();
    } else {
      // swiping in left direction
      _slideController.setSwitchOffState();
    }
    setState(() {});
    if (_slideController.prevState != _slideController.state) {
      widget.valueChanged(_slideController.state);
      _slideController.prevState = _slideController.state;
    }
  }
}
