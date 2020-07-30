import 'package:demo/providers/loginProvider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:demo/home.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String username;
  String password;
  String error;
  String msg;
  bool isLoading;
  bool lnctu;
  double bottomPadding = 80;
  final _formKey = GlobalKey<FormState>();
  final _dropkey = GlobalKey<FormFieldState>();
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    super.initState();

    username = null;
    password = null;
    msg = '';
    isLoading = false;
  }

  void toggle() {
    this.setState(() => lnctu = !lnctu);
  }

  _launchURL({String option = 'signup'}) async {
    if (_dropkey.currentState.validate()) {
      var url = 'http://portal.lnct.ac.in/Accsoft2/Parents/ParentSingUp.aspx';
      if (lnctu) {
        url = 'http://portal.lnctu.ac.in/Accsoft2/Parents/ParentSingUp.aspx';
      }
      if (option == 'forgetPass') {
        url = 'http://portal.lnct.ac.in/Accsoft2/ForgetPasswd.aspx?Type=S';
        if (lnctu) {
          url = 'http://portal.lnctu.ac.in/Accsoft2/ForgetPasswd.aspx?Type=S';
        }
      }

      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  Widget activity() {
    if (isLoading) {
      return SpinKitRipple(color: Colors.green);
    }

    return Text(
      msg,
      style: TextStyle(
          color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 18),
    );
  }

  void login() async {
    if (isLoading == true) return null;
    this.setState(() => isLoading = true);
    password = Uri.encodeComponent(password).toString();

    controller.text = username;
    String _lnctu = lnctu ? 'true' : 'false';
    try {
      dynamic res = await Provider.of<LoginProvider>(context, listen: false)
          .login(username, password, _lnctu);
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      await preferences.setString('username', username);
      await preferences.setString('password', password);
      await preferences.setString('name', res['Name']);
      await preferences.setString('imageUrl', res['ImageUrl']);
      await preferences.setString('lnctu', _lnctu);
      await preferences.setString('semester', res['Semseter']);
      await preferences.setString('branch', res['Branch']);
      await preferences.setString('gender', res['Gender']);
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => Main()));
    } catch (e) {
      this.setState(() {
        isLoading = false;
        msg = 'Id or Password is not Valid!';
      });
    }
    this.setState(() {
      password = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    if (isLoading == true) {
      return Scaffold(
        backgroundColor: Color.fromRGBO(66, 92, 90, 1),
        body: Center(
            child: Wrap(
          children: <Widget>[
            Center(child: Text('Logging you in...')),
            SizedBox(
              height: 30,
            ),
            SpinKitHourGlass(color: Colors.blue),
          ],
        )),
      );
    }
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
          height: MediaQuery.of(context).size.height,
          color: Color.fromRGBO(66, 92, 90, 1),
          padding: EdgeInsets.fromLTRB(100, 20, 100, 0),
          child: Center(
            child: Container(
              width: w > 500 ? 300 : double.maxFinite,
              child: Padding(
                padding: EdgeInsets.only(bottom: bottomPadding),
                child: SingleChildScrollView(
                  child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'assets/logo.png',
                            height: 125,
                          ),
                          SizedBox(height: 30),
                          DropdownButtonFormField(
                              key: _dropkey,
                              value: lnctu,
                              icon: Icon(Icons.select_all),
                              decoration: InputDecoration(
                                hintStyle: TextStyle(color: Colors.white60),
                                errorStyle: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              validator: (value) {
                                print(value);
                                if (value == null) {
                                  return 'Please Select College';
                                }
                                return null;
                              },
                              iconEnabledColor: Colors.white,
                              hint: Text(
                                'Select College',
                                style: TextStyle(color: Colors.white60),
                              ),
                              items: [
                                DropdownMenuItem(
                                    value: false,
                                    child: Text('LNCT',
                                        style: TextStyle(
                                            color: Colors.deepOrange))),
                                DropdownMenuItem(
                                    value: true,
                                    child: Text(
                                      'LNCT University',
                                      style:
                                          TextStyle(color: Colors.deepOrange),
                                    ))
                              ],
                              onChanged: (value) {
                                this.setState(() => lnctu = value);
                              }),
                          TextFormField(
                            onFieldSubmitted: (value) {
                              this.setState(() {
                                bottomPadding = 0;
                              });
                            },
                            validator: (value) {
                              print(value);
                              if (value.isEmpty) {
                                return 'AccSoft id is required!';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: Colors.white54),
                            controller: controller,
                            decoration: InputDecoration(
                                errorStyle: TextStyle(
                                    fontSize: 15, color: Colors.deepOrange),
                                hintText: 'AccSoft ID',
                                hintStyle: TextStyle(color: Colors.white54),
                                icon: Icon(
                                  Icons.account_circle,
                                  color: Color.fromRGBO(255, 206, 162, 1),
                                )),
                            onChanged: (val) => this.setState(() {
                              username = val;
                              msg = '';
                            }),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                              onFieldSubmitted: (value) {
                                this.setState(() {
                                  bottomPadding = 0;
                                });
                              },
                              validator: (value) {
                                print(value);
                                if (value.isEmpty) {
                                  return 'Password is required!';
                                }
                                return null;
                              },
                              obscureText: true,
                              style: TextStyle(color: Colors.white60),
                              decoration: InputDecoration(
                                  errorStyle: TextStyle(
                                      fontSize: 15, color: Colors.deepOrange),
                                  hintStyle: TextStyle(color: Colors.white60),
                                  hintText: 'Password',
                                  icon: Icon(Icons.security,
                                      color: Color.fromRGBO(255, 206, 162, 1))),
                              onChanged: (val) => this.setState(() {
                                    password = val;
                                    msg = '';
                                  })),
                          SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              _launchURL(option: 'forgetPass');
                            },
                            child: Text(
                              'Forget Password?',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.white60),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: 150,
                            height: 40,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0)),
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    color: Color.fromRGBO(66, 92, 90, 1)),
                              ),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  this.login();
                                }
                              },
                              color: Color.fromRGBO(255, 206, 162, 1),
                              textColor: Colors.white,
                              padding: EdgeInsets.fromLTRB(9, 9, 9, 9),
                              splashColor: Colors.grey,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              _launchURL();
                            },
                            child: RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                  text: 'New Student?  ',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white60),
                                ),
                                TextSpan(
                                  text: 'Sign Up',
                                  style: TextStyle(
                                      color: Color.fromRGBO(255, 206, 162, 1)),
                                )
                              ]),
                            ),
                          ),
                          activity(),
                        ],
                      )),
                ),
              ),
            ),
          )),
    );
  }
}
