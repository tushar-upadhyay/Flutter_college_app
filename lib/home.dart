
import 'package:demo/screens/desktophome.dart';
import 'package:flutter/material.dart';

import 'package:demo/screens/bunk.dart';
import 'package:demo/screens/profile.dart';
import 'package:demo/screens/result.dart';
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
    screens_desktop.add(Bunk());
    screens_desktop.add(Result());
    screens_mobile.add(Home(data: widget.data,));
    screens_mobile.add(Bunk());
    screens_mobile.add(Result());
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
          BottomNavigationBarItem(icon: Icon(Icons.home),title:Text('',style: TextStyle(fontSize:0),)),
          BottomNavigationBarItem(icon: Icon(Icons.all_inclusive),title: Text('', style:TextStyle(fontSize:0))),
          BottomNavigationBarItem(icon: Icon(Icons.find_replace),title: Text('', style:TextStyle(fontSize:0)))
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
  Widget drawer(){
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
                    child: Text("My Profile"),
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Profile()));
                    },
                    color: Colors.lightBlue,
                    textColor: Colors.white,
                    padding: EdgeInsets.fromLTRB(9, 9, 9, 9),
                    splashColor: Colors.grey,
                  )
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

