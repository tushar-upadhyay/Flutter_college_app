import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:demo/models/attendanceModel.dart';
import 'package:demo/utils/methods.dart';

class Chart extends StatefulWidget {
  final data;
  Chart({this.data});
  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  List datas;
  bool error = false;
  bool loading = false;
  loadData() async {
    try {
      dynamic res = await getdatewiseattendance(widget.data['username'],
          widget.data['password'], widget.data['lnctu']);
      datas = res;
      getMonthsArray(res);
      setState(() {
        error = false;
        loading = false;
      });
    } catch (err) {
      setState(() {
        error = true;
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loading = true;
    loadData();
  }

  List months = [];
  void getMonthsArray(List data) {
    for (int i = 0; i < data.length; i++) {
      String date = data[i]['date'];
      date = date.split(' ')[1];
      if (months.length == 0) {
        months.add(date);
      } else {
        if (date != months[months.length - 1]) {
          months.add(date);
        }
      }
    }
  }

  bool showAvg = false;

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
              size: 50,
            ),
          ),
        ),
      );
    return Hero(
      tag: 'graph',
      child: SafeArea(
        child: Scaffold(
            backgroundColor: ThemeData.dark().primaryColor,
            appBar: AppBar(
              title: Text('Analysis by Graph'),
            ),
            body: error
                ? Center(
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
                              setState(() {
                                loading = true;
                                error = false;
                              });
                              loadData();
                            },
                            icon: Icon(Icons.refresh),
                            label: Text('Refresh'))
                      ],
                    ),
                  )
                : Stack(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 100),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(18),
                            ),
                            color: Color(0xff232d37)),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 18.0, left: 12.0, top: 24, bottom: 12),
                          child: LineChart(
                            mainData(),
                          ),
                        ),
                      ),
                    ],
                  )),
      ),
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: false,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            return months[value.toInt()];
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            int rem = value.toInt() % 25;
            return '${rem == 0 ? value : ""}';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: (months.length - 1).toDouble(),
      minY: 0,
      maxY: 100,
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(
              datas.length,
              (int index) => FlSpot(
                  map(
                      inputlo: 0,
                      inputhi: datas.length.toDouble(),
                      outputlo: 0,
                      outputhi: months.length.toDouble() - 1,
                      val: index.toDouble()),
                  datas[index]['percentage'])),
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }
}
