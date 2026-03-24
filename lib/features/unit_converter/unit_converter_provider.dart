import 'package:flutter_riverpod/flutter_riverpod.dart';

enum UnitCategory { length, weight, temperature }

class UnitConverterState {
  final UnitCategory category;
  final String fromUnit;
  final String toUnit;
  final double fromValue;
  final double toValue;

  UnitConverterState({
    this.category = UnitCategory.length,
    this.fromUnit = 'Meters',
    this.toUnit = 'Kilometers',
    this.fromValue = 0,
    this.toValue = 0,
  });

  UnitConverterState copyWith({
    UnitCategory? category,
    String? fromUnit,
    String? toUnit,
    double? fromValue,
    double? toValue,
  }) {
    return UnitConverterState(
      category: category ?? this.category,
      fromUnit: fromUnit ?? this.fromUnit,
      toUnit: toUnit ?? this.toUnit,
      fromValue: fromValue ?? this.fromValue,
      toValue: toValue ?? this.toValue,
    );
  }
}

class UnitConverterNotifier extends StateNotifier<UnitConverterState> {
  UnitConverterNotifier() : super(UnitConverterState());

  void setCategory(UnitCategory category) {
    String from = 'Meters';
    String to = 'Kilometers';
    if (category == UnitCategory.weight) {
      from = 'Kilograms';
      to = 'Grams';
    } else if (category == UnitCategory.temperature) {
      from = 'Celsius';
      to = 'Fahrenheit';
    }
    state = state.copyWith(category: category, fromUnit: from, toUnit: to);
    convert(state.fromValue);
  }

  void setFromUnit(String unit) {
    state = state.copyWith(fromUnit: unit);
    convert(state.fromValue);
  }

  void setToUnit(String unit) {
    state = state.copyWith(toUnit: unit);
    convert(state.fromValue);
  }

  void convert(double value) {
    double result = 0;
    if (state.category == UnitCategory.length) {
      result = _convertLength(value, state.fromUnit, state.toUnit);
    } else if (state.category == UnitCategory.weight) {
      result = _convertWeight(value, state.fromUnit, state.toUnit);
    } else if (state.category == UnitCategory.temperature) {
      result = _convertTemperature(value, state.fromUnit, state.toUnit);
    }
    state = state.copyWith(fromValue: value, toValue: result);
  }

  double _convertLength(double val, String from, String to) {
    // Basic meters mapping
    Map<String, double> toMeters = {
      'Meters': 1.0,
      'Kilometers': 1000.0,
      'Feet': 0.3048,
      'Inches': 0.0254,
    };
    double meters = val * toMeters[from]!;
    return meters / toMeters[to]!;
  }

  double _convertWeight(double val, String from, String to) {
    Map<String, double> toGrams = {
      'Grams': 1.0,
      'Kilograms': 1000.0,
      'Pounds': 453.592,
    };
    double grams = val * toGrams[from]!;
    return grams / toGrams[to]!;
  }

  double _convertTemperature(double val, String from, String to) {
    if (from == to) return val;
    if (from == 'Celsius' && to == 'Fahrenheit') return (val * 9 / 5) + 32;
    if (from == 'Fahrenheit' && to == 'Celsius') return (val - 32) * 5 / 9;
    return val;
  }
}

final unitConverterProvider =
    StateNotifierProvider<UnitConverterNotifier, UnitConverterState>((ref) {
  return UnitConverterNotifier();
});
