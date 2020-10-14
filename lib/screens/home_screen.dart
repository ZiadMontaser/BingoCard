import 'package:bingo_card/providers/match_maker.dart';
import 'package:bingo_card/screens/game_screen.dart';
import 'package:bingo_card/providers/match.dart';
import 'package:bingo_card/widgets/app_bar.dart';
import 'package:bingo_card/widgets/main_drawer.dart';
import 'package:bingo_card/widgets/matchmaking_bar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: MainDrawer(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          // alignment: Alignment.center,
          // fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlatButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: () => quickMatch(context),
                      child: Text('Quick Match')),
                  FlatButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        // controller.forward();
                      },
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
    MatchMaker.of(context, false).findMatch().catchError((e) {
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
