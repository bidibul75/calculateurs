// lib/calculators/health/bmi/controllers/bmi_controller.dart

import 'package:flutter/foundation.dart';
import '../models/bmi_state.dart';
import '../services/bmi_logic.dart';

/// Controller for BMI calculator
class BmiController extends ChangeNotifier {
  BmiState _state = const BmiState();

  // Localized prompts (set from screen)
  String promptHeight = 'Height (m):';
  String promptWeight = 'Weight (kg):';
  String promptResult = 'BMI:';

  BmiState get state => _state;

  /// Initialize with localized prompts
  void initialize(String heightPrompt, String weightPrompt, String resultPrompt) {
    promptHeight = heightPrompt;
    promptWeight = weightPrompt;
    promptResult = resultPrompt;
    _state = BmiState(prompt: promptHeight);
  }

  /// Handle button press
  void onButtonPressed(String label) {
    if (label == 'C') {
      _clear();
    } else if (label == '⌫') {
      _backspace();
    } else if (label == 'Enter') {
      _handleEnter();
    } else {
      _appendToInput(label);
    }
  }

  /// Clear all
  void _clear() {
    _state = BmiState(
      currentInput: '',
      output: '0',
      height: null,
      weight: null,
      isHeightComplete: false,
      prompt: promptHeight,
    );
    notifyListeners();
  }

  /// Backspace
  void _backspace() {
    if (_state.currentInput.isNotEmpty) {
      _state = _state.copyWith(
        currentInput: _state.currentInput.substring(0, _state.currentInput.length - 1),
        output: _state.currentInput.length > 1 ? _state.currentInput.substring(0, _state.currentInput.length - 1) : '0',
      );
      notifyListeners();
    }
  }

  /// Append character to input
  void _appendToInput(String char) {
    final newInput = _state.currentInput + char;
    _state = _state.copyWith(currentInput: newInput, output: newInput.isNotEmpty ? newInput : '0');
    notifyListeners();
  }

  /// Handle Enter button
  void _handleEnter() {
    if (_state.currentInput.isEmpty) return;

    if (!_state.isHeightComplete) {
      // First entry: height
      _state = _state.copyWith(
        height: _state.currentInput,
        currentInput: '',
        output: '0',
        isHeightComplete: true,
        prompt: promptWeight,
      );
      notifyListeners();
    } else {
      // Second entry: weight, calculate BMI
      final weight = _state.currentInput;
      final height = _state.height!;

      final bmiResult = BmiLogic.calculateBmi(height, weight);

      _state = _state.copyWith(weight: weight, currentInput: '', output: bmiResult, prompt: promptResult);
      notifyListeners();
    }
  }
}
