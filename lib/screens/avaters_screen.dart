import 'package:bingo_card/providers/avatars.dart';
import 'package:bingo_card/widgets/my_avatar.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AvatersListScreen extends StatelessWidget {
  static const routeName = '/avaters';
  @override
  Widget build(BuildContext context) {
    final avaters = Avatars.of(context);
    return FutureBuilder(
      future: avaters.fetchAndGetDate(),
      builder: (context, snapshot) {
        bool isWaiting = snapshot.connectionState == ConnectionState.waiting;
        final list = avaters.items;

        final grid = GridView.builder(
          itemCount: isWaiting ? 20 : list.length,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 100,
            childAspectRatio: 1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) => MyAvatar(
            radius: 30,
            url: isWaiting ? null : list[index],
            onTap: isWaiting
                ? null
                : () {
                    Navigator.of(context).pop(list[index]);
                  },
          ),
        );

        return Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Choose Your Avatar',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                Flexible(
                    child: isWaiting
                        ? Shimmer.fromColors(
                            enabled: true,
                            baseColor: Theme.of(context).accentColor,
                            highlightColor:
                                Theme.of(context).accentColor.withAlpha(5255),
                            child: grid,
                          )
                        : grid),
              ],
            ),
          ),
        );
      },
    );
  }
}
