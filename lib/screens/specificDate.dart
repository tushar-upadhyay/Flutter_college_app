import 'dart:math';
import 'package:demo/providers/loginProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:demo/models/attendanceModel.dart';
import 'package:demo/utils/months.dart';
import 'package:demo/widgets/custom_circle.dart';
import 'package:provider/provider.dart';

class SpecificDate extends StatefulWidget {
  @override
  _SpecificDateState createState() => _SpecificDateState();
}

class _SpecificDateState extends State<SpecificDate>
    with SingleTickerProviderStateMixin {
  int day;
  var month;
  int year;
  List data;
  DateTime current_date = DateTime.now();
  double attendance = 0;
  DateTime firstDate = DateTime(2019, 10);
  DateTime selectedDate;
  int present;
  int totallectures;
  AnimationController _acontroller;

  bool error = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    var date = DateTime.now();
    day = date.day;
    month = date.month;
    month = months[month - 1];
    year = date.year;
    load();
  }

  @override
  void dispose() {
    _acontroller.dispose();
    super.dispose();
  }

  void updateAttendance(String date, DateTime _date) {
    int difference = 1000000;
    dynamic closestData;
    bool isFound = false;
    for (var i in data) {
      if (i['date'] == date) {
        isFound = true;
        setState(() {
          attendance = i['percentage'];
        });
        break;
      } else {
        var date = i['date'].split(' ');
        var year = date[2];

        var month = (months.indexOf(date[1]) + 1).toString();
        if (month.length == 1) {
          month = '0' + month;
        }
        date = DateTime.parse('$year-$month-${date[0]}');
        var _difference = _date.difference(date).inDays;
        if (_difference.abs() < difference.abs()) {
          difference = _difference;
          closestData = i;
        }
      }
    }

    if (!isFound) {
      setState(() {
        attendance = closestData['percentage'];
        totallectures = closestData['totalLectures'];
        present = closestData['present'];
      });
    }
  }

  void load() async {
    try {
      dynamic res = await Provider.of<LoginProvider>(context, listen: false)
          .getdatewiseattendance();
      dynamic _firstDate = res[0]['date'];
      _firstDate = _firstDate.split(' ');

      var month_initial = (months.indexOf(_firstDate[1]) + 1).toString();
      if (month_initial.length == 1) {
        month_initial = '0' + month_initial;
      }
      _firstDate =
          DateTime.parse('${_firstDate[2]}-$month_initial-${_firstDate[0]}');

      setState(() {
        data = res;
        attendance = res[res.length - 1]['percentage'];
        present = res[res.length - 1]['present'];
        totallectures = res[res.length - 1]['totalLectures'];
        firstDate = _firstDate;
        isLoading = false;
      });
    } catch (err) {
      setState(() {
        isLoading = false;
        error = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'SpecificDate',
      child: Scaffold(
          appBar: AppBar(title: Text('Attendance Till Date')),
          body: error
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Icon(
                          Icons.cancel,
                          color: Colors.red,
                          size: 35,
                        ),
                      ),
                      Text('Some Error Occured '),
                      FlatButton.icon(
                          onPressed: () {
                            setState(() {
                              isLoading = true;
                              error = false;
                            });
                            load();
                          },
                          icon: Icon(Icons.refresh),
                          label: Text('Refresh'))
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          child: returnData(),
                        ),
                      ),
                      Text('As of $day $month $year',
                          style: TextStyle(fontSize: 30)),
                      // Align(alignment:Alignment.center,child: CustomCircle()),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: showDate(context),
                      ),
                      // Text('Attendance till ${DateTime.now()}')
                    ],
                  ),
                )),
    );
  }

  Widget returnData() {
    return Container(
      height: 300,
      child: Stack(children: [
        Center(
          child: TweenAnimationBuilder(
              curve: Curves.decelerate,
              duration: Duration(seconds: 1),
              tween: Tween<double>(begin: 0, end: attendance * pi * 2 / 100),
              builder: (_, double angle, __) {
                return CustomCircle(
                  angle: angle,
                );
              }),
        ),
        Align(
          alignment: Alignment.center,
          child: isLoading
              ? SpinKitDoubleBounce(color: Colors.green, size: 40)
              : Text(
                  '$attendance %',
                  style: TextStyle(fontSize: 35),
                ),
        ),
      ]),
    );
  }

  Widget showDate(BuildContext context) {
    return RaisedButton(
        onPressed: () async {
          try {
            var response = await showDatePicker(
                context: context,
                initialDate: current_date,
                firstDate: firstDate,
                lastDate: DateTime(2030, 10));
            setState(() {
              current_date = response == null ? current_date : response;
              day = response.day;
              month = months[response.month - 1];
              year = response.year;
              updateAttendance('$day $month $year', response);
            });
          } catch (e) {
            print(e);
          }
        },
        color: Colors.green,
        child: Text(
          'Change Date',
          style: TextStyle(color: Colors.white, fontSize: 17),
        ));
  }
}
