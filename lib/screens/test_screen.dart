import 'package:bingo_card/widgets/bingo_card.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(child: Container(child: BingoCard())),
    );
  }
}
