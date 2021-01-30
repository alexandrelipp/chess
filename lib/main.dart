import 'package:chess/screens/chessScreen.dart';
import 'package:chess/screens/menuScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/myProvider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyProvider>(
      create: (context) => MyProvider(),
          child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: ChessScreen(),
        routes: {
          ChessScreen.routeName: (ctx)=>ChessScreen(),
        },
      ),
    );
  }
}
