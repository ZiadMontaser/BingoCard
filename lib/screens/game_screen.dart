import 'package:flutter/material.dart';

import 'package:bingo_card/models/app_user.dart';
import 'package:bingo_card/providers/auth.dart';
import 'package:bingo_card/providers/match.dart';
import 'package:bingo_card/widgets/app_bar.dart';
import 'package:bingo_card/widgets/bingo_card.dart';
import 'package:bingo_card/widgets/my_avatar.dart';

class GameScreen extends StatelessWidget {
  static const routeName = '/game';

  Future<bool> onBackPressed() async {
    print('Back');
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final match = Match.of(context);
    final auth = Auth.of(context);
    final user = auth.user;
    return WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
        appBar: MyAppBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          // mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              fit: FlexFit.tight,
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    LinearPlayersView(user: user),
                    Expanded(
                      child: Card(
                        elevation: 5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              flex: 6,
              child: Stack(
                children: [
                  Positioned.fill(
                    top: 28,
                    child: Material(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(25),
                        topRight: const Radius.circular(25),
                      ),
                      elevation: 9,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 28,
                          bottom: 16,
                          left: 16,
                          right: 16,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ...match.cards
                                .map((e) => Flexible(
                                        child: BingoCard(
                                      cardId: e,
                                    )))
                                .toList(),
                            // Flexible(child: BingoCard()),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    child: FloatingActionButton(
                      onPressed: () {},
                      child: Divider(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LinearPlayersView extends StatelessWidget {
  const LinearPlayersView({
    Key key,
    @required this.user,
  }) : super(key: key);

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          children: [
            MiniProfile(user: user),
            RotatedBox(
              quarterTurns: 2,
              child: MiniBingoCard(),
            ),
          ],
        ),
        Row(
          children: [
            MiniProfile(user: user),
            RotatedBox(
              quarterTurns: 2,
              child: MiniBingoCard(),
            ),
          ],
        ),
        Row(
          children: [
            MiniProfile(user: user),
            RotatedBox(
              quarterTurns: 2,
              child: MiniBingoCard(),
            ),
          ],
        ),
      ],
    );
  }
}

class GridPlyersView extends StatelessWidget {
  const GridPlyersView({
    Key key,
    @required this.user,
  }) : super(key: key);

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Stack(
        // alignment: Alignment.center,
        children: [
          Positioned(
            right: 0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                MiniBingoCard(
                  rotate: 2,
                ),
                SizedBox(
                  width: 8,
                ),
                MiniProfile(user: user),
              ],
            ),
          ),
          Positioned(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                MiniProfile(user: user),
                SizedBox(
                  height: 8,
                ),
                MiniBingoCard(
                  rotate: 1,
                )
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                MiniBingoCard(
                  rotate: -1,
                ),
                SizedBox(
                  height: 8,
                ),
                MiniProfile(user: user),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: MiniProfile(user: user),
          ),
        ],
      ),
    );
  }
}

class MiniBingoCard extends StatelessWidget {
  final double width;
  final double height;
  final int rotate;
  final String text;
  const MiniBingoCard({
    Key key,
    this.width = 50,
    this.height = 70,
    this.rotate = 0,
    this.text = 'x 1',
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: rotate,
      child: Container(
        height: height,
        width: width,
        child: Card(
          elevation: 5,
          child: Column(
            children: [
              Flexible(
                flex: 1,
                child: FittedBox(
                  child: Text(
                    'Bingo',
                    style: TextStyle(
                      letterSpacing: 5,
                    ),
                  ),
                ),
              ),
              Divider(
                color: Colors.black,
                height: 0,
              ),
              Expanded(
                flex: 3,
                child: FittedBox(
                  alignment: Alignment.center,
                  fit: BoxFit.scaleDown,
                  child: Text(
                    text,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MiniProfile extends StatelessWidget {
  const MiniProfile({
    Key key,
    @required this.user,
  }) : super(key: key);

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MyAvatar(
          url: user.avatarUrl,
          radius: 20,
        ),
        Text(user.gamerTag),
      ],
    );
  }
}
