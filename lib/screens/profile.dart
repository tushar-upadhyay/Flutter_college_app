import 'package:demo/auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Profile extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('My Profile'),
        actions: <Widget>[
          FlatButton.icon(onPressed: ()async{
            final SharedPreferences preferences = await SharedPreferences.getInstance();
             await preferences.clear();
             Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Auth(data:{'username':null})), (route) => false);
          }, icon: Icon(Icons.power_settings_new,color: Colors.red,), label: Text("Log Out",style: TextStyle(letterSpacing: 1.2,fontSize: 17),))
        ],
      ),
    );
  }
}
