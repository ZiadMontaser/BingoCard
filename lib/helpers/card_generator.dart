import 'dart:math';

import 'package:bingo_card/models/cell.dart';

class CardGenerator {
  static List<Cell> card() {
    List<Cell> finalList = [];

    final Random random = Random();
    List<Cell> temp = [];
    for (int i = 0; i < 5; i++) {
      final min = 15 * i + 1;
      // final max = 15 * i + 15;
      int row = 0;
      while (row < 5) {
        // final num = Math.floor(Math.random() * (max - min + 1) + min);
        final num = random.nextInt(15) + min;
        if (temp.firstWhere((element) => element.number == num,
                orElse: () => null) !=
            null) {
          continue;
        }
        row++;
        temp.add(Cell(id: temp.length, number: num));
      }
    }

    //formating list to be displayed well
    for (int a = 0; a < 5; a++) {
      for (var i = 0; i < 5; i++) {
        final cell = temp[i * 5 + a];
        finalList.add(cell);
      }
    }

    return finalList;
  }
}
