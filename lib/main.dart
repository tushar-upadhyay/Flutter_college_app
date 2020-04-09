import 'package:demo/auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main ()async{
  WidgetsFlutterBinding.ensureInitialized();
     SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic name =   prefs.get('name');
    dynamic imageUrl =   prefs.get('imageUrl');
    dynamic username =   prefs.get('username');
    dynamic password =   prefs.get('password');
    dynamic lnctu =   prefs.get('lnctu');
    Map data = {
      'name':name,
      'imageUrl':imageUrl,
      'username':username,
      'password':password,
      'lnctu':lnctu
    };
    runApp(
      MaterialApp(
        home:Auth(data:data),
      )
    );
}

