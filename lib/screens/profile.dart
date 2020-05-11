import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth.dart';
class Profile extends StatelessWidget {
  final Map data;
  
   Profile({this.data});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF101e3d),
        title: Text('My Profile'),
        actions: <Widget>[
          FlatButton.icon(onPressed: ()async{
            final SharedPreferences preferences = await SharedPreferences.getInstance();
             await preferences.clear();
             Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Auth(data:{'username':null})), (route) => false);
          }, icon: Icon(Icons.power_settings_new,color: Colors.red,), label: Text("Log Out",style: TextStyle(letterSpacing: 1.2,fontSize: 17),))
        ],
      ),
      body: Stack(
        children: [
          Container(
            color: (Colors.grey[300]),
          ),
          Container(
            height: 300,
            width: double.infinity,
            color: Color(0xFF101e3d),
          ),
          Positioned(
            top: 30,
            left: 0,
            right: 0,
            child: Image.asset(
              "assets/user.png",
              width: 150,
              height: 150,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal:16),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10)),
                height: 300,
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical:32),
                    child: Text(data['name'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                  ),
                  Divider(thickness: 1.5,),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical:16.0),
                    child: Text('Semester ${data['semester']}',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 18),),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical:16.0),
                    child: Text('Branch ${data['branch']}',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 18),),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical:16.0),
                    child: Text(data['lnctu']=='true'?'LNCTU':'LNCT',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                  ),
                ],),
              ),
            ),
          )
        ],
      ),
    );
  }
  // Widget fields(String ){

  // }
}








