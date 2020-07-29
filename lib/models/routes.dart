import 'package:demo/screens/temp.dart';
import 'package:flutter/material.dart';
import 'package:demo/screens/charts.dart';
import 'package:demo/screens/datewise.dart';
import 'package:demo/screens/specificDate.dart';
import 'package:demo/screens/subjectWise.dart';
class Routes{
  final String name;
  final IconData icon;
  final Color color;
  final String discription;

  Routes({this.name, this.icon, this.color,this.discription});
  void navigate(BuildContext context,dynamic data){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context){
          return screen(this.name, data);
        }
      )
    );
  }
  
}
// Add routes here for navigation
Widget screen(String name,dynamic data){
    Map screens = {
      'date':DateWise(data:data),
      'subject':SubjectWise(data:data),
      'graph':Chart(data:data),
      'SpecificDate':SpecificDate(data:data),
     
    };
    return screens[name];
  }
// To add a new Item in the home screen just add here and also dont forget to add it in screens function to 
//able to navigate
List<Routes> routes =[
  Routes(
    name:'date',
    icon:Icons.calendar_today,
    color:Colors.deepOrange,
    discription: 'Date Wise Analysis'
  ),
  Routes(
    name:'subject',
    icon:Icons.library_books,
    color:Colors.deepPurple,
    discription: 'Subject Wise Analysis'
  ),
  Routes(
    name:'graph',
    icon:Icons.graphic_eq,
    color:Colors.blue,
    discription: ' Analysis by Graph'
  ),
  Routes(
    name:'SpecificDate',
    icon:Icons.date_range,
    color:Colors.green,
    discription: 'Specific date Analysis'
  ),
  
];
