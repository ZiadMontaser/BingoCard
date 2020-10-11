import 'dart:math';

import 'package:bingo_card/models/cell.dart';

class CardGenerator {
  static List<Cell> card() {
    final Random random = Random();
    List<Cell> cellList = [];
    for (int i = 0; i < 5; i++) {
      final min = 15 * i + 1;
      // final max = 15 * i + 15;
      int row = 0;
      while (row < 5) {
        // final num = Math.floor(Math.random() * (max - min + 1) + min);
        final num = random.nextInt(15) + min;
        if (cellList.firstWhere((element) => element.number == num,
                orElse: () => null) !=
            null) {
          continue;
        }
        row++;
        cellList.add(Cell(id: cellList.length, number: num));
      }
    }
    return cellList;
  }
}
