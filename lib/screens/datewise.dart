import 'package:flutter/material.dart';
import 'package:demo/models/attendanceModel.dart';
import 'package:demo/widgets/blockLoader.dart';

class DateWise extends StatefulWidget {
  final Map data;
  DateWise({this.data});
  @override
  _DateWiseState createState() =>
      _DateWiseState(data['username'], data['password'], data['lnctu']);
}

class _DateWiseState extends State<DateWise> {
  List<String> litems = ["1", "2", "Third", "4"];
  final username;
  final password;
  final lnctu;
  bool isLoading;
  dynamic data;
  dynamic initialData;
  String from;
  String to;
  bool error;
  bool isDisposed = false;
  int fromIndex;
  int toEnd;
  List<DropdownMenuItem> dates = [];

  _DateWiseState(this.username, this.password, this.lnctu);
  void setDatesRange() {
    bool start = false;
    List temp = [];
    for (var i in data[0]) {
      if (i['date'] == from) {
        start = true;
      }
      if (start) {
        temp.add(i);
      }
      if (i['date'] == to) {
        break;
      }
    }

    this.setState(() {
      initialData = temp;
    });
  }

  void load() async {
    try {
      try {
        dynamic res = await datewise(username, password, lnctu);
        if (isDisposed) {
          return;
        }
        this.setState(() {
          isLoading = false;
          data = res;
          initialData = res[0];
          for (var i in initialData) {
            if (from == null) {
              from = i['date'].toString();
            }

            dates.add(DropdownMenuItem(
                value: i['date'],
                child: Center(
                    child: Text(
                  i['date'].toString(),
                  textAlign: TextAlign.center,
                ))));
          }
          to = res[1][0]['date'].toString();
        });
      } catch (err) {
        this.setState(() {
          isLoading = false;
          error = true;
        });
      }
    } catch (err) {
      print('erro');
    }
  }

  @override
  void initState() {
    super.initState();
    isLoading = true;
    error = false;
    load();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    if (isLoading) {
      return Hero(
        tag: 'date',
        transitionOnUserGestures: true,
        child: Scaffold(
            appBar: AppBar(title: Text('Date wise Analysis')),
            body: BlockLoader()),
      );
    }
    if (error) {
      return Hero(
        tag: 'date',
        child: Scaffold(
            appBar: AppBar(title: Text('Date wise Analysis')),
            body: Center(
                child: Icon(
              Icons.error,
              color: Colors.red,
              size: 60,
            ))),
      );
    }
    return Hero(
        tag: 'date',
        child: Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text('Date Wise Analysis'),
        actions: <Widget>[
          FlatButton.icon(
            onPressed: () {
              this.setState(() {
                initialData = List.from(initialData.reversed);
              });
            },
            icon: Icon(Icons.filter_list),
            label: Text(
              'Reverse',
              style: TextStyle(letterSpacing: 1.2, fontSize: 17),
            ),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
              margin: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
              padding: EdgeInsets.symmetric(vertical: 10),
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    dropDownDates(dates, "from"),
                    dropDownDates(dates, "to")
                  ])),
          Expanded(
            child: new ListView.builder(
                itemCount: initialData.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed('/specificDate', arguments: index);
                    },
                    child: new Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: w>600?w/4:15, vertical: 10),
                      padding: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              initialData[index]['date'],
                              style: TextStyle(
                                  color: Colors.black38,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.1,
                                  fontSize: 18),
                            ),
                            attendanceWrapper(initialData[index]['data'])
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      )),
      );
  }

  Widget dropDownDates(List date, String selector) {
    List<DropdownMenuItem> refdate;
    refdate = date;
    if (selector == 'to') {
      refdate = new List.from(date.reversed);
    }

    return DropdownButton(
        isExpanded: false,
        isDense: false,
        hint: Text(selector),
        value: selector == 'to' ? to : from,
        icon: Icon(Icons.date_range),
        items: refdate,
        onChanged: (dynamic value) {
          if (selector == 'from') {
            this.setState(() {
              from = value;
            });
          } else {
            this.setState(() {
              to = value;
            });
          }
          setDatesRange();
        });
  }

  Widget attendanceWrapper(List dataa) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: dataa.length,
        padding: EdgeInsets.symmetric(vertical: 10),
        physics: new NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext ctx, int index) {
          return attendance(dataa[index]);
        });
  }

  Widget attendance(dynamic d) {
   
    String heading;
    String value;
    d.forEach((key, val) {
      heading = key;
      value = val;
    });

    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
                      child: Text(
              heading,
              softWrap:true ,
                // overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 15),
            ),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}
