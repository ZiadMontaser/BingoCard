import 'package:bingo_card/providers/match.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Cell with ChangeNotifier {
  int id;
  int number;
  bool isPressed;
  Cell({
    this.id,
    @required this.number,
    this.isPressed = false,
  });
  factory Cell.of(context, [bool listen = true]) {
    return Provider.of<Cell>(context, listen: listen);
  }

  Future<void> toggle(BuildContext context) async {
    isPressed = !isPressed;
    notifyListeners();

    print(this);

    try {
      await Match.of(context, false).play(this);
    } catch (e) {
      print(e);
      Scaffold.of(context).hideCurrentSnackBar();
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      isPressed = !isPressed;
      notifyListeners();
    }
  }

  @override
  String toString() {
    return 'Value: $number , IsPressed: $isPressed';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      // 'number': number,
      'isPressed': isPressed,
    };
  }

  factory Cell.fromMap(int number, Map<String, dynamic> map) {
    if (map == null) return null;
    return Cell(
      id: map['id'],
      number: number,
      isPressed: map['isPressed'],
    );
  }

  static List<Cell> sort(List<Cell> list) {
    list.sort((oldCell, newCell) => oldCell.id.compareTo(newCell.id));
  }
}
