import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyAvatar extends StatelessWidget {
  final double radius;
  final String url;
  final Function() onTap;
  final Widget child;
  final Color color;
  final IconData icon;
  const MyAvatar({
    Key key,
    this.radius,
    this.onTap,
    this.child,
    this.icon,
    this.color = Colors.amber,
    this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      child: Material(
        elevation: 4.0,
        shape: CircleBorder(),
        clipBehavior: Clip.hardEdge,
        color: Theme.of(context).accentColor,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (url != null)
              SvgPicture.network(
                url,
                width: 120,
                height: 120,
              ),
            if (icon != null) FittedBox(child: Icon(icon)),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
