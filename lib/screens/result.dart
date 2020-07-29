import 'dart:async';
import 'package:flutter/cupertino.dart';
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
  final _textkey = GlobalKey<FormFieldState>();
  int value;
  int semester;
  String enrollment;
  int stream;
  bool isLoading = false;
  String CGPA;
  String SGPA;
  String Name;
  FocusNode focusNode;
  FocusNode focusNode2;
  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    focusNode2 = FocusNode();
  }

  @override
  void dispose() {
    focusNode.dispose();
    focusNode2.dispose();
    super.dispose();
  }

  void getResult() async {
    setState(() {
      isLoading = true;
    });
    try {
      dynamic result =
          await fetchResult(enrollment, semester.toString(), stream.toString());
      if (result['msg'] != null) {
        setState(() {
          isLoading = false;
        });
        showDialog(
            context: context,
            builder: (_) {
              return CupertinoAlertDialog(
                title: Text(result['msg']),
                content: Icon(Icons.cancel, color: Colors.red),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      focusNode2.unfocus();
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Check Again?',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              );
            });
      } else {
        setState(() {
          isLoading = false;
          Map data = {
            "name": result['Name'].trim(),
            "SGPA": result['SGPA'],
            "CGPA": result['CGPA'],
            'subjects': result['data']
          };
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ResultView(data: data)));
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showDialog(
          context: context,
          builder: (_) {
            return CupertinoAlertDialog(
              title: Text(
                  'Enrollment number is invalid or our servers are not responding'),
              content: Icon(Icons.cancel, color: Colors.red),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Check Again?',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            );
          });
    }
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
      backgroundColor: ThemeData.dark().primaryColor,
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
          ),
          Padding(
            padding: EdgeInsets.only(top: 32.0),
            child: Align(
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
                            Image.asset(
                              'assets/rgpv_logo.png',
                              width: 100,
                              height: 100,
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
                            color: ThemeData.dark().canvasColor),
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
                                    value: stream,
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
                                  focusNode: focusNode2,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Enter Semester";
                                    }
                                    return null;
                                  },
                                  onTap: () {
                                    Timer(Duration(milliseconds: 200), () {
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
                                  focusNode: focusNode,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Enter Enrollment";
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
                                  if (_formkey.currentState.validate()) {
                                    focusNode.unfocus();
                                    focusNode2.unfocus();
                                    getResult();
                                  }
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
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
