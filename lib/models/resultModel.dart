import 'dart:convert';
import 'package:http/http.dart' as http;
dynamic fetchResult(String enrollment, String semester, String stream)async {
  String url = 'https://newlnct.herokuapp.com/api?rollno=$enrollment&semester=$semester';
  try{
  dynamic res =  await http.get(url);
  res = await jsonDecode(res.body);
  return res;
  }
  catch(err){
    return throw new Exception('error');
  }
}