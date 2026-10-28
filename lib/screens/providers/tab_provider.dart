import 'package:flutter/foundation.dart';

class TabProvider extends ChangeNotifier {
  int _currentTabIndex = 0;

  int get currentTabIndex => _currentTabIndex;

  void changeTabIndex(int index) {
    _currentTabIndex = index;
    notifyListeners();
  }
}
