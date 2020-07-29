import 'package:demo/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:demo/home.dart';
import 'package:demo/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatelessWidget {
  final Map data;
  SharedPreferences prefs;
  Profile({this.data});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF101e3d),
        title: Text('My Profile'),
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () async {
                prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Auth(data: {'username': null})),
                    (route) => false);
              },
              icon: Icon(
                Icons.power_settings_new,
                color: Colors.red,
              ),
              label: Text(
                "Log Out",
                style: TextStyle(
                    letterSpacing: 1.2, fontSize: 17, color: Colors.white),
              ))
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
              child: Column(
                children: <Widget>[
                  data['gender'] == "male"
                      ? Image.asset(
                          "assets/user.png",
                          width: 150,
                          height: 150,
                        )
                      : Image.asset(
                          "assets/female.png",
                          width: 150,
                          height: 150,
                        ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 32, left: 16, right: 16),
                    child: Container(
                      height: 400,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 32),
                            child: Text(data['name'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black)),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text(
                                  'Gender : ${data['gender']}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Colors.black),
                                ),
                                FlatButton.icon(
                                  label: Text(
                                    'Switch?',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onPressed: () async {
                                    prefs =
                                        await SharedPreferences.getInstance();
                                    String gender = data['gender'] == "male"
                                        ? "female"
                                        : "male";

                                    prefs.setString('gender', gender);
                                    data['gender'] = gender;
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Main(
                                                  data: data,
                                                )),
                                        (route) => false);
                                  },
                                  icon: FaIcon(
                                    FontAwesomeIcons.edit,
                                    color: Color(0xFF101e3d),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Divider(
                            thickness: 1.5,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Text(
                              'Semester ${data['semester']}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                  color: Colors.black),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Text(
                              'Branch ${data['branch']}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                  color: Colors.black),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Text(
                              data['lnctu'] == 'true' ? 'LNCTU' : 'LNCT',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )),
        ],
      ),
    );
  }
}
