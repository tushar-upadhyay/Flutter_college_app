
import 'package:demo/screens/desktophome.dart';
import 'package:flutter/material.dart';

import 'package:demo/screens/bunk.dart';
import 'package:demo/screens/profile.dart';
import 'package:demo/screens/result.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import './screens/home.dart';

class Main extends StatefulWidget {
  final Map data;
  Main({Key key, this.data}) : super(key: key);
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
 
  int selected = 0;
  List<Widget> screens_desktop =[];
  List<Widget> screens_mobile = [];
  int _currentIndex = 0;
  void initState() {
    super.initState();
    screens_desktop.add(DesktopHome(data: widget.data,));
    screens_desktop.add(Bunk(data:widget.data));
    screens_desktop.add(Result());
    screens_mobile.add(Home(data: widget.data,));
    screens_mobile.add(Bunk(data:widget.data));
    screens_mobile.add(Result());
  }
  void _launchURL(String id) async {
    Map urls = {
      'insta': 'https://instagram.com/tusharupadhyay_',
      'github': 'https://github.com/tushar-upadhyay',
      'mail': 'mailto:tusharrockpg@gmail.com',
      'source': 'https://github.com/tushar-upadhyay/Flutter_college_app'
    };
    String url = urls[id];
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    if(w<500){
    return Scaffold(
      drawer: drawer(),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 8.0,
        backgroundColor: Color(0xFF6800f4),
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.white,
        onTap: (e)=>setState(()=>_currentIndex=e),
        currentIndex: _currentIndex,
        items:[
           BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.home),
                title: Text(
                  '',
                  style: TextStyle(fontSize: 0),
                )),
            BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.bullseye),
                title: Text('', style: TextStyle(fontSize: 0))),
            BottomNavigationBarItem(
                icon: Icon(Icons.search),
                title: Text('', style: TextStyle(fontSize: 0)))
        ],
      ),
      body:screens_mobile[_currentIndex]
    );;

    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          menuItem('Home',0),
          menuItem('Bunk Manager',1),
          Padding(
            padding: const EdgeInsets.only(right:100),
            child: menuItem('RGPV Results',2),
          )
        ],
        title:Text('LNCT Attendance',style: TextStyle(color: Colors.black),)
      ),
      drawer: drawer(),
      body:screens_desktop[selected],
    );
  }
  Widget menuItem(String text,int id){
    return FlatButton(
      child: Text(text,style: TextStyle(fontWeight: id==selected?FontWeight.bold:FontWeight.normal),),
      onPressed: (){setState(() {
        selected = id;
      });},
    );
  }
  Widget drawer() {
    return Drawer(
        elevation: 0.0,
        child: SafeArea(
            child: Container(
          color: Colors.yellow[100],
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset("assets/user.png", height: 100,
                          width: 100,fit: BoxFit.fill,),
                        )
                  ],
                ),
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                child: Text("Profile"),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Profile(
                            data: widget.data,
                          )));
                },
                color: Colors.lightBlue,
                textColor: Colors.white,
                padding: EdgeInsets.fromLTRB(9, 9, 9, 9),
                splashColor: Colors.grey,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(
                  thickness: 1.8,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  children: [
                    
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                              onTap: () {
                                _launchURL('mail');
                              },
                              child: FaIcon(
                                Icons.mail_outline,
                                size: 32,
                                color: Colors.deepOrange,
                              )),
                          GestureDetector(
                              onTap: () {
                                _launchURL('source');
                              },
                              child: FaIcon(
                                FontAwesomeIcons.code,
                                size: 32,
                                color: Colors.black,
                              )),
                          GestureDetector(
                              onTap: () {
                                _launchURL('insta');
                              },
                              child: FaIcon(
                                FontAwesomeIcons.instagram,
                                size: 32,
                                color: Colors.red,
                              )),
                          GestureDetector(
                              onTap: () {
                                _launchURL('github');
                              },
                              child: FaIcon(FontAwesomeIcons.github, size: 32))
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(bottom:5.0),
                        child: Text('Made with ❤ By Tushar'))))
            ],
          ),
        )));
  }
}


// DefaultTabController(
//       length: 3,
//       child: Scaffold(
//         drawer: drawer(),
//         bottomNavigationBar: Material(
//           color: Colors.blueAccent[200],
//           child: TabBar(
//             indicatorColor: Colors.red,
//             labelColor: Colors.white,
//             labelPadding: EdgeInsets.all(5),
//             tabs: [
//               Tab(
//                 text: 'Attendance',
//               ),
//               Tab(text: 'Bunk Manager'),
//               Tab(text: 'RGPV Result'),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [Home(data: widget.data), Bunk(), Result()],
//         ),
//       ),
//     )

