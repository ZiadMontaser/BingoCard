import 'dart:async';
import 'dart:math';

import 'package:bingo_card/models/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class Auth with ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseDatabase database = FirebaseDatabase.instance;

  AppUser _user = AppUser();

  factory Auth.of(BuildContext context, {bool listen = true}) {
    return Provider.of<Auth>(context, listen: listen);
  }
  Auth() {
    auth.authStateChanges().listen(onUserStateChange);
  }

  AppUser get user {
    return _user;
  }

  bool get isAnonymous {
    return auth.currentUser.isAnonymous;
  }

  bool get isAuth {
    return FirebaseAuth.instance.currentUser != null;
  }

  Future<void> signUp(
      String email, String password, String gamerTag, String avatarUrl) async {
    try {
      final credential =
          EmailAuthProvider.credential(email: email, password: password);
      await auth.currentUser.linkWithCredential(credential);
      final data = {
        'gamerTag': gamerTag,
        'avatarUrl': avatarUrl,
        'email': email,
      };
      database.reference().child('users/${auth.currentUser.uid}').update(data);
      onSucsesfully();
      notifyListeners();
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<void> trySignIn() async {
    if (isAuth) return;
    await signInAnonymously();
    await database.reference().child('users/${auth.currentUser.uid}').set(
      {
        'gamerTag': 'PLayer ${Random().nextInt(1564561)}',
        'avatarUrl':
            "https://firebasestorage.googleapis.com/v0/b/bingodealer-c112f.appspot.com/o/avatars%2Fuser.svg?alt=media&token=26559bfa-6f1b-4a35-8203-2e3cd4026be0",
      },
    );
  }

  Future<void> signInAnonymously() async {
    await auth.signInAnonymously();
    // onSucsesfully();
    notifyListeners();
  }

  StreamSubscription<Event> profileListner;

  void onUserStateChange(User user) {
    if (profileListner != null) {
      profileListner.cancel();
    }
    if (auth.currentUser != null) {
      profileListner =
          database.reference().child('users/${user.uid}').onValue.listen(
        (event) {
          final data = event.snapshot.value;
          print(user.uid);
          _user = AppUser(
            uid: auth.currentUser.uid,
            gamerTag: data['gamerTag'] != null ? data['gamerTag'] : 'null',
            avatarUrl:
                data.containsKey('avatarUrl') ? data['avatarUrl'] : 'null',
            // email: data.containsKey('email') ? data['email'] : 'null',
          );
          notifyListeners();
        },
      );
    }
    notifyListeners();
  }

  void onSucsesfully() {
    // database.reference().child('users/${auth.currentUser.uid}').onValue.listen(
    //   (event) {
    //     final data = event.snapshot.value as Map<String, dynamic>;
    //     print(data);
    //     _user = AppUser(
    //       uid: auth.currentUser.uid,
    //       gamerTag: data.containsKey('gamerTag') ? data['gamerTag'] : 'null',
    //       avatarUrl: data.containsKey('avatarUrl') ? data['avatarUrl'] : 'null',
    //       email: data.containsKey('email') ? data['email'] : 'null',
    //     );
    //     notifyListeners();
    //   },
    // );
  }

  Future<void> updateAvatar(String url) async {
    String oldUrl = url;
    _user.avatarUrl = url;

    try {
      await database
          .reference()
          .child('users/${auth.currentUser.uid}')
          .update({'avatarUrl': url});
    } catch (e) {
      _user.avatarUrl = oldUrl;
      notifyListeners();
      throw e;
    }
  }
}
