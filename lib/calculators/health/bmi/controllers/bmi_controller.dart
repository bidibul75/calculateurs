// lib/calculators/health/bmi/controllers/bmi_controller.dart

import 'package:flutter/foundation.dart';
import '../models/bmi_state.dart';
import '../services/bmi_logic.dart';

/// Controller for BMI calculator
class BmiController extends ChangeNotifier {
  static const String actionEnter = 'action_enter';

  BmiState _state = const BmiState();

  // Localized prompts (set from screen)
  String promptHeight = 'Height (m):';
  String promptWeight = 'Weight (kg):';
  String promptResult = 'BMI:';
  String errorInvalidHeight = 'Error: incorrect height';
  String errorInvalidWeight = 'Error: incorrect weight';
  String errorInvalidResult = 'Error';

  BmiState get state => _state;

  /// Initialize with localized prompts
  void initialize(
    String heightPrompt,
    String weightPrompt,
    String resultPrompt,
    String invalidHeightMessage,
    String invalidWeightMessage,
    String invalidResultMessage,
  ) {
    promptHeight = heightPrompt;
    promptWeight = weightPrompt;
    promptResult = resultPrompt;
    errorInvalidHeight = invalidHeightMessage;
    errorInvalidWeight = invalidWeightMessage;
    errorInvalidResult = invalidResultMessage;
    _state = BmiState(prompt: promptHeight);
  }

  /// Handle button press
  void onButtonPressed(String label) {
    if (label == 'C') {
      _clear();
    } else if (label == '⌫') {
      _backspace();
    } else if (label == actionEnter) {
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
      hasError: false,
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
        hasError: false,
      );
      notifyListeners();
    }
  }

  /// Append character to input
  void _appendToInput(String char) {
    final newInput = _state.currentInput + char;
    _state = _state.copyWith(currentInput: newInput, output: newInput.isNotEmpty ? newInput : '0', hasError: false);
    notifyListeners();
  }

  /// Handle Enter button
  void _handleEnter() {
    if (_state.currentInput.isEmpty) return;

    if (!_state.isHeightComplete) {
      if (BmiLogic.isHeightCorrect(_state.currentInput)) {
        // First entry: height
        _state = _state.copyWith(
          height: _state.currentInput,
          currentInput: '',
          output: '0',
          isHeightComplete: true,
          hasError: false,
          prompt: promptWeight,
        );
        notifyListeners();
      } else {
        // First entry: height
        _state = _state.copyWith(
          height: '',
          currentInput: '',
          output: errorInvalidHeight,
          isHeightComplete: false,
          hasError: true,
          prompt: promptHeight,
        );
        notifyListeners();
      }
    } else {
      // Second entry: weight, calculate BMI
      final weight = _state.currentInput;
      if (!BmiLogic.isWeightCorrect(weight)) {
        _state = _state.copyWith(
          currentInput: '',
          output: errorInvalidWeight,
          isHeightComplete: true,
          hasError: true,
          prompt: promptWeight,
        );
        notifyListeners();
      } else {
        final height = _state.height!;
        final bmiResult = BmiLogic.calculateBmi(height, weight);
        if (bmiResult == BmiLogic.errorToken) {
          _state = _state.copyWith(
            currentInput: '',
            output: errorInvalidResult,
            isHeightComplete: true,
            hasError: true,
            prompt: promptWeight,
          );
        } else {
          _state = _state.copyWith(
            weight: weight,
            currentInput: '',
            output: bmiResult,
            prompt: promptResult,
            hasError: false,
          );
        }
        notifyListeners();
      }
    }
  }
}
