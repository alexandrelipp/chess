import 'package:chess/constants.dart';
import 'package:flutter/material.dart';

class BackGround extends StatelessWidget {
  final double screenSize;
  final double squareSize;

  BackGround(this.screenSize) : this.squareSize = (screenSize / 8).truncateToDouble();

  Widget buildRow(bool even) {
    return Row(
      children: [
        for (var i = 0; i < 8; i++)
          Container(
            width: squareSize,
            height: squareSize,
            color:
                i % 2 == (even ? 0 : 1) ? kLightSquareColor : kDarkSquareColor,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //   border: Border.symmetric(
      //     //horizontal: BorderSide(width: 1, color: Colors.black),
      //   ),
      // ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [for (var i = 0; i < 8; i++) buildRow(i % 2 == 0)],
      ),
    );
  }
}
