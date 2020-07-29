import 'dart:math';

import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:demo/models/attendanceModel.dart';
import 'package:demo/utils/methods.dart';
import 'package:demo/widgets/custom_circle.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Bunk extends StatefulWidget {
  final Map data;
  const Bunk({Key key, this.data}) : super(key: key);
  @override
  _BunkState createState() => _BunkState();
}

class _BunkState extends State<Bunk> {
  SharedPreferences prefs;
  final _validator = GlobalKey<FormFieldState>();
  bool isLoading = true;
  double percentage;
  double total;
  double goal;
  bool isUpdating = false;
  double present;
  int lecturesNeeded;
  int daysNeeded;
  int freeDays;
  String msg;
  bool goalIsThere;
  bool isError = false;
  bool allLoaded = false;
  bool autoRefresh = false;
  @override
  void initState() {
    super.initState();

    load();
  }

  void load() async {
    prefs = await SharedPreferences.getInstance();
    dynamic g = await prefs.get('goal');
    dynamic _autoRefresh = (await prefs.get('autoRefresh'));
    autoRefresh = _autoRefresh == 'false' ? false : true;
    if (_autoRefresh == null) {
      autoRefresh = false;
    }
    if (autoRefresh) {
      isUpdating = true;
    }
    if (g == null) {
      setState(() {
        isLoading = false;
        goalIsThere = false;
      });
    } else {
      setState(() {
        goalIsThere = true;
        goal = double.parse(g);
      });
      getAttendance();
    }
  }

  void updateAttendance() async {
    try {
      dynamic data = await attendance(widget.data['username'],
          widget.data['password'], widget.data['lnctu']);
      dynamic _percentage = data['Percentage'].toString();
      dynamic _total = data['Total Lectures'].toString();
      dynamic _present = data['Present '].toString();
      dynamic _daysNeeded = data['DaysNeeded'].toString();
      dynamic _lecturesNeeded = data['LecturesNeeded'].toString();
      await prefs.setString('total', _total);
      await prefs.setString('present', _present);
      await prefs.setString('percentage', _percentage);
      await prefs.setString('daysNeeded', _daysNeeded);
      await prefs.setString('lecturesNeeded', _lecturesNeeded);
      Map tu = changeGoal(
          present_: double.parse(_present),
          total_: double.parse(_total),
          percentage_: double.parse(_percentage));
      setState(() {
        total = double.parse(_total);
        present = double.parse(_present);
        percentage = double.parse(_percentage);
        daysNeeded = tu['daysNeeded'];
        lecturesNeeded = tu['lecturesNeeded'];
        freeDays = tu['freeDays'];
        isUpdating = false;
      });
    } catch (err) {
      setState(() {
        isUpdating = false;
        isError = true;
      });
    }
  }

  Map<String, dynamic> changeGoal(
      {present_ = null, total_ = null, percentage_ = null}) {
    present_ = present != null ? present : present_;
    total_ = total != null ? total : total_;
    percentage_ = percentage != null ? percentage : percentage_;
    double _lecturesNeeded = (goal * total_ - present_) / (1 - goal);
    if (_lecturesNeeded < 0) _lecturesNeeded = 0;
    return {
      "lecturesNeeded": _lecturesNeeded.round(),
      "daysNeeded": _lecturesNeeded ~/ 7,
      "freeDays":
          findFreeDays(g: goal, p: present_, per: percentage_, t: total_)
    };
  }

  int findFreeDays({double g, double p, double per, double t}) {
    if (g * 100 < per) {
      double x = (p - g * t) / g;
      msg =
          'You can bunk ${x.round().toString()} lectures to maintain ${(g * 100).toStringAsFixed(0)}% attendance';
      if (x / 7 > 120) {
        msg = 'You can bunk the whole semester ';
      }
      return x.toInt();
    }
    msg = 'Your current attendance is  less than your goal';
    return 0;
  }

  void t() async {
    await prefs.remove('percentage');
  }

  void getAttendance() async {
    try {
      dynamic _percentage = await prefs.get('percentage');
      dynamic _total;
      dynamic _present;
      dynamic _daysNeeded;
      dynamic _lecturesNeeded;
      if (_percentage != null) {
        _total = await prefs.get('total');
        _present = await prefs.get('present');
        _daysNeeded = await prefs.get('daysNeeded');
        _lecturesNeeded = await prefs.get('lecturesNeeded');
      } else {
        dynamic data = await attendance(widget.data['username'],
            widget.data['password'], widget.data['lnctu']);
        _percentage = data['Percentage'].toString();
        _total = data['Total Lectures'].toString();
        _present = data['Present '].toString();
        _daysNeeded = data['DaysNeeded'].toString();
        _lecturesNeeded = data['LecturesNeeded'].toString();
        await prefs.setString('total', _total);
        await prefs.setString('present', _present);
        await prefs.setString('percentage', _percentage);
        await prefs.setString('daysNeeded', _daysNeeded);
        await prefs.setString('lecturesNeeded', _lecturesNeeded);
      }
      Map tu = changeGoal(
          present_: double.parse(_present),
          total_: double.parse(_total),
          percentage_: double.parse(_percentage));
      print(tu);
      setState(() {
        isError = false;
        total = double.parse(_total);
        present = double.parse(_present);
        percentage = double.parse(_percentage);
        daysNeeded = tu['daysNeeded'];
        lecturesNeeded = tu['lecturesNeeded'];
        freeDays = tu['freeDays'];
        isLoading = false;
      });
      if (autoRefresh) {
        dynamic data = await attendance(widget.data['username'],
            widget.data['password'], widget.data['lnctu']);
        _percentage = data['Percentage'].toString();
        _total = data['Total Lectures'].toString();
        _present = data['Present '].toString();
        _daysNeeded = data['DaysNeeded'].toString();
        _lecturesNeeded = data['LecturesNeeded'].toString();
        await prefs.setString('total', _total);
        await prefs.setString('present', _present);
        await prefs.setString('percentage', _percentage);
        await prefs.setString('daysNeeded', _daysNeeded);
        await prefs.setString('lecturesNeeded', _lecturesNeeded);
        Map tu = changeGoal(
            present_: double.parse(_present),
            total_: double.parse(_total),
            percentage_: double.parse(_percentage));
        setState(() {
          isError = false;
          total = double.parse(_total);
          present = double.parse(_present);
          daysNeeded = tu['daysNeeded'];
          lecturesNeeded = tu['lecturesNeeded'];
          freeDays = tu['freeDays'];
          percentage = double.parse(_percentage);
          isUpdating = false;
        });
      }
    } catch (err) {
      setState(() {
        isUpdating = false;
        isLoading = false;
        isError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    if (isError) {
      return Center(
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
                  getAttendance();
                },
                icon: Icon(Icons.refresh),
                label: Text('Refresh'))
          ],
        ),
      );
    }
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    if (!goalIsThere) {
      return SafeArea(
        child: Scaffold(
            floatingActionButton: RaisedButton(
              onPressed: () async {
                if (_validator.currentState.validate()) {
                  await prefs.setString('goal', goal.toString());
                  await prefs.setString('autoRefresh', autoRefresh.toString());
                  if (percentage != null) {
                    Map data = changeGoal();
                    print(data);
                    setState(() {
                      daysNeeded = data['daysNeeded'];
                      lecturesNeeded = data['lecturesNeeded'];
                      freeDays = data['freeDays'];
                      goalIsThere = true;
                    });
                  } else {
                    setState(() {
                      goalIsThere = true;
                      isLoading = true;
                    });
                    getAttendance();
                  }
                }
              },
              child: Container(
                height: 60,
                width: 60,
                child: Center(
                    child: FaIcon(
                  FontAwesomeIcons.arrowRight,
                  // color: Colors.white,
                )),
              ),
              color: Colors.deepOrange[400],
              shape: CircleBorder(),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(40, h * 0.05, 0, 16),
                    child: Center(
                        child: Image.asset(
                      'assets/target.png',
                      width: h * 0.2,
                      height: h * 0.2,
                    )),
                  ),
                  Text(
                    'Set Your Attendance Goal',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.1),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 98.0, vertical: 32.0),
                    child: TextFormField(
                      key: _validator,
                      onChanged: (g) {
                        goal = double.parse(g) / 100;
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Cannot be null";
                        }
                        if (double.parse(value) < 1) {
                          return "Bhai Itni Kam kyo karni h 😁";
                        }
                        if (double.parse(value) >= 100) {
                          return 'Itni nhi hoti bhai 😁';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(hintText: 'Your Goal'),
                    ),
                  ),
                  Text('You can Change this later'),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: h * 0.015),
                    child: Divider(),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Auto Refresh?',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Switch(
                          onChanged: (bool value) {
                            setState(() => autoRefresh = value);
                          },
                          value: autoRefresh,
                        )
                      ]),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: h * 0.04, horizontal: 8.0),
                    child: Text(
                      'if Auto Refresh is on, Each time you open this page latest attendance will be fetched.\n \nIf Off you need to refresh it.',
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            )),
      );
    }
    return Scaffold(
        backgroundColor: ThemeData.dark().primaryColor,
        appBar: AppBar(
          title: Text('Goal'),
          actions: <Widget>[
            FlatButton.icon(
                onPressed: () {
                  setState(() => isUpdating = true);
                  updateAttendance();
                },
                icon: Icon(Icons.refresh),
                label: Text('Refresh')),
            FlatButton.icon(
                onPressed: () async {
                  await prefs.remove('goal');
                  setState(() {
                    goalIsThere = false;
                  });
                },
                icon: Icon(Icons.settings),
                label: Text('Change Settings'))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              renderLoader(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16.0),
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    width: double.infinity,
                    color: ThemeData.dark().canvasColor,
                    child: Center(
                      child: renderMsg(),
                    )),
              ),
              Container(
                  color: ThemeData.dark().canvasColor,
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                          width: 100,
                          child: circle(
                              text: 'Goal ${(goal * 100).toStringAsFixed(0)}%',
                              id: 0)),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                          width: 100,
                          child: circle(text: 'Free Lectures', id: 1))
                    ],
                  )),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.03),
                  width: double.infinity,
                  color: ThemeData.dark().canvasColor,
                  child: Center(
                      child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Center(
                            child: Text(
                          msg,
                          style: TextStyle(fontSize: 20),
                        )),
                      )
                    ],
                  )),
                ),
              ),
              RaisedButton(
                color: ThemeData.dark().buttonColor,
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                            title: Text('Enter Goal'),
                            actions: <Widget>[
                              RaisedButton(
                                color: Colors.blue,
                                child: Text('Change'),
                                onPressed: () {
                                  if (_validator.currentState.validate()) {
                                    Map data = changeGoal();
                                    print(data);
                                    setState(() {
                                      daysNeeded = data['daysNeeded'];
                                      lecturesNeeded = data['lecturesNeeded'];
                                      freeDays = data['freeDays'];
                                      goalIsThere = true;
                                    });
                                    Navigator.pop(context);
                                  }
                                },
                              )
                            ],
                            elevation: 0.2,
                            content: TextFormField(
                              key: _validator,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Cannot be null";
                                }
                                if (double.parse(value) < 1) {
                                  return "Bhai Itni Kam kyo karni h 😁";
                                }
                                if (double.parse(value) >= 100) {
                                  return 'Itni nhi hoti bhai 😁';
                                }
                                return null;
                              },
                              autofocus: true,
                              onChanged: (e) {
                                goal = double.parse(e) / 100;
                              },
                            ));
                      });
                },
                child: Text(
                  'Change Goal',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: Text(
                    'This only changes the goal temporarily \n To change it permanently visit settings'),
              )
            ],
          ),
        ));
  }

  Widget renderLoader() {
    if (isUpdating) {
      return LinearProgressIndicator();
    }
    return SizedBox(
      height: 0,
    );
  }

  Widget renderMsg() {
    String text;
    if (daysNeeded - total > 150) {
      text = 'Ab Nahi hogi itni is semester me';
    } else {
      text = daysNeeded == 0
          ? 'Your Attendance is above ${(goal * 100.0).toStringAsFixed(0)}%'
          : 'You need $lecturesNeeded lectures or $daysNeeded days for  ${(goal * 100).toStringAsFixed(0)}%';
    }
    FaIcon icon = daysNeeded == 0
        ? FaIcon(FontAwesomeIcons.check, color: Colors.green)
        : FaIcon(Icons.cancel, color: Colors.red);
    return Row(
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0), child: icon),
        Flexible(
            child: Text(
          text,
          style: TextStyle(
            fontSize: 20,
          ),
          softWrap: true,
        ))
      ],
    );
  }

  Widget circle({String text, int id}) {
    double angle = (total / (total + lecturesNeeded)) * 2 * pi;
    FaIcon icon = lecturesNeeded == 0
        ? FaIcon(FontAwesomeIcons.check, color: Colors.green)
        : FaIcon(
            Icons.error,
            color: Colors.red,
          );
    if (id == 1) {
      icon = freeDays != 0
          ? FaIcon(FontAwesomeIcons.check, color: Colors.green)
          : FaIcon(
              Icons.error,
              color: Colors.red,
            );
      angle = map(
          inputhi: 120 * 7.0,
          inputlo: 0,
          outputhi: 2 * pi,
          outputlo: 0,
          val: freeDays.toDouble());
    }
    return Stack(children: [
      Align(
          alignment: Alignment.center,
          child: Container(
            color: ThemeData.dark().canvasColor,
            // child: CustomCircle(
            //     angle: angle, radius: MediaQuery.of(context).size.height * 0.1),
          )),
      Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              icon,
              SizedBox(
                height: 5,
              ),
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            ],
          ))
    ]);
  }
}
