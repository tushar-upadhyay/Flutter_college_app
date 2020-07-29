import 'package:flutter/material.dart';
import 'package:demo/models/attendanceModel.dart';
import 'package:demo/styles/clip.dart';
import 'package:demo/widgets/homeScreenItem.dart';

class DesktopHome extends StatefulWidget {
  final Map data;
  DesktopHome({this.data});
  @override
  _DesktopHomeState createState() => _DesktopHomeState();
}

class _DesktopHomeState extends State<DesktopHome> {
  bool isLoading = false;
  String present;
  String totalLectures;
  String percentage;
  @override
  void initState() {
    present = "";
    totalLectures = "";
    percentage = "";
    super.initState();
  }

  void getAttendance(Map data) async {
    this.setState(() => isLoading = true);
    try {
      dynamic res =
          await attendance(data['username'], data['password'], data['lnctu']);
      print(res);
      if (res['Percentage'] != null) {
        this.setState(() {
          isLoading = false;
          present = res['Present '].toString();
          totalLectures = res['Total Lectures'].toString();
          percentage = res['Percentage'].toString();
        });
      }
    } catch (e) {
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Container(
      color: Color(0xffE2E3E7),
      child: Column(
        children: [
          Container(
            height: 300,
            child: Stack(
              children: [
                ClipPath(
                  clipper: CustomClip(),
                  child: Container(
                      height: 300,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: <Color>[Colors.red, Colors.blue]))),
                ),
                Container(
                  height: 300,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Image.asset('assets/user.png',
                                height: 100, width: 100),
                            Spacer(),
                            Text(widget.data['name'])
                          ],
                        ),
                        height: 150,
                        width: 150,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(width: 4, color: Colors.grey)),
                            height: 150,
                            width: 150,
                            child: Center(
                                child: isLoading == true
                                    ? CircularProgressIndicator()
                                    : Text(
                                        '$percentage',
                                        style: TextStyle(
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold),
                                      )),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: FlatButton(
                              color: Colors.grey,
                              child: Text('Get Attendance'),
                              onPressed: () {
                                getAttendance(widget.data);
                              },
                            ),
                          )
                        ],
                      ),
                      Container(
                        child: Column(
                          children: [
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: 'Total',
                                    style: TextStyle(
                                        fontSize: 40, color: Colors.black)),
                                TextSpan(
                                    text: '  $totalLectures',
                                    style: TextStyle(
                                        fontSize: 40, color: Colors.black)),
                                TextSpan(text: "\n"),
                                TextSpan(text: "\n"),
                                TextSpan(
                                    text: 'Present',
                                    style: TextStyle(
                                        fontSize: 40, color: Colors.black)),
                                TextSpan(
                                    text: '  ${present}',
                                    style: TextStyle(
                                        fontSize: 40, color: Colors.black))
                              ]),
                            ),
                          ],
                        ),
                        height: 150,
                        width: 300,
                        // margin: EdgeInsets.fromLTRB(50, 50, 0, 0),
                        alignment: Alignment.topCenter,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 100),
            child: Wrap(
              runSpacing: 15,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    width: 250,
                    height: 150,
                    child: Item(data: widget.data, id: 0)),
                Container(
                   padding: EdgeInsets.symmetric(horizontal: 15),
                    width: 250,
                    height: 150,
                    child: Item(data: widget.data, id: 1)),
                Container(
                   padding: EdgeInsets.symmetric(horizontal: 15),
                    width: 250,
                    height: 150,
                    child: Item(data: widget.data, id: 2)),
                Container(
                   padding: EdgeInsets.symmetric(horizontal: 15),
                    width: 250,
                    height: 150,
                    child: Item(data: widget.data, id: 3))
              ],
            ),
          )
        ],
      ),
    );
  }
}
