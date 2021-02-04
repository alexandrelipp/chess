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
  var _options = <Pos>[];
  final _chessBoard = [
    [0, 0, 0, -10, -9, -3, -2, -5],
    [-1, -1, -1, -1, -1, -1, -1, -1],
    [0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 2, 10, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0],
    [1, 1, 1, 1, 1, 1, 1, 1],
    [5, 2, 3, 9, 10, 3, 2, 5]
  ];

  final _pieces = <Piece>[];

  List<Piece> get pieces {
    return [..._pieces];
  }

  //  final _chessBoard = [
  //   [-5, -2, -3, -10, -9, -3, -2, -5],
  //   [-1, -1, -1, -1, -1, -1, -1, -1],
  //   [0, 0, 0, 0, 0, 0, 0, 0],
  //   [0, 0, 0, 0, 0, 0, 0, 0],
  //   [0, 0, 0, 0, 0, 0, 0, 0],
  //   [0, 0, 0, 0, 0, 0, 0, 0],
  //   [1, 1, 1, 1, 1, 1, 1, 1],
  //   [5, 2, 3, 9, 10, 3, 2, 5]
  // ];

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

  void _showOptions(int x, int y, pieceNumber) {
    currentPos = Pos(x, y);
    switch (pieceNumber) {
      case 1:
        _whitePonOptions(x, y);
        break;
      case -1:
        _blackPonOptions(x, y);
        break;
      case 10:
      case -10:
        _kingOptions(x, y);
        break;
      case 2:
      case -2:
        _knightOptions(x, y);
        break;
      default:
    }
    notifyListeners();
    _mode = Mode.options;
  }

  void _moveIfValidOption(int newX, int newY) {
    for (final option in _options) {
      if (option.x == newX && option.y == newY) {
        _chessBoard[currentPos.y][currentPos.x] = 0;

        if (_chessBoard[newY][newX] != 0) {
          //if not 0, means it is a piece capture
          _pieces
              .removeWhere((element) => element.x == newX && element.y == newY);
        }
        print(_pieces.length);
        var pieceIndex = _pieces.indexWhere((element) =>
            element.x == currentPos.x && element.y == currentPos.y);
        _pieces[pieceIndex].change(newX, newY);
        _chessBoard[newY][newX] = _pieces[pieceIndex].type;
        print(_chessBoard);
        _whiteTurn = !_whiteTurn;
        return;
      }
    }
  }

  void press(int x, int y) {
    if (_mode == Mode.blank) {
      var pieceNumber = _chessBoard[y][x];
      if ((_whiteTurn && pieceNumber <= 0) ||
          (!_whiteTurn && pieceNumber >= 0)) {
        return;
      }
      _showOptions(x, y, pieceNumber);
      return;
    }
    if (_mode == Mode.options) {
      _moveIfValidOption(x, y);
      _options.clear();
      notifyListeners();
      _mode = Mode.blank;
    }
  }

  void _addIfLegalOption(int optionX, int optionY) {
    if (_whiteTurn && _chessBoard[optionY][optionX] <= 0) {
      _options.add(Pos(optionX, optionY));
    } else if (!_whiteTurn && _chessBoard[optionY][optionX] >= 0) {
      _options.add(Pos(optionX, optionY));
    }
  }

  void _whitePonOptions(int x, int y) {
    if (_chessBoard[y - 1][x] == 0) {
      _options = [Pos(x, y - 1)];
    }

    if (y == 6 && _chessBoard[4][x] == 0) {
      _options.add(Pos(x, 4));
    }
    if (x > 0 && _chessBoard[y - 1][x - 1] < 0) {
      _options.add(Pos(x - 1, y - 1));
    }
    if (x < 7 && _chessBoard[y - 1][x + 1] < 0) {
      _options.add(Pos(x + 1, y - 1));
    }
  }

  void _blackPonOptions(int x, int y) {
    if (_chessBoard[y + 1][x] == 0) {
      _options = [Pos(x, y + 1)];
    }

    if (y == 1 && _chessBoard[3][x] == 0) {
      _options.add(Pos(x, 3));
    }

    if (x > 0 && _chessBoard[y + 1][x - 1] > 0) {
      _options.add(Pos(x - 1, y + 1));
    }
    if (x < 7 && _chessBoard[y + 1][x + 1] > 0) {
      _options.add(Pos(x + 1, y + 1));
    }
  }

  void _rookOptions(int x,int y){
    
  }

  void _knightOptions(int x, int y) {
    if (x < 6) {
      if (y < 7) {
        _addIfLegalOption(x + 2, y + 1);
      }
      if (y>0){
        _addIfLegalOption(x + 2, y - 1);
      }
    }
     if (x > 1) {
      if (y < 7) {
        _addIfLegalOption(x - 2, y + 1);
      }
      if (y>0){
        _addIfLegalOption(x - 2, y - 1);
      }
    }
     if (y > 1) {
      if (x < 7) {
        _addIfLegalOption(x + 1, y - 2);
      }
      if (x>0){
        _addIfLegalOption(x - 1, y - 2);
      }
    }
    if (y < 6) {
      if (x < 7) {
        _addIfLegalOption(x + 1, y + 2);
      }
      if (x>0){
        _addIfLegalOption(x - 1, y + 2);
      }
    }
    
  }

  void _kingOptions(int x, int y) {
    //these 4 final are to exclude possibilities when the king is on the edge of the board
    final lowerX = x > 0 ? -1 : 0;
    final uppperX = x < 7 ? 1 : 0;
    final lowerY = y > 0 ? -1 : 0;
    final upperY = y < 7 ? 1 : 0;
    for (var i = lowerX; i <= uppperX; i++) {
      for (var j = lowerY; j <= upperY; j++) {
        if (!(i == 0 && j == 0)) {
          _addIfLegalOption(x + i, y + j);
        }
      }
    }
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

//  for (final option in _options) {
//         if (option.x == x && option.y == y) {
//           _chessBoard[currentPos.y][currentPos.x] = 0;

//           if (_chessBoard[y][x] != 0) {
//             _pieces.removeWhere((element) => element.x == x && element.y == y);
//           }
//           print(_pieces.length);
//            var pieceIndex = _pieces.indexWhere((element) =>
//               element.x == currentPos.x && element.y == currentPos.y);
//           _pieces[pieceIndex].change(x, y);
//           _chessBoard[y][x] = _pieces[pieceIndex].type;
//           print(_chessBoard);
//           //notifyListeners();
//           _whiteTurn = !_whiteTurn;
//           break;
//         }
//       }
