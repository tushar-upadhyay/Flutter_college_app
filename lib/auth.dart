import 'package:demo/home.dart';
import 'package:demo/screens/loginscreen.dart';
import 'package:flutter/material.dart';

class Auth extends StatelessWidget {
  final Map data;
  const Auth({Key key, this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print('Auth built');
    if (data['username'] == null) {
      return LoginScreen();
    }
    return Main();
  }
}
