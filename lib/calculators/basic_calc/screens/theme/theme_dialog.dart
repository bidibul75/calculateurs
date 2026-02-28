// lib/calculators/basic_calc/sreens/theme/theme_dialog.dart

import 'package:flutter/material.dart';
import 'theme_manager.dart';

/// Shows a dialog to customize theme settings
void showThemeDialog(BuildContext context, ThemeManager themeManager) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Theme Settings'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Background Color:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  _ColorOption(
                    color: Colors.white,
                    label: 'White',
                    isSelected: themeManager.backgroundColor == Colors.white,
                    onTap: () => themeManager.setBackgroundColor(Colors.white),
                  ),
                  _ColorOption(
                    color: Colors.grey[900]!,
                    label: 'Dark',
                    isSelected: themeManager.backgroundColor == Colors.grey[900]!,
                    onTap: () => themeManager.setBackgroundColor(Colors.grey[900]!),
                  ),
                  _ColorOption(
                    color: Colors.blue[50]!,
                    label: 'Light Blue',
                    isSelected: themeManager.backgroundColor == Colors.blue[50]!,
                    onTap: () => themeManager.setBackgroundColor(Colors.blue[50]!),
                  ),
                  _ColorOption(
                    color: Colors.amber[50]!,
                    label: 'Light Amber',
                    isSelected: themeManager.backgroundColor == Colors.amber[50]!,
                    onTap: () => themeManager.setBackgroundColor(Colors.amber[50]!),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text('Button Groups Color:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  _ButtonGroupColorOption(
                    color: Colors.grey[850]!,
                    label: 'Dark Grey',
                    isSelected: themeManager.buttonGroupColor == Colors.grey[850]!,
                    onTap: () => themeManager.setButtonGroupColor(Colors.grey[850]!),
                  ),
                  _ButtonGroupColorOption(
                    color: Colors.blue[800]!,
                    label: 'Blue',
                    isSelected: themeManager.buttonGroupColor == Colors.blue[800]!,
                    onTap: () => themeManager.setButtonGroupColor(Colors.blue[800]!),
                  ),
                  _ButtonGroupColorOption(
                    color: Colors.purple[800]!,
                    label: 'Purple',
                    isSelected: themeManager.buttonGroupColor == Colors.purple[800]!,
                    onTap: () => themeManager.setButtonGroupColor(Colors.purple[800]!),
                  ),
                  _ButtonGroupColorOption(
                    color: Colors.teal[800]!,
                    label: 'Teal',
                    isSelected: themeManager.buttonGroupColor == Colors.teal[800]!,
                    onTap: () => themeManager.setButtonGroupColor(Colors.teal[800]!),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close'))],
      );
    },
  );
}

/// Widget for background color selection
class _ColorOption extends StatelessWidget {
  final Color color;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ColorOption({required this.color, required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: isSelected ? Colors.black : Colors.grey, width: isSelected ? 3 : 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10)),
        ),
      ),
    );
  }
}

/// Widget for button group color selection
class _ButtonGroupColorOption extends StatelessWidget {
  final Color color;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ButtonGroupColorOption({
    required this.color,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: isSelected ? Colors.white : Colors.grey, width: isSelected ? 3 : 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
