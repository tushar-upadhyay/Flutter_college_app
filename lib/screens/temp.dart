import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class Temp extends StatelessWidget {
  final Map data;

  const Temp({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    http.get(data['imageUrl']).then((value) => print(value));
    return Scaffold(
      appBar: AppBar(title: Text('temp screen'),),
      body: Container(
        child:Center(child: Text('temp'),)
      ),
    );
  }
}