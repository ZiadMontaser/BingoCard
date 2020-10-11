import 'package:bingo_card/providers/auth.dart';
import 'package:bingo_card/screens/avaters_screen.dart';
import 'package:bingo_card/widgets/app_bar.dart';
import 'package:bingo_card/widgets/my_avatar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/profile';

  Future<void> openAvatarEditor(BuildContext context, Auth auth) async {
    final url =
        await Navigator.of(context).pushNamed(AvatersListScreen.routeName);
    if (url != null) {
      try {
        await auth.updateAvatar(url);
      } catch (e) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('Somthing Went Wrong'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (context, auth, child) {
        final user = auth.user;
        return Scaffold(
          appBar: MyAppBar(),
          body: LayoutBuilder(builder: (context, _) {
            return Container(
              padding: EdgeInsets.all(16),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      MyAvatar(
                        radius: 100,
                        url: user.avatarUrl,
                        // icon: Icons.edit,
                        onTap: () => openAvatarEditor(context, auth),
                      ),
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: RaisedButton(
                          onPressed: () => openAvatarEditor(context, auth),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.edit,
                              color: Theme.of(context).iconTheme.color,
                              size: 48,
                            ),
                          ),
                          color: Theme.of(context).primaryColor,
                          shape: CircleBorder(),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          }),
        );
      },
    );
  }
}
