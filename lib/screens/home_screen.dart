import 'package:bingo_card/helpers/card_generator.dart';
import 'package:bingo_card/providers/match_maker.dart';
import 'package:bingo_card/screens/game_screen.dart';
import 'package:bingo_card/providers/match.dart';
import 'package:bingo_card/widgets/app_bar.dart';
import 'package:bingo_card/widgets/main_drawer.dart';
import 'package:bingo_card/widgets/matchmaking_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: MainDrawer(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Consumer<MatchMaker>(
                    builder: (context, matchmaker, child) {
                      return FlatButton(
                          color: Theme.of(context).primaryColor,
                          onPressed: matchmaker.isMatchMaking
                              ? null
                              : () => quickMatch(context),
                          child: Text('Quick Match'));
                    },
                  ),
                  FlatButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: () {},
                      child: Text('Card')),
                ],
              ),
            ),
            MatchMakingBar(),
          ],
        ),
      ),
    );
  }

  void quickMatch(BuildContext context) {
    MatchMaker.of(context, false).findMatch().then((value) {
      return Navigator.of(context).pushNamed(GameScreen.routeName);
    }).catchError((e) {
      showErrorDialog(context, message: e.toString());
    });
  }

  void showErrorDialog(BuildContext context, {String message = ''}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Match making faild'),
        content: Text(
          message,
        ),
        actions: [
          FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('fine'),
          ),
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
              quickMatch(context);
            },
            child: Text(
              'Try Again',
              style: TextStyle(color: Colors.white),
            ),
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
