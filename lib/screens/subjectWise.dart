import 'package:flutter/material.dart';
import 'package:demo/models/attendanceModel.dart';
import 'package:demo/widgets/blockLoader.dart';
class SubjectWise extends StatelessWidget {
  final Map data;
  SubjectWise({this.data});
  final List<String> litems = ["1", "2", "Third", "4"];
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'subject',
      transitionOnUserGestures: true,
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(title: Text('Subject Wise Analysis')),
        body: FutureBuilder(
          future:
              sunjectwise(data['username'], data['password'], data['lnctu']),
          builder: (context, snapshot) {
            
             if(snapshot.hasError){
              return  Center(child: Icon(Icons.error,color: Colors.red,size: 60,));
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return returnData(snapshot.data);
            }
             else {
               return BlockLoader();
              // return Center(child:SpinKitFadingFour(color: Colors.blueAccent));
            }
          },
        ),
      ),
    );
  }

  Widget attendance(String heading, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            heading,
            style: TextStyle(fontSize: 16),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }

  Widget returnData(dynamic data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return new Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            padding: EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text(
                    data[index]['Subject'],
                    style: TextStyle(
                        color: Colors.black38,
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  attendance(
                      "Percentage", data[index]['Percentage'].toString() + '%'),
                  SizedBox(
                    height: 20,
                  ),
                  attendance("Total Lectures",
                      data[index]['TotalLectures'].toString()),
                  SizedBox(
                    height: 20,
                  ),
                  attendance("Present", data[index]['Present'].toString()),
                ],
              ),
            ),
          );
        });
  }
}
