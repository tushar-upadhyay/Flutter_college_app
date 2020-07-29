import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:demo/urls/urls.dart';
class DateAttendance {
  final DateTime date;
  final double attendance;
  DateAttendance({this.attendance, this.date});
}

dynamic fetch(String url, String username, String password, String lnctu)async {
  try{
  url = url + 'username=$username' + '&password=$password' + '&token=&';
  if (lnctu == 'true') {
    url = url + 'lnctu';
  }
  dynamic res =  await http.get(url);
  res = await jsonDecode(res.body);
  return res;
  }
  catch(err){
    return throw new Exception('error');
  }
}

dynamic login(String username, String password, String lnctu) async{
  return await fetch(loginUrl, username, password, lnctu);
}
dynamic attendance(String username, String password, String lnctu) async{
  return await  fetch(attendanceUrl, username, password, lnctu);
}

dynamic datewise(String username, String password, String lnctu) async{
  return await  fetch(dateWiseUrl, username, password, lnctu);
}

dynamic sunjectwise(String username, String password, String lnctu) async {
  return await fetch(sujectWiseUrl, username, password, lnctu);
}

dynamic getdatewiseattendance(String username, String password, String lnctu)async {
  return await  fetch(getAttendaceDateWiseUrl, username, password, lnctu);
}
