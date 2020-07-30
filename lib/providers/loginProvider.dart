import 'dart:convert';
import 'package:demo/urls/urls.dart';
import 'package:http/http.dart' as http;

class LoginProvider {
  Map data;
  LoginProvider(this.data);
  dynamic fetch(String url) async {
    try {
      url = url +
          'username=${data['username']}' +
          '&password=${data['password']}' +
          '&token=&';
      if (data['lnctu'] == 'true') {
        url = url + 'lnctu';
      }
      dynamic res = await http.get(url);
      res = await jsonDecode(res.body);
      return res;
    } catch (err) {
      return throw new Exception('error');
    }
  }

  void setGender(gender) {
    data['gender'] = gender;
  }

  dynamic login(String username, String password, String lnctu) async {
    String url = loginUrl;
    try {
      url = url + 'username=$username' + '&password=$password' + '&token=&';
      if (lnctu == 'true') {
        url = url + 'lnctu';
      }
      dynamic res = await http.get(url);
      res = await jsonDecode(res.body);
      data = {
        'name': res['Name'],
        'imageUrl': res['ImageUrl'],
        'username': username,
        'password': password,
        'lnctu': lnctu,
        'branch': res['Branch'],
        'semester': res['Semseter'],
        'gender': res['Gender']
      };
      return res;
    } catch (err) {
      print(err);
      return throw new Exception('error');
    }
  }

  dynamic attendance() async {
    return await fetch(attendanceUrl);
  }

  dynamic datewise() async {
    return await fetch(dateWiseUrl);
  }

  dynamic sunjectwise() async {
    return await fetch(sujectWiseUrl);
  }

  dynamic getdatewiseattendance() async {
    return await fetch(getAttendaceDateWiseUrl);
  }
}
