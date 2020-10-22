import 'dart:async';

import 'package:bingo_card/providers/auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'match.dart';

class MatchMaker with ChangeNotifier {
  static const NONE = 'none';

  FirebaseDatabase _db = FirebaseDatabase.instance;
  Auth _auth;

  DatabaseReference _matchMakerRef;
  DatabaseReference _gamesRef;

  bool isMatchMaking = false;
  bool isInGame = false;

  Match currentMatch;

  MatchMaker(BuildContext context) {
    _auth = Auth.of(context, listen: false);
    _matchMakerRef = _db.reference().child('match_maker');
    _gamesRef = _db.reference().child('matches');
  }

  factory MatchMaker.of(BuildContext context, [bool listen = true]) {
    return Provider.of<MatchMaker>(context, listen: listen);
  }

  Future<String> findMatch() async {
    if (isMatchMaking || isInGame) return Future.error('You allready started');
    isMatchMaking = true;
    notifyListeners();
    // /*TODO: remove this line */ await Future.delayed(Duration(seconds: 30));
    final value = await _matchMakerRef.once();
    final matchmaker = value.value.toString();
    if (matchmaker == NONE) {
      return _findMatchFirstArriver();
    } else {
      return _findMatchSecondArrier(matchmaker);
    }
  }

  Future<String> _findMatchFirstArriver() async {
    String matchId;
    final gameRef = _gamesRef.push();
    matchId = gameRef.key;
    gameRef.set(
      {
        'count': 1,
        'players': [
          {
            'id': _auth.user.uid,
            'connected': true,
          }
        ]
      },
    );
    final TransactionResult result =
        await _matchMakerRef.runTransaction((mutableData) async {
      final matchmakerValue = mutableData.value.toString();
      if (matchmakerValue == NONE) {
        mutableData.value = matchId;
        return mutableData;
      }
      return Future.error('Another Player Took Over');
    });
    isMatchMaking = false;
    notifyListeners();

    if (result.committed) {
      isInGame = true;
      OnJoindMatch(matchId);
      return matchId;
    } else {
      isInGame = false;
      gameRef.remove();
      return Future.error('Some Thing Went Wrong');
    }
  }

  Future<String> _findMatchSecondArrier(String matchMaker) async {
    final result = await _matchMakerRef.runTransaction(
      (mutableData) async {
        if (mutableData.value == matchMaker) {
          mutableData.value = NONE;
          return mutableData;
        }
        return Future.error('Some Thing Went Wrong');
      },
    );
    // print(result.committed ? 'great work : $matchMaker' : 'Try Later');
    isMatchMaking = false;
    notifyListeners();

    if (result.committed) {
      isInGame = true;
      _gamesRef.child('$matchMaker/players/1').set({
        'id': _auth.user.uid,
        'connected': true,
      });
      OnJoindMatch(matchMaker);
      return matchMaker;
    } else {
      isInGame = false;
      return Future.error('Some Thing Went Wrong');
    }
  }

  void OnJoindMatch(String machId) {
    currentMatch = Match('-MJfB2U8kQw2Cd1y-_Wa');
  }
}
