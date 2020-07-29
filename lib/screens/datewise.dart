import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:demo/models/attendanceModel.dart';
import 'package:demo/widgets/blockLoader.dart';
import 'package:demo/utils/months.dart';

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
  String to;
  String from;
  bool error;
  bool isDisposed = false;
  int fromIndex;
  int toEnd;
  List<DropdownMenuItem> dates = [];
  _DateWiseState(this.username, this.password, this.lnctu);
  void search(DateTime date) {
    // String fromPre = from;
    // String toPre = to;
    String month = months[date.month - 1];
    String day = date.day.toString();
    String year = date.year.toString();
    String final_date = '$day $month $year';
    bool isFound = false;
    List temp = [];
    for (var i in data[0]) {
      if (i['date'] == final_date) {
        isFound = true;
        from = final_date;
        to = final_date;
        temp.add(i);
        break;
      }
    }
    if (isFound) {
      setState(() {
        initialData = temp;
      });
    }
    if (!isFound) {
      showDialog(
          context: context,
          builder: (_) {
            return CupertinoAlertDialog(
              title: Text('Date not Found'),
              actions: <Widget>[
                FlatButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Close',
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            );
          });
    }
  }

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

    setState(() {
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
            backgroundColor: ThemeData.dark().primaryColor,
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
          backgroundColor: ThemeData.dark().primaryColorDark,
          floatingActionButton: GestureDetector(
            onTap: () async {
              try {
                dynamic date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2019, 8),
                  lastDate: DateTime(2030, 10),
                );
                search(date);
              } catch (err) {
                print('err');
              }
            },
            child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.deepOrange),
                height: 60,
                width: 60,
                child: Center(
                    child: FaIcon(
                  FontAwesomeIcons.search,
                  color: Colors.white,
                  size: 20,
                ))),
          ),
          appBar: AppBar(title: Text('Date Wise Analysis'), actions: <Widget>[
            GestureDetector(
              onTap: () {
                this.setState(() {
                  initialData = List.from(initialData.reversed);
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Icon(FontAwesomeIcons.exchangeAlt),
              ),
            ),
            GestureDetector(
              onTap: () {
                this.setState(() {
                  from = data[0][0]['date'];
                  to = data[1][0]['date'];
                  initialData = data[0];
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Icon(Icons.refresh),
              ),
            ),
          ]),
          body: Column(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  width: MediaQuery.of(context).size.width,
                  // color: Colors.white,
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
                              horizontal: w > 600 ? w / 4 : 15, vertical: 10),
                          padding: EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                              color: ThemeData.dark().canvasColor,
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  initialData[index]['date'],
                                  style: TextStyle(
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
            from = value;
          } else {
            to = value;
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
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Text(
              heading,
              softWrap: true,
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
