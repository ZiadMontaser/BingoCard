import 'package:bingo_card/providers/match_maker.dart';
import 'package:bingo_card/widgets/chat.dart';
import 'package:bingo_card/widgets/players_view.dart';
import 'package:flutter/material.dart';

import 'package:bingo_card/providers/auth.dart';
import 'package:bingo_card/providers/match.dart';
import 'package:bingo_card/widgets/app_bar.dart';
import 'package:bingo_card/widgets/bingo_card.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatelessWidget {
  static const routeName = '/game';

  Future<bool> onBackPressed() async {
    print('Back');
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final auth = Auth.of(context);
    // Match match;
    final user = auth.user;
    return ChangeNotifierProvider<Match>.value(
      value: MatchMaker.of(context, false).currentMatch,
      child: WillPopScope(
        onWillPop: onBackPressed,
        child: Scaffold(
          appBar: MyAppBar(),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                fit: FlexFit.tight,
                flex: 4,
                child: Column(
                  children: [
                    LinearPlayersView(),
                  ],
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                flex: 6,
                child: Consumer<Match>(
                  builder: (context, match, child) => Stack(
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
                                if (match.localPlayer != null)
                                  ...match.localPlayer.cards
                                      .map((e) => Flexible(
                                              child: BingoCard(
                                            cardId: e,
                                          )))
                                      .toList(),
                                // ...match.cards
                                //     .map((e) => Flexible(
                                //             child: BingoCard(
                                //           cardId: e,
                                //         )))
                                //     .toList(),
                                // Flexible(child: BingoCard()),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 8,
                        child: Consumer<Match>(
                          builder: (context, value, child) =>
                              FloatingActionButton(
                            onPressed: () {
                              value.played();
                            },
                            child: Divider(),
                          ),
                        ),
                      ),
                    ],
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
