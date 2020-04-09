import 'dart:async';

import 'package:demo/models/resultModel.dart';
import 'package:demo/screens/resultView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Result extends StatefulWidget {
  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  final _formkey = GlobalKey<FormState>();
  final _scrollcontroller = ScrollController();
  int value;
  int semester;
  String enrollment;
  int stream;
  bool isLoading = false;
  String CGPA;
  String SGPA;
  String Name;
  void getResult() async {
    setState(() {
      isLoading = true;
    });
    try {
      dynamic result =
          await fetchResult(enrollment, semester.toString(), stream.toString());
      setState(() {
        isLoading = false;
        Map data = {
          "name": result['Name'].trim(),
          "SGPA": result['SGPA'],
          "CGPA": result['CGPA'],
          'subjects': [
            {'subject': 'CS-104', 'grade': 'A+'},
            {'subject': 'CS-204', 'grade': 'A+'},
            {'subject': 'CS-404', 'grade': 'A+'},
            {'subject': 'CS-504', 'grade': 'A+'},
            {'subject': 'CS-114', 'grade': 'A+'},
            {'subject': 'CS-234', 'grade': 'A+'},
            {'subject': 'CS-444', 'grade': 'A+'},
            {'subject': 'CS-554', 'grade': 'A+'},
          ]
        };

        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ResultView(data: data)));
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void test() {
    Map data = {
      "name": "Tushar Upadhyay",
      "SGPA": "8.2",
      "CGPA": "8.31",
      'subjects': [
        {'subject': 'CS-104', 'grade': 'A+'},
        {'subject': 'CS-204', 'grade': 'A+'},
        {'subject': 'CS-404', 'grade': 'A+'},
        {'subject': 'CS-504', 'grade': 'A+'},
        {'subject': 'CS-114', 'grade': 'A+'},
        {'subject': 'CS-234', 'grade': 'A+'},
        {'subject': 'CS-444', 'grade': 'A+'},
        {'subject': 'CS-554', 'grade': 'A+'},
      ]
    };
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ResultView(data: data)));
  }

  dynamic returnResult() {
    if (isLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: LinearProgressIndicator(),
      );
    }
    return Container(height: 0, width: 0);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //     backgroundColor: Colors.grey[100],
      //     title: Text(
      //       'RGPV Results',
      //       style: TextStyle(color: Colors.black),
      //     )),
      body: Stack(
          children: <Widget>[
            Container(
      height: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.blue[100], Colors.blueAccent])),
            ),
            Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        controller: _scrollcontroller,
        child: Container(
          padding: EdgeInsets.only(bottom: 10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: <Widget>[
                    Hero(
                      tag: 'image',
                                          child: Image.asset(
                        'assets/rgpv_logo.png',
                        width: 100,
                        height: 100,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: Text(
                        'RGPV Result',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 350,
                width: 250,
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: Hero(
                  tag: 'image',
                                  child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(vertical: 8.0),
                          child: DropdownButtonFormField(
                              validator: (value) {
                                if (value == null) {
                                  return "Enter Stream";
                                }
                                return null;
                              },
                              hint: Text('Select Stream'),
                              value: value,
                              items: [
                                DropdownMenuItem(
                                    value: 0, child: Text('B.Tech')),
                                DropdownMenuItem(
                                    value: 1, child: Text('M.Tech')),
                                DropdownMenuItem(
                                    value: 2, child: Text('B.Pharma'))
                              ],
                              onChanged: (v) {
                                setState(() => stream = v);
                              }),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Enter Semester";
                              }
                              return null;
                            },
                            onTap: () {
                              Timer(Duration(milliseconds: 500), () {
                                _scrollcontroller.animateTo(
                                    _scrollcontroller
                                        .position.maxScrollExtent,
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.decelerate);
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                semester = int.parse(value);
                              });
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Semester',
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Enter Stream";
                              }
                              return null;
                            },
                            onTap: () {
                              Timer(Duration(milliseconds: 500), () {
                                _scrollcontroller.animateTo(
                                    _scrollcontroller
                                        .position.maxScrollExtent,
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.decelerate);
                              });
                            },
                            onChanged: (value) {
                              setState(() => enrollment = value);
                            },
                            decoration: InputDecoration(
                              hintText: 'Enrollment No',
                            ),
                          ),
                        ),
                        RaisedButton(
                          child: Text("View Result!"),
                          onPressed: () {
                            test();
                            // if (_formkey.currentState.validate()) {
                            //   getResult();
                            // }
                          },
                          color: Colors.lightBlue,
                          textColor: Colors.white,
                          padding: EdgeInsets.fromLTRB(9, 9, 9, 9),
                          splashColor: Colors.grey,
                        ),
                        returnResult()
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
            )
          ],
        ),
    );
  }
}
