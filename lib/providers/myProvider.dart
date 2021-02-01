import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum Mode {
  blank,
  options,
}

class MyProvider with ChangeNotifier {
  //1 pon 2 knight, 3 bishop 5 rook 9 queen 10 king +white -black
  Pos currentPos;
  var _mode = Mode.blank;
  var _whiteTurn = true;
  var _options = [];
  final _chessBoard = [
    [-5, -2, -3, -10, -9, -3, -2, -5],
    [-1, -1, -1, -1, -1, -1, -1, -1],
    [0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0],
    [1, 1, 1, 1, 1, 1, 1, 1],
    [5, 2, 3, 9, 10, 3, 2, 5]
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

  get options {
    return _options;
  }

  void move(int x, int y) {
    if (_mode == Mode.blank) {
      var pieceNumber = _chessBoard[y][x];
      if ((_whiteTurn && pieceNumber <= 0) ||
          (!_whiteTurn && pieceNumber >= 0)) {
        return;
      }
      currentPos = Pos(x, y);
      switch (pieceNumber) {
        case 1:
          _whitePonMove(x, y);
          break;
        case -1:
          _blackPonMove(x, y);
          break;
        default:
      }
      notifyListeners();
      _mode = Mode.options;
      return;
    }
    if (_mode == Mode.options) {
      for (final option in _options) {
        if (option.x == x && option.y == y) {
          _chessBoard[currentPos.y][currentPos.x] = 0;
          var pieceIndex = _pieces.indexWhere((element) =>
              element.x == currentPos.x && element.y == currentPos.y);
          if (_chessBoard[y][x] != 0) {
            //if not 0, means it was a capture
            // _pieces
            //     .firstWhere((element) => element.x == x && element.y == y)
            //     .type = 0;
            _pieces.removeWhere((element) => element.x == x && element.y == y);
          }
          print(_pieces.length);
          _pieces[pieceIndex].change(x, y);
          _chessBoard[y][x] = _pieces[pieceIndex].type;
          print(_chessBoard);
          notifyListeners();
          _whiteTurn = !_whiteTurn;
          break;
        }
      }
      _options.clear();
      notifyListeners();
      _mode = Mode.blank;

      return;
    }
  }

  void _whitePonMove(int x, int y) {
    _options = [Pos(x, y - 1)];
    if (y == 6 && _chessBoard[4][x] == 0) {
      _options.add(Pos(x, 4));
    }
    if (_chessBoard[y - 1][x - 1] < 0) {
      _options.add(Pos(x - 1, y - 1));
    }
    if (_chessBoard[y - 1][x + 1] < 0) {
      _options.add(Pos(x + 1, y - 1));
    }
  }

  void _blackPonMove(int x, int y) {
    _options = [Pos(x, y + 1)];
    if (y == 1 && _chessBoard[3][x] == 0) {
      _options.add(Pos(x, 3));
    }
    if (_chessBoard[y + 1][x - 1] > 0) {
      _options.add(Pos(x - 1, y + 1));
    }
    if (_chessBoard[y + 1][x + 1] > 0) {
      _options.add(Pos(x + 1, y + 1));
    }
  }

  final _pieces = <Piece>[];
  get pieces {
    return [..._pieces];
  }
}

class Piece {
  int type;
  int x;
  int y;

  void change(int x, int y) {
    this.x = x;
    this.y = y;
  }

  Piece(this.type, this.x, this.y);
}

class Pos {
  final int x;
  final int y;

  Pos(this.x, this.y);
}
