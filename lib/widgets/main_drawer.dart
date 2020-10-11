import 'dart:ui';

import 'package:bingo_card/models/app_user.dart';
import 'package:bingo_card/providers/auth.dart';
import 'package:bingo_card/screens/auth_screen.dart';
import 'package:bingo_card/screens/profile_screen.dart';
import 'package:bingo_card/widgets/my_avatar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Consumer<Auth>(
        builder: (context, auth, child) {
          AppUser user = auth.user;
          print(user.gamerTag);
          print(user.email);
          print(user.avatarUrl);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: () {
                  if (auth.isAnonymous) {
                    Navigator.of(context).pushNamed(AuthScreen.routeName);
                  } else {
                    Navigator.of(context).pushNamed(ProfileScreen.routeName);
                  }
                },
                child: Container(
                  height: 200,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColorLight,
                        Theme.of(context).primaryColor,
                      ],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).accentColor,
                        offset: Offset(-2, 1.5),
                        blurRadius: 3,
                      ),
                    ],
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MyAvatar(
                        radius: 35,
                        url: user.avatarUrl,
                      ),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FittedBox(
                            child: Text(
                              'Hi, ${user.gamerTag}',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              FittedBox(
                                  child: Text(
                                user.uid?.substring(0, 20),
                                style: Theme.of(context).textTheme.bodyText2,
                                softWrap: true,
                                overflow: TextOverflow.fade,
                              )),
                              // IconButton(
                              //     icon: Icon(Icons.event_note), onPressed: null),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              FlatButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                  },
                  child: Text('Sign Out'))
            ],
          );
        },
      ),
    );
  }
}

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(AuthScreen.routeName);
      },
      child: Container(
        width: double.infinity,
        height: 200,
        // color: Theme.of(context).primaryColor,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColorLight,
              Theme.of(context).primaryColor,
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  FittedBox(
                    child: CircleAvatar(
                      radius: 35,
                      backgroundImage: NetworkImage(
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTDkvFCLSMbUU6Bqb1m-0y3LPAQ7_Gcs-PNZw&usqp=CAU'),
                    ),
                  ),
                  SizedBox(
                    width: 32,
                  ),
                  Text(
                    'Zirno',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
