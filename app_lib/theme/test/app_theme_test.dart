import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ThemeMode.light toString returns expected value', () {
    final lightTheme = ThemeMode.light.toString();
    expect(lightTheme, 'ThemeMode.light');
  });
}
