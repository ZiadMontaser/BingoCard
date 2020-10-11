import 'package:bingo_card/models/cell.dart';

class CardData {
  String id;
  List<Cell> cells;
  CardData({
    this.id,
    this.cells,
  });

  List<dynamic> toMap() {
    return [...cells.map((e) => e.toMap()).toList()];
  }

  factory CardData.fromMap(String id, List<dynamic> list) {
    if (list == null) return null;
    int cellId = 0;

    return CardData(
      id: id,
      cells: List<Cell>.from(list?.map((x) {
        final cell = Cell.fromMap(id, cellId, Map<String, dynamic>.from(x));
        cellId++;
        return cell;
      })),
    );
  }
}
