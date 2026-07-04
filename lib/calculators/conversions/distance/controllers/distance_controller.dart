// lib/calculators/conversions/distance/controllers/distance_controller.dart

import 'package:flutter/material.dart';
import '../models/distance_state.dart';
import '../services/distance_logic.dart';

class DistanceController extends ChangeNotifier {
  DistanceState _state = const DistanceState();

  DistanceState get state => _state;

  void updateMetric(String value, DistanceUnit unit) {
    _state = DistanceLogic.convert(
      input: value,
      fromUnit: unit,
      targetMetric: unit,
      targetImperial: _state.imperialUnit,
    );
    notifyListeners();
  }

  void updateImperial(String value, DistanceUnit unit) {
    _state = DistanceLogic.convert(input: value, fromUnit: unit, targetMetric: _state.metricUnit, targetImperial: unit);
    notifyListeners();
  }

  void updateNautical(String value) {
    _state = DistanceLogic.convert(
      input: value,
      fromUnit: DistanceUnit.nmi,
      targetMetric: _state.metricUnit,
      targetImperial: _state.imperialUnit,
    );
    notifyListeners();
  }

  void changeMetricUnit(DistanceUnit newUnit) {
    if (_state.metricValue.isNotEmpty) {
      _state = DistanceLogic.convert(
        input: _state.metricValue,
        fromUnit: _state.metricUnit,
        targetMetric: newUnit,
        targetImperial: _state.imperialUnit,
      );
    } else {
      _state = _state.copyWith(metricUnit: newUnit);
    }
    notifyListeners();
  }

  void changeImperialUnit(DistanceUnit newUnit) {
    if (_state.imperialValue.isNotEmpty) {
      _state = DistanceLogic.convert(
        input: _state.imperialValue,
        fromUnit: _state.imperialUnit,
        targetMetric: _state.metricUnit,
        targetImperial: newUnit,
      );
    } else {
      _state = _state.copyWith(imperialUnit: newUnit);
    }
    notifyListeners();
  }

  void clear() {
    _state = const DistanceState();
    notifyListeners();
  }
}
