import 'package:bingo_card/providers/auth.dart';
import 'package:bingo_card/providers/avatars.dart';
import 'package:bingo_card/providers/match.dart';
import 'package:bingo_card/screens/auth_screen.dart';
import 'package:bingo_card/screens/avaters_screen.dart';
import 'package:bingo_card/screens/game_screen.dart';
import 'package:bingo_card/screens/home_screen.dart';
import 'package:bingo_card/screens/profile_screen.dart';
import 'package:bingo_card/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screen/screen.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Screen.keepOn(true);
  await Firebase.initializeApp();
  // await FirebaseAuth.instance.signOut();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Avatars()),
        ChangeNotifierProvider(create: (_) => Auth()),
        ChangeNotifierProvider(create: (_) => Match()),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, child) {
          return FutureBuilder(
            future: onStart(context, auth),
            builder: (context, snapshot) {
              bool isWaiting =
                  snapshot.connectionState == ConnectionState.waiting;
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  primarySwatch: Colors.cyan,
                  accentColor: Colors.amber,
                  textTheme: ThemeData.light().textTheme.copyWith(
                        headline6: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                  iconTheme: ThemeData.light().iconTheme.copyWith(
                        color: Colors.white,
                      ),
                  appBarTheme: AppBarTheme(
                    iconTheme: IconThemeData(
                      color: Colors.white,
                    ),
                  ),
                ),
                home: isWaiting ? SplashScreen() : HomeScreen(),
                routes: {
                  GameScreen.routeName: (_) => GameScreen(),
                  AuthScreen.routeName: (_) => AuthScreen(),
                  AvatersListScreen.routeName: (_) => AvatersListScreen(),
                  ProfileScreen.routeName: (_) => ProfileScreen(),
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<void> onStart(BuildContext context, Auth auth) async {
    // await Future.delayed(Duration(seconds: 3));
    await Avatars.of(context, listen: false).fetchAndGetDate();
    await auth.trySignIn();
  }
}
