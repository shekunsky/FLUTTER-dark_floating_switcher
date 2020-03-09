import 'dart:ui';
import 'package:flutter/material.dart';
import 'dark_floating_switcher_state.dart';

class DarkFloatingSwitcherPainter extends CustomPainter {
  final double animationStep;
  final DarkFloatingSwitcherState sliderState;

  final double heightToRadiusRatio;
  final Color pureColor;
  final Color darkColor;

  static const double animationOffset = 0.5; //Offset for animation

  DarkFloatingSwitcherPainter(this.animationStep, this.sliderState,
      {this.darkColor, this.pureColor, this.heightToRadiusRatio});

  @override
  void paint(Canvas canvas, Size size) {
    final paintPure = _paintBuilder(pureColor);
    final paintDark = _paintBuilder(darkColor);
    final radius = size.height / 2 * (1 - heightToRadiusRatio);

    if (sliderState == DarkFloatingSwitcherState.on) {
      if (animationOffset > animationStep) {
        _paintStartRightCircleAnim(
            canvas, size, animationStep, paintDark, paintPure, radius);
      } else {
        _paintStartLeftCircleAnim(
            canvas, size, animationStep, paintDark, paintPure, radius);
      }
    } else {
      if (animationOffset < animationStep) {
        _paintStartLeftCircleAnim(
            canvas, size, animationStep, paintDark, paintPure, radius);
      } else {
        _paintStartRightCircleAnim(
            canvas, size, animationStep, paintDark, paintPure, radius);
      }
    }
  }

  @override
  bool shouldRepaint(DarkFloatingSwitcherPainter oldDelegate) => true;

  void _paintBackground(Canvas canvas, Size size, Paint paintSun) {
    final radiusCircle = size.height / 2;

    final path = Path()
      ..moveTo(radiusCircle, 0)
      ..lineTo(size.width - radiusCircle, 0)
      ..arcToPoint(Offset(size.width - radiusCircle, size.height),
          radius: Radius.circular(radiusCircle), clockwise: true)
      ..lineTo(radiusCircle, size.height)
      ..arcToPoint(Offset(radiusCircle, 0),
          radius: Radius.circular(radiusCircle), clockwise: true);

    canvas.drawPath(path, paintSun);
  }

  void _paintStartRightCircleAnim(Canvas canvas, Size size, double step,
      Paint paintDark, Paint paintPure, double radius) {
    final widthAnim = 2 * size.width * step + (1 - 2 * step) * size.height;
    final offset = size.height / 2;
    final width = widthAnim - size.height / 2;

    _paintBackground(canvas, size, paintPure);
    _pathAnimBackground(canvas, paintDark, offset, size.height, width, true);

    _paintCircle(canvas, radius, size.height / 2, paintPure, size.height / 2);
    _paintOval(canvas, radius, size.height / 2, paintDark,
        size.width - size.height / 2);
  }

  void _paintStartLeftCircleAnim(Canvas canvas, Size size, double step,
      Paint paintDark, Paint paintPure, double radius) {
    final widthAnim =
        2 * (step - 0.5) * size.width + (1.5 - 2 * step) * size.height;
    final offset = size.width - size.height / 2;
    final width = widthAnim;

    _paintBackground(canvas, size, paintPure);
    _pathAnimBackground(canvas, paintDark, offset, size.height, width, false);
    _paintCircle(canvas, radius, size.height / 2, paintDark, size.height / 2);
    _paintOval(canvas, radius, size.height / 2, paintPure,
        size.width - size.height / 2);
  }

  void _pathAnimBackground(Canvas canvas, Paint paint, double offset,
      double height, double width, bool clockwise) {
    final path = Path()
      ..moveTo(offset, 0)
      ..lineTo(width, 0)
      ..arcToPoint(Offset(width, height),
          radius: Radius.circular(height / 2), clockwise: clockwise)
      ..lineTo(offset, height)
      ..arcToPoint(Offset(offset, 0),
          radius: Radius.circular(height / 2), clockwise: clockwise);

    canvas.drawPath(path, paint);
  }

  void _paintCircle(
      Canvas canvas, double radius, double height, Paint paint, double offset) {
    canvas.drawCircle(Offset(offset, height), radius, paint);
  }

  void _paintOval(
      Canvas canvas, double radius, double height, Paint paint, double offset) {
    final path = Path()
      ..moveTo(offset - radius, height - radius)
      ..arcToPoint(Offset(offset + radius, height - radius),
          radius: Radius.circular(radius), clockwise: true)
      ..lineTo(offset + radius, height + radius)
      ..arcToPoint(Offset(offset - radius, height + radius),
          radius: Radius.circular(radius), clockwise: true)
      ..lineTo(offset - radius, height - radius);

    canvas.drawPath(path, paint);
  }

  Paint _paintBuilder(Color color) => Paint()
    ..color = color
    ..style = PaintingStyle.fill;
}
