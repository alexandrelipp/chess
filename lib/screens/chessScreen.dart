import 'package:chess/providers/myProvider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../widgets/background.dart';

class ChessScreen extends StatefulWidget {
  static const routeName = '/chessScreen';

  @override
  _ChessScreenState createState() => _ChessScreenState();
}

class _ChessScreenState extends State<ChessScreen> {
  Image _blackKing;
  ColorFiltered _whiteKing;
  Image _blackKnight;
  ColorFiltered _whiteKnight;
  Image _blackPon;
  ColorFiltered _whitePon;
  Image _whiteBishop;
  ColorFiltered _blackBishop;
  Image _whiteQueen;
  ColorFiltered _blackQueen;
  Image _whiteRook;
  ColorFiltered _blackRook;

  double _screenWidth;
  double _squareSize;
  var _isInit = false;

  Image _image(String path) {
    return Image.asset(
      path,
      width: _squareSize,
      height: _squareSize,
    );
  }

  ColorFiltered _inversedImage(Image child) {
    return ColorFiltered(
      colorFilter: ColorFilter.matrix([
        -1, //RED
        0,
        0,
        0,
        255, //GREEN
        0,
        -1,
        0,
        0,
        255, //BLUE
        0,
        0,
        -1,
        0,
        255, //ALPHA
        0,
        0,
        0,
        1,
        0,
      ]),
      child: child,
    );
  }

  void _initImages() {
    _blackKing = _image('assets/blackKing.png');
    _whiteKing = _inversedImage(_blackKing);
    _blackKnight = _image('assets/blackKnight.png');
    _whiteKnight = _inversedImage(_blackKnight);
    _blackPon = _image('assets/blackPon.png');
    _whitePon = _inversedImage(_blackPon);
    _whiteBishop = _image('assets/whiteBishop.png');
    _blackBishop = _inversedImage(_whiteBishop);
    _whiteQueen = _image('assets/whiteQueen.png');
    _blackQueen = _inversedImage(_whiteQueen);
    _whiteRook = _image('assets/whiteRook.png');
    _blackRook = _inversedImage(_whiteRook);
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      _screenWidth = MediaQuery.of(context).size.width;
      _squareSize = (_screenWidth / 8).floorToDouble();
      _initImages();
      context.read<MyProvider>().initPieces();
      _isInit = true;
    }

    super.didChangeDependencies();
  }

  Widget drawPiece(int n){
    switch (n) {
      case 1:
        return _whitePon;
        break;
      case 2:
        return _whiteKnight;
        break;
      case 3:
        return _whiteBishop;
        break;
      case 5:
        return _whiteRook;
        break;
      case 9:
        return _whiteQueen;
        break;
      case 10:
        return _whiteKing;
        break;
      case -1:
        return _blackPon;
        break;
      case -2:
        return _blackKnight;
        break;
      case -3:
        return _blackBishop;
        break;
      case -5:
        return _blackRook;
        break;
      case -9:
        return _blackQueen;
        break;
      case -10:
        return _blackKing;
        break;
      
      default:
        return Text('ok');
    }
  }

  @override
  Widget build(BuildContext context) {
    final _pieces = context.watch<MyProvider>().pieces;
    final test = _pieces
        .map(
          (piece) => Positioned(
            left: _squareSize*piece.x,
            top: _squareSize*piece.y,
            child: drawPiece(piece.type),
          ),
        )
        .toList();
    print(_pieces);
    return Scaffold(
      appBar: AppBar(
        title: Text('Chess'),
      ),
      body: Center(
        child: Stack(children: [
          BackGround(_screenWidth),
          ...test
        ]),
      ),
    );
  }
}
//
// Positioned(child: _whiteRook),
// Positioned(
//   left: _squareSize,
//   child: _whiteKnight,
// ),
// Positioned(
//   left: 2 * _squareSize,
//   child: _whiteBishop,
// ),
// Positioned(
//   left: 3 * _squareSize,
//   child: _whiteKing,
// ),
// Positioned(
//   left: 4 * _squareSize,
//   child: _whiteQueen,
// ),
// Positioned(
//   top: _squareSize,
//   child: _whitePon,
// ),
// Positioned(top: 7 * _squareSize, child: _blackRook),
// Positioned(
//   top: 7 * _squareSize,
//   left: _squareSize,
//   child: _blackKnight,
// ),
// Positioned(
//   top: 7 * _squareSize,
//   left: 2 * _squareSize,
//   child: _blackBishop,
// ),
// Positioned(
//   top: 7 * _squareSize,
//   left: 3 * _squareSize,
//   child: _blackKing,
// ),
// Positioned(
//   top: 7 * _squareSize,
//   left: 4 * _squareSize,
//   child: _blackQueen,
// ),
// Positioned(
//   top: 6 * _squareSize,
//   child: _blackPon,
// ),
