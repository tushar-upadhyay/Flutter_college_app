
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:demo/models/attendanceModel.dart';

class Chart extends StatefulWidget {
  final Map data;

  const Chart({Key key, this.data}) : super(key: key);

  @override
  _ChartState createState() => _ChartState(data['username'], data['password'], data['lnctu']);
}

class _ChartState extends State<Chart> {
  final username;
  final password;
  final lnctu;
  final numrictik = charts.BasicNumericTickProviderSpec();
  dynamic seriesList;
  bool loading;

  _ChartState(this.username, this.password, this.lnctu);
  void loadData() async {
    try{
    dynamic res = await getdatewiseattendance(username, password, lnctu);
    List<DateAttendance> data = [];
    Map years = {
      'Jan': 1,
      'Feb': 2,
      'Mar': 3,
      'Apr': 4,
      'May': 5,
      'Jun': 6,
      'Jul': 7,
      'Aug': 8,
      'Sep': 9,
      'Oct': 10,
      'Nov': 11,
      'Dec': 12
    };
    //  List <DateAttendance> data= [];
    //  data.add(DateAttendance(date: DateTime()))
    for (var x in res) {
      List info = x['date'].toString().split(" ");
      data.add(DateAttendance(
          date:
              DateTime(int.parse(info[2]), years[info[1]], int.parse(info[0])),
          attendance: x['percentage']));
    }
    seriesList = [
      charts.Series(
          id: 'Attendance',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (DateAttendance attendance, _) => attendance.date,
          measureFn: (DateAttendance attendance, _) => attendance.attendance,
          data: data)
    ];
    
    setState(() => loading = false);
    }
    catch(err){
      return ;
    }
  }

  @override
  void initState() {
    super.initState();
    loading = true;
    loadData();
  }
 
  @override
  Widget build(BuildContext context) {
    
    if (loading)
      return Hero(
        tag: 'graph',
              child: Scaffold(
          appBar: AppBar(title: Text('Analysis by Graph')),
          body: Center(
            child: SpinKitCircle(
              color: Colors.blue,
              size:50,
            ),
          ),
        ),
      );
    return Hero(
      tag:'graph',
          child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Analysis by Graph'),
          ),
          body: Container(
            color: Colors.blueGrey[100],
            constraints:
                BoxConstraints.expand(height: MediaQuery.of(context).size.height),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Container(
                        height:500,
                        child: charts.TimeSeriesChart(
                          seriesList,

                          primaryMeasureAxis: charts.NumericAxisSpec(
                              showAxisLine: false,
                              tickProviderSpec:
                                  charts.StaticNumericTickProviderSpec([
                                charts.TickSpec(0),
                                charts.TickSpec(30),
                                charts.TickSpec(50),
                                charts.TickSpec(60),
                                charts.TickSpec(75),
                                charts.TickSpec(100)
                              ])),
                          domainAxis: new charts.DateTimeAxisSpec(
                            tickProviderSpec:
                                charts.DayTickProviderSpec(increments: [10]),
                            showAxisLine: false,
                          ),
                          dateTimeFactory: const charts.LocalDateTimeFactory(),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text('Date Wise Trends of your attendance',
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                                fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


}

/// Sample time series data type.
