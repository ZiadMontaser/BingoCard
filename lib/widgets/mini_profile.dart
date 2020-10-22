import 'package:bingo_card/models/player.dart';
import 'package:bingo_card/widgets/my_avatar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MiniProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final player = Provider.of<Player>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MyAvatar(
            url: player.avatarUrl,
            radius: 20,
          ),
          if (player.gamerTag != null)
            Expanded(
              child: Container(
                width: 50,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    player.gamerTag,
                    style: TextStyle(
                      color: player.isTurn
                          ? Colors.green
                          : Theme.of(context).errorColor,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
