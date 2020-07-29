import 'package:flutter/material.dart';

class ResultView extends StatefulWidget {
  final Map data;

  const ResultView({Key key, this.data}) : super(key: key);
  @override
  _ResultViewState createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeData.dark().primaryColor,
      appBar: AppBar(title: Text('Result')),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Image.asset(
                      'assets/rgpv_logo.png',
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
                Center(
                    child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 35, vertical: 30),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ThemeData.dark().canvasColor),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Text(
                          widget.data['name'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Text('SGPA ${widget.data['SGPA']}',
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Text('CGPA ${widget.data['CGPA']}',
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16)),
                      ),
                    ],
                  ),
                )),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Container(
                      width: 300,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: ThemeData.dark().canvasColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: widget.data['subjects'].length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                      widget.data['subjects'][index]['subject'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17)),
                                  Text(widget.data['subjects'][index]['grade'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17)),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Divider(
                                  color: Colors.black,
                                  thickness: 0.1,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
