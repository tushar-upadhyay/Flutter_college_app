import 'package:flutter/material.dart';
class CustomClip extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;
    Path path = Path();
    path.lineTo(0, size.height);
    path.cubicTo(w/8, h-60, w-w/8, h-20, w, h-60);
    path.lineTo(size.width, 0);
    
    return path;
  }

  @override
   bool shouldReclip(CustomClipper<Path> oldClipper) => true;
  
}