import 'package:demo/providers/loginProvider.dart';
import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:demo/models/attendanceModel.dart';
import 'package:demo/models/routes.dart';
// import 'package:demo/styles/clip.dart';
import 'package:demo/widgets/homeScreenItem.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final GlobalKey<_AttendanceWidgetState> _attendanceState =
      new GlobalKey<_AttendanceWidgetState>();
  @override
  Widget build(BuildContext context) {
    LoginProvider loginProvider = Provider.of<LoginProvider>(context);
    double h = MediaQuery.of(context).size.height;
    return Container(
      color: Color.fromRGBO(26, 28, 29, 1),
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              // ClipPath(
              //   clipper: CustomClip(),
              //   child: Container(
              //     height: MediaQuery.of(context).size.height * 0.42, //380
              //     color: Color(0xff1b262c),
              //     // decoration: BoxDecoration(
              //     //     gradient: LinearGradient(
              //     //         begin: Alignment.topLeft,
              //     //         end: Alignment.bottomRight,
              //     //         colors: <Color>[Color(0xFF101e3d), Colors.blueGrey])),
              //   ),
              // ),
              Padding(
                padding: EdgeInsets.only(top: h * 0.083), //50
                child: Column(
                  children: <Widget>[
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: loginProvider.data['gender'] == "male"
                            ? Image.asset(
                                "assets/user.png",
                                width: h * 0.13,
                                height: h * 0.13,
                              )
                            : Image.asset(
                                "assets/female.png",
                                width: h * 0.13,
                                height: h * 0.13,
                              ),
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Text(loginProvider.data['name'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                            color: Colors.white)),
                    SizedBox(height: 20.0),
                    Container(
                        height: h * 0.189,
                        decoration: BoxDecoration(
                          color: ThemeData.dark().canvasColor,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
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
                                              color: Colors.white,
                                              fontSize: h * 0.0211)),
                                      Text('Present',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: h * 0.0211)),
                                      Text('Percentage',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: h * 0.0211)),
                                    ]),
                                AttendanceWidget(
                                  key: _attendanceState,
                                  data: loginProvider.data,
                                ),
                                RaisedButton(
                                  child: Text("View Attendance"),
                                  onPressed: () => _attendanceState.currentState
                                      .getAttendance(loginProvider),
                                  color: Color.fromRGBO(138, 180, 248, 1),
                                  textColor: Colors.black,
                                  padding: EdgeInsets.fromLTRB(9, 9, 9, 9),
                                  splashColor: Colors.grey,
                                )
                              ],
                            ))),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(15, h * 0.047, 0, 0), //20
                child: IconButton(
                  icon: Icon(Icons.menu, color: Colors.white, size: 25),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              )
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Flexible(
            child: ListView(
              children: <Widget>[
                Wrap(
                    spacing: MediaQuery.of(context).size.width * 0.08,
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.end,
                    runSpacing: MediaQuery.of(context).size.width * 0.05,
                    direction: Axis.horizontal,
                    children: List.generate(routes.length,
                        (int id) => Item(id: id, data: loginProvider.data)))
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
  bool isError = false;
  @override
  void initState() {
    super.initState();
    isLoading = false;
    totalLectures = null;
    present = null;
    totalLectures = null;
    percentage = null;
  }

  void getAttendance(LoginProvider loginProvider) async {
    this.setState(() => isLoading = true);
    try {
      dynamic res = await loginProvider.attendance();
      if (res['Percentage'] != null) {
        setState(() {
          isLoading = false;
          isError = false;
          present = res['Present '];
          totalLectures = res['Total Lectures'];
          percentage = res['Percentage'];
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
      });
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
    if (isError) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Icon(Icons.cancel, color: Colors.red),
      );
    }
    if (present != null) {
      return Padding(
        padding: EdgeInsets.all(0.014 * h),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(totalLectures.toString(),
                  style: TextStyle(fontSize: h * 0.0211)),
              Text(present.toString(), style: TextStyle(fontSize: h * 0.0211)),
              Text(percentage.toString(),
                  style: TextStyle(fontSize: h * 0.0211)),
            ]),
      );
    }
    return SizedBox(height: 0.0411 * h);
  }
}
