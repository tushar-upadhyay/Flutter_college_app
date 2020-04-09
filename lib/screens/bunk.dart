import 'package:flutter/material.dart';

class Bunk extends StatefulWidget {
  @override
  _BunkState createState() => _BunkState();
}

class _BunkState extends State<Bunk> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text('Bunk Mangager')),
    );
  }
}