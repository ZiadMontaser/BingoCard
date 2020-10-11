import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Shimmer.fromColors(
              baseColor: Theme.of(context).primaryColor,
              highlightColor: Theme.of(context).primaryColorLight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.stay_current_landscape,
                    color: Colors.black,
                    size: 168,
                  ),
                  Text(
                    'Bingo Card',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 48,
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Loading'),
          ),
        ],
      ),
    );
  }
}
