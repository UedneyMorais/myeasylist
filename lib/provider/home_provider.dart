import 'package:flutter/material.dart';
import '/utils/util.dart';
import '../domain/domain.dart';

class HomeProvider with ChangeNotifier {
  late List<Item> items = [];
  late int lastItem = 0;
  late int checked = 0;

  void addItem({required String itemDescription}) {
    Item newItem = Item(id: lastItem + 1, item: itemDescription, checked: 0);
    items.add(newItem);
    DbUtil.insert(DbConfig.dbName, {'id': newItem.id, 'item': newItem.item, 'checked': newItem.checked});
    loadPlaces();
    notifyListeners();
  }

  void updateItem(Item item) async {
    Item itemToUpdate = Item(id: item.id, item: item.item, checked: item.checked);
    await DbUtil.update(DbConfig.dbName, {'id': itemToUpdate.id, 'item': itemToUpdate.item, 'checked': itemToUpdate.checked});
    checked = itemToUpdate.checked;
    loadPlaces();
    notifyListeners();
  }

  void removeItem(Item item) async {
    var newToRemove = item;
    items.remove(newToRemove);
    await DbUtil.remove(DbConfig.dbName, item.id);
    notifyListeners();
  }

  Future<void> loadPlaces() async {
    final dataList = await DbUtil.getData(DbConfig.dbName);
    items = dataList
        .map(
          (item) => Item(id: item['id'], item: item['item'], checked: item['checked']),
        )
        .toList();
    lastItem = items.isNotEmpty ? items.last.id : 0;
    notifyListeners();
  }
}
