import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class Player with ChangeNotifier {
  final String id;
  String gamerTag;
  String avatarUrl;
  int cardCount;
  bool isTurn = false;
  bool isLocal = false;
  bool isConnected = false;
  Player({
    this.id,
    this.gamerTag,
    this.avatarUrl,
    this.cardCount,
    this.isTurn,
    this.isLocal,
    this.isConnected,
  });

  void init() async {
    final snapshot = await profileRef.once();
    final data = Map<String, dynamic>.from(snapshot.value);
    gamerTag = data['gamerTag'];
    avatarUrl = data['avatarUrl'];

    notifyListeners();
  }

  DatabaseReference get profileRef {
    return FirebaseDatabase.instance.reference().child('users/$id');
  }
}
