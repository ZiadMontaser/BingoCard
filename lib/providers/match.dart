import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class Match with ChangeNotifier {
  bool isRunning = false;
  String matchId;
  bool isTurn;
  String playerTurnId;
  Map<String, bool> turns = {};
  Map<String, int> opponenetCardCount = {};
  Map<String, bool> playersList = {};
  List<String> cards = [];

  FirebaseDatabase db = FirebaseDatabase.instance;

  factory Match.of(BuildContext context, [bool listen = true]) {
    return Provider.of<Match>(context, listen: listen);
  }
  Match();

  Future<void> quickMatch() async {
    final uid = FirebaseAuth.instance.currentUser.uid;
    matchId = 'test-match';
    db.reference().child('matches/$matchId').onValue.listen((event) {
      final data = Map<String, dynamic>.from(event.snapshot.value);
      turns.clear();
      cards = [];
      playersList.clear();
      opponenetCardCount.clear();
      isTurn = data['turn'] == uid;
      turns.addAll(Map<String, bool>.from(data['turns']));
      cards.addAll(Map<String, dynamic>.from(data['cards'][uid]).keys);
      opponenetCardCount.addAll(Map<String, dynamic>.from(data['cards']).map(
          (key, value) =>
              MapEntry(key, Map<String, dynamic>.from(value).length)));
      playersList.addAll(Map<String, bool>.from(data['players']));
      notifyListeners();
    });
  }
}
