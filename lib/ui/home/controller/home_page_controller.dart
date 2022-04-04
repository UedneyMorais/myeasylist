import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../domain/domain.dart';
import '../../../provider/provider.dart';

class HomePageController {
  BuildContext context;
  HomePageController({required this.context});

  loadInfo() async {
    Provider.of<HomeProvider>(context, listen: false).loadPlaces();
  }

  reload() async {
    await loadInfo();
  }

  addItem({required String itemDescription}) async {
    Provider.of<HomeProvider>(context, listen: false).addItem(itemDescription: itemDescription);
  }

  updateItem({required Item item}) async {
    Provider.of<HomeProvider>(context, listen: false).updateItem(item);
  }

  removeItem({required Item item}) async {
    Provider.of<HomeProvider>(context, listen: false).removeItem(item);
  }
}
