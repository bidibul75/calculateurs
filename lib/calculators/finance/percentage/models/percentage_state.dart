/// Calculation modes for the percentage / price helper.
enum PercentageMode {
  tax,
  discount,
  increase,
  tip,
}

/// Editable fields shared across modes.
///
/// - [primary]: net / original / bill amount
/// - [rate]: percentage rate
/// - [delta]: tax / discount / increase / tip amount
/// - [result]: gross / final / total amount
enum PercentageField {
  primary,
  rate,
  delta,
  result,
}

class PercentageState {
  final PercentageMode mode;
  final PercentageField activeField;
  final String currentInput;
  final String primary;
  final String rate;
  final String delta;
  final String result;

  const PercentageState({
    required this.mode,
    required this.activeField,
    required this.currentInput,
    required this.primary,
    required this.rate,
    required this.delta,
    required this.result,
  });

  factory PercentageState.initial({PercentageMode mode = PercentageMode.tax}) {
    return PercentageState(
      mode: mode,
      activeField: PercentageField.primary,
      currentInput: '0',
      primary: '0',
      rate: '0',
      delta: '0',
      result: '0',
    );
  }

  PercentageState copyWith({
    PercentageMode? mode,
    PercentageField? activeField,
    String? currentInput,
    String? primary,
    String? rate,
    String? delta,
    String? result,
  }) {
    return PercentageState(
      mode: mode ?? this.mode,
      activeField: activeField ?? this.activeField,
      currentInput: currentInput ?? this.currentInput,
      primary: primary ?? this.primary,
      rate: rate ?? this.rate,
      delta: delta ?? this.delta,
      result: result ?? this.result,
    );
  }
}
