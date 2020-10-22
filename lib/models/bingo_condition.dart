import 'package:bingo_card/models/cell.dart';

class BingoCondition {
  final List<int> cellsId;

  const BingoCondition(this.cellsId);

  bool checkCondition(List<Cell> list, Cell pressedCell) {
    if (pressedCell != null) if (!cellsId.contains(pressedCell.id))
      return false;
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

  static int checkForAll(
    List<BingoCondition> conditions,
    List<Cell> cells, [
    Cell pressedCell,
  ]) {
    int c = 0;
    conditions.forEach((condition) {
      if (condition.checkCondition(cells, pressedCell)) c++;
    });
    return c;
  }
}
