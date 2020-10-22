import 'package:bingo_card/helpers/card_generator.dart';
import 'package:bingo_card/models/cell.dart';
import 'package:bingo_card/models/player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Match with ChangeNotifier {
  final String matchId;
  DatabaseReference gameRef;
  String userId;
  List<Player> players = [];

  // bool isRunning = false;
  // bool isTurn;
  // String playerTurnId;
  // Map<String, bool> turns = {};
  // Map<String, int> opponenetCardCount = {};
  // List<String> cards = [];

  FirebaseDatabase db = FirebaseDatabase.instance;

  factory Match.of(BuildContext context, [bool listen = true]) {
    return Provider.of<Match>(context, listen: listen);
  }
  Match(this.matchId) {
    gameRef = db.reference().child('matches/$matchId');
    userId = FirebaseAuth.instance.currentUser.uid;
    init();
  }

  int get count => players.length;

  Player get localPlayer {
    return players.firstWhere(
      (player) => player.id == userId,
      orElse: () => null,
    );
  }

  void init() {
    gameRef.child('players').onChildAdded.listen(onPlayerJoind);
    gameRef.child('players').onChildRemoved.listen(onPlayerLeft);
    gameRef.child('turns').orderByPriority().onValue.listen(onTurn);
    gameRef.child('cardsCount').onValue.listen(onCardCountChanged);
    gameRef.child('cards').onChildAdded.listen(onCardAdded);

    generatePlayerData();
  }

  void played() async {
    localPlayer.isTurn = false;
    notifyListeners();
    final result = await gameRef.child('turns').limitToFirst(1).once();
    if (result.value == null) return;
    final currentTurnKey =
        Map<String, dynamic>.from(result.value).keys.toList()[0];
    await gameRef.child('turns/$currentTurnKey').remove();
    gameRef.child('turns').push().set(userId);
    notifyListeners();
  }

  void onTurn(Event event) {
    if (event.snapshot.value == null) return;
    final turns = Map<String, String>.from(event.snapshot.value);
    if (turns.length < count) return;

    final currentTurn = turns.values.toList().reversed.toList()[0];
    print('Turn Changed : $currentTurn');

    players.forEach((player) {
      player.isTurn = player.id == currentTurn;
    });

    notifyListeners();
  }

  void onPlayerJoind(Event event) {
    print('Player Joind : ${event.snapshot.value}');
    final playerData = Map<String, dynamic>.from(event.snapshot.value);
    final player = Player(
      id: playerData['id'],
      isLocal: playerData['id'] == userId,
    );
    players.add(player);
    notifyListeners();
  }

  void onPlayerLeft(Event event) {
    print('Player Left : ${event.snapshot.value}');
    final playerData = Map<String, dynamic>.from(event.snapshot.value);
    players.removeWhere((player) => player.id == playerData['id']);
    notifyListeners();
  }

  void onCardCountChanged(Event event) {
    if (event.snapshot.value == null) return;
    final counts = Map<String, int>.from(event.snapshot.value);

    print('Card Number : $counts');

    players.forEach((player) {
      player.cardCount = counts[player.id] != null ? counts[player.id] : 1;
    });

    notifyListeners();
  }

  void onCardAdded(Event event) {
    final cardData = Map<String, dynamic>.from(event.snapshot.value);
    final playerId = cardData['owner'];

    final player = players.firstWhere((_player) => _player.id == playerId);
    player.addCard(event.snapshot.key);

    print('${player.gamerTag} have ${player.cards}');
  }

  void generatePlayerData() {
    final list = CardGenerator.card();
    final Map<String, dynamic> card = {};
    int count = 0;
    list.forEach(
      (element) {
        element.id = count;
        card['${element.number}'] = element.toMap();
        count++;
      },
    );
    final cardRef = gameRef.child('cards').push()
      ..set({
        'owner': userId,
        'value': card,
      });
    int priorityCounter = 0;
    card.forEach((key, value) {
      cardRef.child('value/$key').setPriority(priorityCounter);
      priorityCounter++;
    });
    notifyListeners();
  }

  Future<void> play(Cell cell) async {
    if (!localPlayer.isTurn) return Future.error('Not Your Turn');

    players.forEach((player) {
      player.cards.forEach((card) {
        gameRef.child('cards/$card/value/${cell.number}').once().then((value) {
          if (value.value == null) return;
          gameRef
              .child('cards/$card/value/${cell.number}')
              .update({'isPressed': cell.isPressed});
        }).catchError((e) {
          print('Some thing went Wrong');
        });
      });
    });

    played();
  }
}
