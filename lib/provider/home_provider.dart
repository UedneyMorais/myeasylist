import 'package:flutter/material.dart';
import 'package:myeasylist/utils/db_util.dart';

import '../domain/domain.dart';

class HomeProvider with ChangeNotifier {
  late List<Item> items = [];
  late int lastItem = 0;
  late int checked = 0;

  void addItem({required String itemDescription}) {
    Item newItem = Item(id: lastItem + 1, item: itemDescription, checked: 0);
    items.add(newItem);
    DbUtil.insert('itemstravel',
        {'id': newItem.id, 'item': newItem.item, 'checked': newItem.checked});
    loadPlaces();
    notifyListeners();
  }

  void updateItem(Item item) async {
    Item itemToUpdate =
        Item(id: item.id, item: item.item, checked: item.checked);
    await DbUtil.update('itemstravel', {
      'id': itemToUpdate.id,
      'item': itemToUpdate.item,
      'checked': itemToUpdate.checked
    });
    checked = itemToUpdate.checked;
    loadPlaces();
    notifyListeners();
  }

  void removeItem(Item item) async {
    var newToRemove = item;
    items.remove(newToRemove);
    await DbUtil.remove('itemstravel', item.id);
    notifyListeners();
  }

  Future<void> loadPlaces() async {
    final dataList = await DbUtil.getData('itemstravel');
    items = dataList
        .map(
          (item) => Item(
              id: item['id'], item: item['item'], checked: item['checked']),
        )
        .toList();
    lastItem = items.last.id;
    notifyListeners();
  }
}
