import 'package:flutter/widgets.dart';
import 'package:grocery_app/Models/Viewed_Model.dart';

class ViewdProvider extends ChangeNotifier {
  Map<String, ViewedModel> get getviewedItems {
    return _viewedItems;
  }

  Map<String, ViewedModel> _viewedItems = {};

  void addViewedItem({required String proid,required String time}) {
    _viewedItems.putIfAbsent(proid,
        () => ViewedModel(id: DateTime.now().toString(), productId: proid, time: time));
    notifyListeners();
  }
}
