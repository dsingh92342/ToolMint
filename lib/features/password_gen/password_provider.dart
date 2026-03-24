import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PasswordSettings {
  final int length;
  final bool includeUppercase;
  final bool includeNumbers;
  final bool includeSymbols;

  PasswordSettings({
    this.length = 12,
    this.includeUppercase = true,
    this.includeNumbers = true,
    this.includeSymbols = true,
  });

  PasswordSettings copyWith({
    int? length,
    bool? includeUppercase,
    bool? includeNumbers,
    bool? includeSymbols,
  }) {
    return PasswordSettings(
      length: length ?? this.length,
      includeUppercase: includeUppercase ?? this.includeUppercase,
      includeNumbers: includeNumbers ?? this.includeNumbers,
      includeSymbols: includeSymbols ?? this.includeSymbols,
    );
  }
}

class PasswordNotifier extends StateNotifier<PasswordSettings> {
  PasswordNotifier() : super(PasswordSettings());

  void setLength(double value) => state = state.copyWith(length: value.round());
  void toggleUppercase(bool? value) => state = state.copyWith(includeUppercase: value ?? false);
  void toggleNumbers(bool? value) => state = state.copyWith(includeNumbers: value ?? false);
  void toggleSymbols(bool? value) => state = state.copyWith(includeSymbols: value ?? false);

  String generate() {
    const String lowercase = 'abcdefghijklmnopqrstuvwxyz';
    const String uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const String numbers = '0123456789';
    const String symbols = '!@#\$%^&*()_+=-[]{}|;:,.<>?';

    String allowedChars = lowercase;
    if (state.includeUppercase) allowedChars += uppercase;
    if (state.includeNumbers) allowedChars += numbers;
    if (state.includeSymbols) allowedChars += symbols;

    final random = Random.secure();
    return List.generate(state.length, (index) {
      return allowedChars[random.nextInt(allowedChars.length)];
    }).join();
  }
}

final passwordProvider = StateNotifierProvider<PasswordNotifier, PasswordSettings>((ref) {
  return PasswordNotifier();
});
