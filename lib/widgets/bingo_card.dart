import 'package:bingo_card/providers/auth.dart';
import 'package:bingo_card/providers/match.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:bingo_card/models/bingo_condition.dart';
import 'package:bingo_card/models/cell.dart';
import 'package:bingo_card/widgets/bingo_card_cell.dart';
import 'package:provider/provider.dart';

class BingoCard extends StatefulWidget {
  final String cardId;
  final List<BingoCondition> conditions;
  final int columns;
  final rows;
  final double width;
  final double height;
  final double borderRadius;
  BingoCard({
    Key key,
    this.cardId,
    this.columns = 5,
    this.width = 200,
    this.height,
    this.rows = 5,
    this.borderRadius = 15,
    this.conditions = const [
      BingoCondition([0, 1, 2, 3, 4]),
      BingoCondition([5, 6, 7, 8, 9]),
      BingoCondition([10, 11, 12, 13, 14]),
      BingoCondition([15, 16, 17, 18, 19]),
      BingoCondition([20, 21, 22, 23, 24]),
      BingoCondition([0, 5, 10, 15, 20]),
      BingoCondition([1, 6, 11, 16, 21]),
      BingoCondition([2, 7, 12, 17, 22]),
      BingoCondition([3, 8, 13, 18, 23]),
      BingoCondition([4, 9, 14, 19, 24]),
      BingoCondition([0, 6, 12, 18, 24]),
      BingoCondition([20, 16, 12, 8, 4]),
      BingoCondition([0, 12, 4, 24, 20]),
    ],
  }) : super(key: key);

  @override
  _BingoCardState createState() => _BingoCardState();
}

class _BingoCardState extends State<BingoCard> {
  DatabaseReference cardRef;
  List<Cell> cells = [];
  int count = 0;

  @override
  void initState() {
    super.initState();
    final match = Match.of(context, false);
    cardRef = match.gameRef.child('cards/${widget.cardId}');

    cardRef.child('value').orderByChild('id').onValue.listen(fetchData);
  }

  void fetchData(Event event) async {
    cells.clear();
    Map<String, dynamic>.from(event.snapshot.value).forEach(
      (key, value) {
        final cellData = Map<String, dynamic>.from(value);

        cells.add(Cell(
          number: int.parse(key),
          isPressed: cellData['isPressed'],
          id: cellData['id'],
        ));
      },
    );
    Cell.sort(cells);

    onCellChanged(null);
  }

  void onCellChanged(Cell pressedCell) async {
    setState(() {
      count = BingoCondition.checkForAll(
        widget.conditions,
        cells,
        pressedCell,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(widget.borderRadius),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildCardHeader(),
            Divider(
              height: 1,
              color: Colors.black,
              thickness: 1,
            ),
            buildCardBody(),
          ],
        ),
      ),
    );
  }

  Flexible buildCardBody() {
    return Flexible(
      flex: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            double x = constraints.maxWidth / widget.columns;
            double y = constraints.maxHeight / widget.rows;
            return ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(widget.borderRadius),
              ),
              child: GridView(
                semanticChildCount: 25,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: widget.columns,
                  childAspectRatio: x / y,
                ),
                children: [
                  ...cells
                      .map(
                        (cell) => ChangeNotifierProvider.value(
                          value: cell,
                          child: BingoCardCell(
                            onTap: onCellChanged,
                          ),
                        ),
                      )
                      .toList(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Flexible buildCardHeader() {
    int c = 0;
    return Flexible(
      flex: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(widget.borderRadius),
          topRight: Radius.circular(widget.borderRadius),
        ),
        child: count >= 5
            ? FlatButton(
                onPressed: () {},
                color: Colors.amber,
                textColor: Colors.white,
                child: Text('Bingo'),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ...'Bingo'.split('').map((e) {
                    Color color;
                    if (c < count) color = Colors.lime;
                    c++;
                    return Expanded(
                      child: Container(
                        color: color,
                        child: Align(
                          alignment: Alignment.center,
                          child: FittedBox(
                            child: Text(
                              e,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
      ),
    );
  }
}
