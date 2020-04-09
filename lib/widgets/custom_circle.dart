import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class CustomCircle extends StatefulWidget {
  final angle;

  const CustomCircle({Key key, this.angle}) : super(key: key);

  @override
  _CustomCircleState createState() => _CustomCircleState();
}

class _CustomCircleState extends State<CustomCircle> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: Painter(widget.angle),
    );
  }
}

class Painter extends CustomPainter {
  final angle;
  Painter(this.angle);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Colors.deepOrange;
    canvas.drawCircle(Offset(-0, 0), 100, paint);
    canvas.drawArc(Rect.fromCircle(center: Offset(-0, 0), radius: 100), -pi / 2,
        angle, true, paint..color = Colors.blue);
    canvas.drawCircle(Offset(-0, 0), 90, paint..color = Colors.white);

    // Paint();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
