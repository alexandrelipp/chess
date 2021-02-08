import 'package:flutter/material.dart';
import './chessScreen.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  var _isSelected = [true, false];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to the next-gen chess game!'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          Center(
            child: ToggleButtons(
              selectedColor: Colors.red,
              //fillColor: Colors.blue,
              disabledColor: Colors.blue,
              children: [
                Container(
                  width: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person),
                      Text('One Player'),
                    ],
                  ),
                ),
                Container(
                  width: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person),
                      Icon(Icons.person),
                      Text('Two Player'),
                    ],
                  ),
                ),
              ],
              isSelected: _isSelected,
              onPressed: (index) {
                setState(
                  () {
                    _isSelected[0] = !_isSelected[0];
                    _isSelected[1] = !_isSelected[1];
                  },
                );
              },
            ),
          ),
          Spacer(),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed(ChessScreen.routeName);
            },
            
          )
        ],
      ),
    );
  }
}
