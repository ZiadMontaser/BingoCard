import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: const Radius.circular(20),
          bottomRight: const Radius.circular(20),
        ),
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      actions: [
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorDark,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(50),
                  bottomRight: const Radius.circular(50),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(1),
                  ),
                  BoxShadow(
                    color: Theme.of(context).primaryColor,
                    spreadRadius: -12.0,
                    blurRadius: 12.0,
                  ),
                ],
              ),
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              height: 100,
              width: 100,
              alignment: Alignment.center,
              child: Text(
                '99',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Icon(
              Icons.shopping_cart,
              color: Theme.of(context).accentColor,
              size: 32,
            ),
          ],
        )
      ],
      title: Text(
        'Bingo Card',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(AppBar().preferredSize.height);
}
