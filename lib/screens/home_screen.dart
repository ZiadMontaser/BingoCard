import 'package:bingo_card/screens/game_screen.dart';
import 'package:bingo_card/screens/test_screen.dart';
import 'package:bingo_card/providers/match.dart';
import 'package:bingo_card/widgets/app_bar.dart';
import 'package:bingo_card/widgets/main_drawer.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: MainDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton(
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  Match.of(context, false).quickMatch();
                  Navigator.of(context).pushNamed(GameScreen.routeName);
                },
                child: Text('Quick Match')),
            FlatButton(
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => TestScreen(),
                  ));
                },
                child: Text('Card')),
          ],
        ),
      ),
    );
  }
}
