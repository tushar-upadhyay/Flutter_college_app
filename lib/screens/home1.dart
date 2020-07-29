import 'package:flutter/material.dart';
import 'package:demo/models/attendanceModel.dart';
import 'package:demo/models/routes.dart';
import 'package:demo/styles/clip.dart';
import 'package:demo/widgets/homeScreenItem.dart';

class Home extends StatelessWidget {
  final Map data;
  Home({this.data});
  final GlobalKey<_AttendanceWidgetState> _attendanceState =
      new GlobalKey<_AttendanceWidgetState>();
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      color: Color(0xffE2E3E7),
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              ClipPath(
                clipper: CustomClip(),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.42, //380
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: <Color>[Colors.red, Colors.blue])),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top:50), //50
                child: Column(
                  children: <Widget>[
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(80),
                        child: Image.asset('assets/user.png',height:100,width:100)
                        // child: Image.network(data['imageUrl'],cacheWidth: 75,cacheHeight: 75,width: 75,height: 75,),
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Text(data['name'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15.0)),
                    SizedBox(height: 20.0),
                    Container(
                        height: h * 0.189,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.white),
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(0, h * 0.0294, 0, 0),
                            child: Column(
                              children: <Widget>[
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('Total Lectures',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: h * 0.0211)),
                                      Text('Present',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: h * 0.0211)),
                                      Text('Percentage',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: h * 0.0211)),
                                    ]),
                                AttendanceWidget(
                                  key: _attendanceState,
                                  data: data,
                                ),
                                RaisedButton(
                                  child: Text("View Attendance"),
                                  onPressed: () => _attendanceState.currentState
                                      .getAttendance(data['username'],
                                          data['password'], data['lnctu']),
                                  color: Colors.lightBlue,
                                  textColor: Colors.white,
                                  padding: EdgeInsets.fromLTRB(9, 9, 9, 9),
                                  splashColor: Colors.grey,
                                )
                              ],
                            ))),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 0, 0), //20
                child: IconButton(
                  icon: Icon(Icons.menu, color: Colors.white, size: 25),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              )
            ],
          ),
          Flexible(
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Wrap(
                      spacing: MediaQuery.of(context).size.width * 0.08,
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.end,
                      runSpacing: MediaQuery.of(context).size.width * 0.08,
                      direction: Axis.horizontal,
                      children:List.generate(routes.length, (int id)=>Item(id:id,data:data))
                      ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
  
}

class AttendanceWidget extends StatefulWidget {
  final Map data;
  AttendanceWidget({Key key, this.data}) : super(key: key);
  @override
  _AttendanceWidgetState createState() => _AttendanceWidgetState();
}

class _AttendanceWidgetState extends State<AttendanceWidget> {
  var totalLectures;
  var present;
  var percentage;

  bool isLoading;
  @override
  void initState() {
    super.initState();
    isLoading = false;
    totalLectures = null;
    present = null;
    totalLectures = null;
    percentage = null;
  }

  void getAttendance(String username, String password, String lnctu) async {
    print(username);
    this.setState(() => isLoading = true);
    try {
      dynamic res = await attendance(username, password, lnctu);

      if (res['Percentage'] != null) {
        this.setState(() {
          isLoading = false;
          present = res['Present '];
          totalLectures = res['Total Lectures'];
          percentage = res['Percentage'];
        });
      }
    } catch (e) {
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    if (isLoading == true) {
      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
          child: LinearProgressIndicator(
            backgroundColor: Colors.grey[100],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ));
    }
    if (present != null) {
      return Padding(
        padding: EdgeInsets.all(0.014 * h),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(present.toString(),
                  style: TextStyle(color: Colors.black, fontSize: h * 0.0211)),
              Text(present.toString(),
                  style: TextStyle(color: Colors.black, fontSize: h * 0.0211)),
              Text(percentage.toString(),
                  style: TextStyle(color: Colors.black, fontSize: h * 0.0211)),
            ]),
      );
    }
    return SizedBox(height: 0.0411 * h);
  }
}
