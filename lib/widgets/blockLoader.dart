import 'dart:math';

import 'package:flutter/material.dart';

class BlockLoader extends StatefulWidget {
  @override
  _BlockLoaderState createState() => _BlockLoaderState();
}

class _BlockLoaderState extends State<BlockLoader>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: List.generate(4, (int index) => listItems()));
  }

  Widget tile() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: 15,
            color: Colors.grey[300],
            width: 100,
          ),
          Container(
            height: 15,
            color: Colors.grey[300],
            width: 20,
          )
        ],
      ),
    );
  }

  Widget listItems() {
    return AnimatedBuilder(
        animation: _animationController,
        builder: (_, __) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Container(
              decoration: decoration(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Container(
                      height: 15,
                      decoration: BoxDecoration(
                          gradient: RadialGradient(
                              colors: [Colors.grey[100], Colors.grey[200]],
                              stops: [0, _animationController.value])),
                      width: 40,
                    ),
                  ),
                  tile(),
                  tile(),
                  tile()
                ],
              ),
            ),
          );
        });
  }

  Decoration decoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      gradient: LinearGradient(transform: GradientRotation(pi / 4.5), colors: [
        Colors.white,
        Colors.grey[200],
      ], stops: [
        0,
        _animationController.value
      ]),
    );
  }
}
