import 'dart:ffi';

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
  int _enPassant=100;//100 means enPassant is not available
  final _canCastle = {
    'blackLong': true,
    'blackShort': true,
    'whiteLong': true,
    'whiteShort': true,
  };
  var _options = <Pos>[];
  final _chessBoard = [
    [-5, -0, 0, 0, -10, 0, 0, -5],
    [-1, -1, -1, -1, -1, -1, -1, -1],
    [0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0],
    [1, 1, 1, 1, 1, 1, 1, 1],
    [5, 0, 0, 0, 10, 0, 0, 5]
  ];
  // final _chessBoard = [
  //   [-5, -2, -3, -9, -10, -3, -2, -5],
  //   [-1, -1, -1, -1, -1, -1, -1, -1],
  //   [0, 0, 0, 0, 0, 0, 0, 0],
  //   [0, 0, 0, 0, 0, 0, 0, 0],
  //   [0, 0, 0, 0, 0, 0, 0, 0],
  //   [0, 0, 0, 0, 0, 0, 0, 0],
  //   [1, 1, 1, 1, 1, 1, 1, 1],
  //   [5, 2, 3, 9, 10, 3, 2, 5]
  // ];
  final _pieces = <Piece>[];

  List<Piece> get pieces {
    return [..._pieces];
  }

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
      case 5:
      case -5:
        _rookOptions(x, y);
        break;
      case 3:
      case -3:
        _bishopOptions(x, y);
        break;
      case 9:
      case -9:
        _rookOptions(x, y);
        _bishopOptions(x, y);
        break;
      default:
    }
    notifyListeners();
    _mode = Mode.options;
  }

  void _moveRookIfCastle(int x, int y) {
    if (_whiteTurn && _canCastle['whiteLong'] && x == 2 && y == 7) {
      _chessBoard[7][0] = 0;
      _chessBoard[7][3] = 5;
      _pieces.firstWhere((element) => element.x == 0 && element.y == 7).x = 3;
      return;
    }
    if (_whiteTurn && _canCastle['whiteShort'] && x == 6 && y == 7) {
      _chessBoard[7][7] = 0;
      _chessBoard[7][5] = 5;
      _pieces.firstWhere((element) => element.x == 7 && element.y == 7).x = 5;
      return;
    }
    if (!_whiteTurn && _canCastle['blackLong'] && x == 2 && y == 0) {
      _chessBoard[0][0] = 0;
      _chessBoard[0][3] = -5;
      _pieces.firstWhere((element) => element.x == 0 && element.y == 0).x = 3;
      return;
    }
    if (!_whiteTurn && _canCastle['blackShort'] && x == 6 && y == 0) {
      _chessBoard[0][7] = 0;
      _chessBoard[0][5] = -5;
      _pieces.firstWhere((element) => element.x == 7 && element.y == 0).x = 5;
      return;
    }
  }

  void _removeCastleRightKing() {
    if (_whiteTurn) {
      _canCastle['whiteLong'] = false;
      _canCastle['whiteShort'] = false;
      return;
    }
    _canCastle['blackLong'] = false;
    _canCastle['blackShort'] = false;
  }

  void _removeCastleRightRook() {
    if (_whiteTurn && currentPos.x == 0 && currentPos.y == 7) {
      _canCastle['whiteLong'] = false;
      return;
    }
    if (_whiteTurn && currentPos.x == 7 && currentPos.y == 7) {
      _canCastle['whiteShort'] = false;
      return;
    }
    if (!_whiteTurn && currentPos.x == 0 && currentPos.y == 0) {
      _canCastle['blackLong'] = false;
      return;
    }
    if (!_whiteTurn && currentPos.x == 7 && currentPos.y == 0) {
      _canCastle['blackShort'] = false;
      return;
    }
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

        final piece = _pieces.firstWhere((element) =>
            element.x == currentPos.x && element.y == currentPos.y);
        piece.change(newX, newY);
        //if a king is the piece moving, may need to castle(move the rook as well)
        if (piece.type.abs() == 10) {
          _moveRookIfCastle(newX, newY);
          _removeCastleRightKing();
        }
        //if a rook is the piece moving, may need to remove castle right
        if (piece.type.abs() == 5) {
          _removeCastleRightRook();
        }
        

        //pon promotion
        if ([1, -1].contains(piece.type)) {
          print(_enPassant);
          if ([0, 7].contains(newY)) {
            piece.type *= 9;
          }
          else if(_enPassant!=100 && newY==5){
            _chessBoard[4][_enPassant]=0;
            _pieces.removeWhere((element) => element.x==_enPassant && element.y==4);
          }
          else if (currentPos.y==6 && newY==4){
            _enPassant=newX;
            print(_enPassant);
          }
        }
        // if (_enPassant!=100 && _whiteTurn){
        //   _enPassant=100;
        // }
        _chessBoard[newY][newX] = piece.type;
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

  bool _addIfLegalOption(int optionX, int optionY) {
    //return true if the square is empty, else returns false (regardless if the option was added or not)
    var squareType = _chessBoard[optionY][optionX];
    if (squareType == 0) {
      _options.add(Pos(optionX, optionY));
      return true;
    }
    if ((_whiteTurn && squareType < 0) || (!_whiteTurn && squareType >= 0)) {
      _options.add(Pos(optionX, optionY));
    }
    return false;
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
    //enpssant option
    if (y==4 && (_enPassant==x-1||_enPassant==x+1)){
      _options.add(Pos(_enPassant,5));
    }
  }

  void _bishopOptions(int x, int y) {
    //upleft
    var j = y;
    for (var i = x; i > 0 && j > 0; i--) {
      if (!_addIfLegalOption(i - 1, j - 1)) {
        break;
      }
      j--;
    }
    //upright
    j = y;
    for (var i = x; i < 7 && j > 0; i++) {
      if (!_addIfLegalOption(i + 1, j - 1)) {
        break;
      }
      j--;
    }
    //downright
    j = y;
    for (var i = x; i < 7 && j < 7; i++) {
      if (!_addIfLegalOption(i + 1, j + 1)) {
        break;
      }
      j++;
    }
    //downleft
    j = y;
    for (var i = x; i > 0 && j < 7; i--) {
      if (!_addIfLegalOption(i - 1, j + 1)) {
        break;
      }
      j++;
    }
  }

  void _rookOptions(int x, int y) {
    //right
    for (var i = x; i < 7; i++) {
      if (!_addIfLegalOption(i + 1, y)) {
        break;
      }
    }
    //left
    for (var i = x; i > 0; i--) {
      if (!_addIfLegalOption(i - 1, y)) {
        break;
      }
    }
    //down
    for (var i = y; i < 7; i++) {
      if (!_addIfLegalOption(x, i + 1)) {
        break;
      }
    }
    //up
    for (var i = y; i > 0; i--) {
      if (!_addIfLegalOption(x, i - 1)) {
        break;
      }
    }
  }

  void _knightOptions(int x, int y) {
    if (x < 6) {
      if (y < 7) {
        _addIfLegalOption(x + 2, y + 1);
      }
      if (y > 0) {
        _addIfLegalOption(x + 2, y - 1);
      }
    }
    if (x > 1) {
      if (y < 7) {
        _addIfLegalOption(x - 2, y + 1);
      }
      if (y > 0) {
        _addIfLegalOption(x - 2, y - 1);
      }
    }
    if (y > 1) {
      if (x < 7) {
        _addIfLegalOption(x + 1, y - 2);
      }
      if (x > 0) {
        _addIfLegalOption(x - 1, y - 2);
      }
    }
    if (y < 6) {
      if (x < 7) {
        _addIfLegalOption(x + 1, y + 2);
      }
      if (x > 0) {
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
    _addCastleOptions(x, y);
  }

  void _addCastleOptions(int x, int y) {
    if (_canCastle['whiteLong'] &&
        _whiteTurn &&
        _chessBoard[7][1] == 0 &&
        _chessBoard[7][2] == 0 &&
        _chessBoard[7][3] == 0) {
      _options.add(Pos(2, 7));
    }
    if (_canCastle['whiteShort'] &&
        _whiteTurn &&
        _chessBoard[7][5] == 0 &&
        _chessBoard[7][6] == 0) {
      _options.add(Pos(6, 7));
      return;
    }
    if (_canCastle['blackLong'] &&
        !_whiteTurn &&
        _chessBoard[0][1] == 0 &&
        _chessBoard[0][2] == 0 &&
        _chessBoard[0][3] == 0) {
      _options.add(Pos(2, 0));
    }
    if (_canCastle['blackShort'] &&
        !_whiteTurn &&
        _chessBoard[0][5] == 0 &&
        _chessBoard[0][6] == 0) {
      _options.add(Pos(6, 0));
      return;
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
