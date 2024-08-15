import 'package:flutter/foundation.dart';

class MainPageModel with ChangeNotifier {
  int _weight;

  MainPageModel(this._weight);

  int get weight => _weight;

  void updateWeight(int newWeight) {
    _weight = newWeight;
    notifyListeners();
  }
}
