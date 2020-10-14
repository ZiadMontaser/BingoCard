import 'package:bingo_card/providers/match_maker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MatchMakingBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  _MatchMakingBarState createState() => _MatchMakingBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => AppBar().preferredSize;
}

class _MatchMakingBarState extends State<MatchMakingBar>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<Offset> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    animation = Tween<Offset>(begin: Offset(0, -1.5), end: Offset(0, 0.7))
        .animate(controller);
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<MatchMaker>(
        builder: (context, value, child) {
          if (value.isMatchMaking) {
            controller.forward();
          } else {
            controller.reverse();
          }
          return child;
        },
        child: SlideTransition(
          position: Tween<Offset>(begin: Offset(0, -1.5), end: Offset(0, -0.25))
              .animate(controller),
          child: Material(
            borderRadius: BorderRadius.only(
              bottomLeft: const Radius.circular(20),
              bottomRight: const Radius.circular(20),
            ),
            elevation: 4,
            color: Theme.of(context).primaryColor,
            // textStyle: Theme.of(context).appBarTheme.textTheme.headline6,
            child: Padding(
              padding:
                  const EdgeInsets.only(right: 8, left: 8, top: 16, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Searching for players',
                    style: TextStyle(color: Colors.white),
                  ),
                  CircularProgressIndicator(),
                  FlatButton(onPressed: () {}, child: Text('Cansle'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
