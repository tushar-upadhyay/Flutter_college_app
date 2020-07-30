import 'package:flutter/material.dart';
import 'package:demo/models/routes.dart';

class Item extends StatelessWidget {
  final int id;
  final Map data;
  Item({this.id, this.data});
  @override
  Widget build(BuildContext context) {
    Routes route = routes[id];
    double h = MediaQuery.of(context).size.height;
    return Hero(
      tag: route.name,
      child: Material(
        child: InkWell(
          onTap: () => route.navigate(context),
          child: tiles(
              context,
              route.color,
              Icon(
                route.icon,
                color: route.color,
                size: 0.047 * h,
              ),
              route.discription,
              route.name),
        ),
      ),
    );
  }

  Widget tiles(
    BuildContext context,
    Color color,
    Icon icon,
    String text,
    String tag,
  ) {
    double h = MediaQuery.of(context).size.height;
    return Ink(
      height: 0.1763 * h,
      width: MediaQuery.of(context).size.width * 0.4,
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 0.0294 * h),
            child: icon,
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 0.0353 * h, left: 5, right: 5),
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.white),
                )),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  color: color,
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: 2))
        ],
      ),
    );
  }
}
