// lib/calculators/health/bmi/controllers/bmi_controller.dart

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/bmi_state.dart';
import '../services/bmi_logic.dart';

/// Controller for BMI calculator
class BmiController extends ChangeNotifier {
  static const String actionEnter = 'action_enter';
  static const String _stateKey = 'bmi.state.v1';

  BmiState _state = const BmiState();
  bool _hasRestoredState = false;

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
    if (_state.prompt.isEmpty && !_hasRestoredState) {
      _state = BmiState(prompt: promptHeight);
    } else {
      _state = _state.copyWith(prompt: _resolvePromptForState(_state));
    }
  }

  Future<void> restorePersistedState() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = prefs.getString(_stateKey);
    if (encoded == null || encoded.isEmpty) {
      _hasRestoredState = true;
      return;
    }

    final segments = encoded.split('|');
    if (segments.length != 6) {
      _hasRestoredState = true;
      return;
    }

    _state = BmiState(
      currentInput: segments[0],
      output: segments[1].isEmpty ? '0' : segments[1],
      height: segments[2].isEmpty ? null : segments[2],
      weight: segments[3].isEmpty ? null : segments[3],
      isHeightComplete: segments[4] == '1',
      hasError: segments[5] == '1',
      prompt: _resolvePromptForState(
        BmiState(
          currentInput: segments[0],
          output: segments[1].isEmpty ? '0' : segments[1],
          height: segments[2].isEmpty ? null : segments[2],
          weight: segments[3].isEmpty ? null : segments[3],
          isHeightComplete: segments[4] == '1',
          hasError: segments[5] == '1',
        ),
      ),
    );
    _hasRestoredState = true;
    notifyListeners();
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
    unawaited(_persistState());
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
      unawaited(_persistState());
    }
  }

  /// Append character to input
  void _appendToInput(String char) {
    final newInput = _state.currentInput + char;
    _state = _state.copyWith(currentInput: newInput, output: newInput.isNotEmpty ? newInput : '0', hasError: false);
    notifyListeners();
    unawaited(_persistState());
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
        unawaited(_persistState());
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
        unawaited(_persistState());
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
        unawaited(_persistState());
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
        unawaited(_persistState());
      }
    }
  }

  String _resolvePromptForState(BmiState state) {
    if (state.weight != null && state.weight!.isNotEmpty && !state.hasError) {
      return promptResult;
    }
    if (state.isHeightComplete) {
      return promptWeight;
    }
    return promptHeight;
  }

  Future<void> _persistState() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = [
      _state.currentInput,
      _state.output,
      _state.height ?? '',
      _state.weight ?? '',
      _state.isHeightComplete ? '1' : '0',
      _state.hasError ? '1' : '0',
    ].join('|');
    await prefs.setString(_stateKey, encoded);
  }
}
