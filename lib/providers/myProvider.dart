import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyProvider with ChangeNotifier {
  //1 pon 2 knight, 3 bishop 5 rook 9 queen 10 king +white -black
  final _chessBoard = [
    [5, 2, 3, 10, 9, 3, 2, 5],
    [1, 1, 1, 1, 1, 1, 1, 1],
    [0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0],
    [-1, -1, -1, -1, -1, -1, -1, -1],
    [-5, -2, -3, -9, -10, -3, -2, -5]
  ];

  void initPieces() {
    for (var i = 0; i < 8; i++) {
      for (var j = 0; j < 8; j++) {
        if (_chessBoard[j][i] != 0) {
          _pieces.add(Piece(_chessBoard[j][i], i, j));
        }
      }
    }
  }

  final _pieces = <Piece>[];
  get pieces {
    return [..._pieces];
  }
}

class Piece {
  final int type;
  int x;
  int y;

  Piece(this.type, this.x, this.y);
}
