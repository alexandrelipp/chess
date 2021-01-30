import 'package:flutter/material.dart';
import '../widgets/background.dart';

class ChessScreen extends StatefulWidget {
  static const routeName = '/chessScreen';
  

  
  @override
  _ChessScreenState createState() => _ChessScreenState();
}

class _ChessScreenState extends State<ChessScreen> {
   double _screenWidth;


  @override
  void didChangeDependencies() {
    _screenWidth=MediaQuery.of(context).size.width;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chess'),
      ),
      body: Center(child: BackGround(_screenWidth),),
    );
  }
}
