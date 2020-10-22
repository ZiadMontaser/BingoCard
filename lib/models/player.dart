import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class Player with ChangeNotifier {
  final String id;
  bool _isTurn = false;
  final isLocal;
  int _cardCount = 0;
  List<String> cards = [];

  String gamerTag;
  String avatarUrl;
  bool isConnected = false;
  Player({
    this.id,
    this.isLocal = false,
    this.gamerTag,
    this.avatarUrl,
    this.isConnected,
  }) {
    init();
  }

  void init() async {
    final snapshot = await profileRef.once();
    final data = Map<String, dynamic>.from(snapshot.value);
    gamerTag = data['gamerTag'];
    avatarUrl = data['avatarUrl'];

    notifyListeners();
  }

  set isTurn(bool value) {
    _isTurn = value;
    notifyListeners();
  }

  get isTurn {
    return _isTurn;
  }

  set cardCount(int value) {
    _cardCount = value;
    notifyListeners();
  }

  void addCard(String cardId) {
    cards.add(cardId);
  }

  int get cardCount => _cardCount;

  DatabaseReference get profileRef {
    return FirebaseDatabase.instance.reference().child('users/$id');
  }

  @override
  String toString() {
    return 'Player(id: $id, gamerTag: $gamerTag, avatarUrl: $avatarUrl, cardCount: $cardCount, isTurn: $_isTurn, isLocal: $isLocal, isConnected: $isConnected)';
  }
}
