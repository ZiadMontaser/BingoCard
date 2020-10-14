import 'package:bingo_card/widgets/my_avatar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MiniProfile extends StatefulWidget {
  final id;

  const MiniProfile({
    Key key,
    this.id,
  }) : super(key: key);

  @override
  _MiniProfileState createState() => _MiniProfileState();
}

class _MiniProfileState extends State<MiniProfile> {
  String gamerTag;
  String avatarUrl;

  @override
  void initState() {
    profileRef.onValue.listen((event) {
      final data = Map<String, dynamic>.from(event.snapshot.value);

      gamerTag = data['gamerTag'];
      avatarUrl = data['avatarUrl'];
    });
    super.initState();
  }

  DatabaseReference get profileRef {
    return FirebaseDatabase.instance.reference().child('users/${widget.id}');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MyAvatar(
          url: avatarUrl,
          radius: 20,
        ),
        if (gamerTag != null) Text(gamerTag),
      ],
    );
  }
}
