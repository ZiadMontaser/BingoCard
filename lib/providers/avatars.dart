import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class Avatars with ChangeNotifier {
  FirebaseDatabase db = FirebaseDatabase.instance;
  List<String> _items = [];

  List<String> get items => [..._items];

  Avatars();
  factory Avatars.of(BuildContext context, {bool listen = true}) {
    return Provider.of<Avatars>(context, listen: listen);
  }

  Future<void> fetchAndGetDate() async {
    if (_items.length != 0) return;
    final dataSnapshot = await db.reference().child('avatars').once();
    _items = (dataSnapshot.value as List<dynamic>).map((e) => '$e').toList();
    print('Fetcing Avatars');
    notifyListeners();
  }

  Future<String> getRandom() async {
    String url = _items[Random().nextInt(_items.length)];
    if (url == null)
      url =
          "https://firebasestorage.googleapis.com/v0/b/bingodealer-c112f.appspot.com/o/avatars%2Fuser.svg?alt=media&token=26559bfa-6f1b-4a35-8203-2e3cd4026be0";
    return url;
  }
}
