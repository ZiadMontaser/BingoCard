import 'package:bingo_card/providers/match.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class Cell with ChangeNotifier {
  int id;
  String cardId;
  int number;
  bool isPressed;
  DatabaseReference cardRef;
  Cell({
    this.id,
    this.cardId,
    @required this.number,
    this.isPressed = false,
  });
  factory Cell.of(context, [bool listen = true]) {
    return Provider.of<Cell>(context, listen: listen);
  }
  factory Cell.withCard(Cell cell, DatabaseReference ref) {
    cell.cardRef = ref;
    return cell;
  }

  Future<void> toggle(BuildContext context) async {
    if (!Match.of(context, false).isTurn) throw Exception('Not Your Turn');
    isPressed = !isPressed;
    print(isPressed);
    try {
      await cardRef.child('$id').update({'isPressed': isPressed});
    } catch (e) {
      isPressed = !isPressed;
      throw e;
    }
    notifyListeners();
  }

  @override
  String toString() {
    return '$number';
  }

  Map<String, dynamic> toMap() {
    return {
      'number': number,
      'isPressed': isPressed,
    };
  }

  factory Cell.fromMap(String cardId, int id, Map<String, dynamic> map) {
    if (map == null) return null;
    return Cell(
      id: id,
      number: map['number'],
      cardId: cardId,
      isPressed: map['isPressed'],
    );
  }
}
