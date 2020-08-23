import 'package:flutter/foundation.dart';

class NavigationProvider with ChangeNotifier {
  int _currentBottomNavIndex = 0;
  int get currentBottomNavIndex => _currentBottomNavIndex;
  set setCurrentBottomNavIndex(int index) {
    _currentBottomNavIndex = index;
    notifyListeners();
  }
}
