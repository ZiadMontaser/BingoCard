import 'package:bingo_card/models/app_user.dart';
import 'package:bingo_card/models/player.dart';
import 'package:bingo_card/widgets/mini_bingo_card.dart';
import 'package:bingo_card/widgets/mini_profile.dart';
import 'package:flutter/material.dart';

// class GridPlyersView extends StatelessWidget {
//   const GridPlyersView({
//     Key key,
//     @required this.players,
//   }) : super(key: key);

//   final List<Player> players;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.all(8),
//       child: Stack(
//         // alignment: Alignment.center,
//         children: [
//           Positioned(
//             right: 0,
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 MiniBingoCard(
//                   rotate: 2,
//                 ),
//                 SizedBox(
//                   width: 8,
//                 ),
//                 MiniProfile(player: players.length == 2?players.firstWhere((element) => !element.isLocal):),
//               ],
//             ),
//           ),
//           Positioned(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 MiniProfile(player: player),
//                 SizedBox(
//                   height: 8,
//                 ),
//                 MiniBingoCard(
//                   rotate: 1,
//                 )
//               ],
//             ),
//           ),
//           Positioned(
//             bottom: 0,
//             right: 0,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 MiniBingoCard(
//                   rotate: -1,
//                 ),
//                 SizedBox(
//                   height: 8,
//                 ),
//                 MiniProfile(player: player),
//               ],
//             ),
//           ),
//           Positioned(
//             bottom: 0,
//             left: 0,
//             child: MiniProfile(
//                 player: players.firstWhere((player) => player.isLocal)),
//           ),
//         ],
//       ),
//     );
//   }
// }

class LinearPlayersView extends StatelessWidget {
  const LinearPlayersView({
    Key key,
    @required this.players,
  }) : super(key: key);

  final List<Player> players;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        if (players != null)
          ...players.map(
            (e) => Row(
              children: [
                MiniProfile(id: e.id),
                RotatedBox(
                  quarterTurns: 2,
                  child: MiniBingoCard(
                    text: '${e.cardCount}',
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
