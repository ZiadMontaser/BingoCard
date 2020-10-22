import 'package:bingo_card/models/player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    final player = Provider.of<Player>(context);
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
                  child: RotatedBox(
                    quarterTurns: 2,
                    child: Text(
                      'x${player.cardCount}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
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
