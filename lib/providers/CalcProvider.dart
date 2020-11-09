import 'package:flutter/foundation.dart';
import 'package:notablonjo/models/CalcModel.dart';

class CalcProvider with ChangeNotifier {
  CalcModel _calcModel;
  CalcModel get calcModel => _calcModel;
  set setCalcModel(CalcModel val) {
    _calcModel = val;
    notifyListeners();
  }

  List<CalcModel> _calcModels = [];
  List<CalcModel> get calcModels => _calcModels;
  set setCalcModels(List<CalcModel> val) {
    _calcModels = val;
    notifyListeners();
  }

  void addCalc(CalcModel val) {
    _calcModels.add(val);
    notifyListeners();
  }

  void clearAllCalc() {
    _calcModels.clear();
    _total = 0;
    notifyListeners();
  }

  double _total = 0;
  double get total => _total;
  set setTotal(double val) {
    _total += val;
    notifyListeners();
  }
}
