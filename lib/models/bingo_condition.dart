import 'package:bingo_card/models/cell.dart';

class BingoCondition {
  final List<int> cellsId;

  const BingoCondition(this.cellsId);

  bool checkCondition(List<Cell> list) {
    int count = 0;
    for (var i = 0; i < list.length; i++) {
      final cell = list[i];
      if (!cell.isPressed) continue;
      if (cellsId.contains(cell.id)) {
        count++;
      }
    }
    return count == cellsId.length;
  }
}
