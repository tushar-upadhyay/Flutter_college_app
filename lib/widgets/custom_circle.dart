import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class CustomCircle extends StatefulWidget {
  final angle;
  final double radius;
  const CustomCircle({Key key, this.angle, this.radius}) : super(key: key);
  @override
  _CustomCircleState createState() => _CustomCircleState();
}

class _CustomCircleState extends State<CustomCircle> {
  @override
  Widget build(BuildContext context) {
    final radius = widget.radius == null ? 100.0 : widget.radius;
    return CustomPaint(
      painter: Painter(widget.angle, radius),
    );
  }
}

class Painter extends CustomPainter {
  final angle;
  final radius;
  Painter(this.angle, this.radius);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    paint.color = Colors.deepOrange;
    canvas.drawCircle(Offset(-0, 0), radius, paint);
    canvas.drawArc(Rect.fromCircle(center: Offset(-0, 0), radius: radius),
        -pi / 2, angle, true, paint..color = Colors.blue);
    canvas.drawCircle(Offset(-0, 0), radius * 0.9, paint..color = Colors.white);
    paint.color = ThemeData.dark().canvasColor;
    canvas.drawCircle(Offset(0, 0), radius * 0.9, paint);
    // Paint();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
