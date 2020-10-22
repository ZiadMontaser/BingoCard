import 'package:flutter/material.dart';
import '../models/cell.dart';

class BingoCardCell extends StatelessWidget {
  final Function(Cell cell) onTap;
  BingoCardCell({
    this.onTap,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cell = Cell.of(context);
    return Material(
      color: cell.isPressed ? Colors.green : null,
      child: InkWell(
        onTap: () async {
          await cell.toggle(context);
        },
        child: Ink(
          child: FittedBox(
            alignment: Alignment.center,
            fit: BoxFit.scaleDown,
            child: Text(
              '${cell?.number}',
              textAlign: TextAlign.center,
              style: TextStyle(
                // color: Colors.white,
                // fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
