// lib/calculators/basic_calc/sreens/theme/theme_dialog.dart

import 'package:flutter/material.dart';
import 'package:calculators/l10n/app_localizations.dart';
import 'theme_manager.dart';

/// Shows a dialog to customize theme settings
void showThemeDialog(BuildContext context, ThemeManager themeManager) {
  final l10n = AppLocalizations.of(context);
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(l10n.themeSettingsTitle),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.themeBackgroundColor, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  _ColorOption(
                    color: Colors.white,
                    label: l10n.colorWhite,
                    isSelected: themeManager.backgroundColor == Colors.white,
                    onTap: () => themeManager.setBackgroundColor(Colors.white),
                  ),
                  _ColorOption(
                    color: Colors.grey[900]!,
                    label: l10n.colorDark,
                    isSelected: themeManager.backgroundColor == Colors.grey[900]!,
                    onTap: () => themeManager.setBackgroundColor(Colors.grey[900]!),
                  ),
                  _ColorOption(
                    color: Colors.blue[50]!,
                    label: l10n.colorLightBlue,
                    isSelected: themeManager.backgroundColor == Colors.blue[50]!,
                    onTap: () => themeManager.setBackgroundColor(Colors.blue[50]!),
                  ),
                  _ColorOption(
                    color: Colors.amber[50]!,
                    label: l10n.colorLightAmber,
                    isSelected: themeManager.backgroundColor == Colors.amber[50]!,
                    onTap: () => themeManager.setBackgroundColor(Colors.amber[50]!),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(l10n.themeDisplayTextColor, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  _TextColorOption(
                    color: Colors.black,
                    label: l10n.colorBlack,
                    isSelected: themeManager.displayTextColor == Colors.black,
                    onTap: () => themeManager.setDisplayTextColor(Colors.black),
                  ),
                  _TextColorOption(
                    color: Colors.white,
                    label: l10n.colorWhite,
                    isSelected: themeManager.displayTextColor == Colors.white,
                    onTap: () => themeManager.setDisplayTextColor(Colors.white),
                  ),
                  _TextColorOption(
                    color: Colors.blue[800]!,
                    label: l10n.colorBlue,
                    isSelected: themeManager.displayTextColor == Colors.blue[800]!,
                    onTap: () => themeManager.setDisplayTextColor(Colors.blue[800]!),
                  ),
                  _TextColorOption(
                    color: Colors.green[800]!,
                    label: l10n.colorGreen,
                    isSelected: themeManager.displayTextColor == Colors.green[800]!,
                    onTap: () => themeManager.setDisplayTextColor(Colors.green[800]!),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(l10n.themeButtonGroupsColor, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  _ButtonGroupColorOption(
                    color: Colors.grey[850]!,
                    label: l10n.colorDarkGrey,
                    isSelected: themeManager.buttonGroupColor == Colors.grey[850]!,
                    onTap: () => themeManager.setButtonGroupColor(Colors.grey[850]!),
                  ),
                  _ButtonGroupColorOption(
                    color: Colors.blue[800]!,
                    label: l10n.colorBlue,
                    isSelected: themeManager.buttonGroupColor == Colors.blue[800]!,
                    onTap: () => themeManager.setButtonGroupColor(Colors.blue[800]!),
                  ),
                  _ButtonGroupColorOption(
                    color: Colors.purple[800]!,
                    label: l10n.colorPurple,
                    isSelected: themeManager.buttonGroupColor == Colors.purple[800]!,
                    onTap: () => themeManager.setButtonGroupColor(Colors.purple[800]!),
                  ),
                  _ButtonGroupColorOption(
                    color: Colors.teal[800]!,
                    label: l10n.colorTeal,
                    isSelected: themeManager.buttonGroupColor == Colors.teal[800]!,
                    onTap: () => themeManager.setButtonGroupColor(Colors.teal[800]!),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(l10n.themeButtonTextColor, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  _TextColorOption(
                    color: Colors.grey[200]!,
                    label: l10n.colorLightGrey,
                    isSelected: themeManager.buttonTextColor == Colors.grey[200]!,
                    onTap: () => themeManager.setButtonTextColor(Colors.grey[200]!),
                  ),
                  _TextColorOption(
                    color: Colors.white,
                    label: l10n.colorWhite,
                    isSelected: themeManager.buttonTextColor == Colors.white,
                    onTap: () => themeManager.setButtonTextColor(Colors.white),
                  ),
                  _TextColorOption(
                    color: Colors.black,
                    label: l10n.colorBlack,
                    isSelected: themeManager.buttonTextColor == Colors.black,
                    onTap: () => themeManager.setButtonTextColor(Colors.black),
                  ),
                  _TextColorOption(
                    color: Colors.yellow[700]!,
                    label: l10n.colorYellow,
                    isSelected: themeManager.buttonTextColor == Colors.yellow[700]!,
                    onTap: () => themeManager.setButtonTextColor(Colors.yellow[700]!),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.close))],
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

/// Widget for text color selection
class _TextColorOption extends StatelessWidget {
  final Color color;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TextColorOption({required this.color, required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(color: isSelected ? Colors.black : Colors.grey, width: isSelected ? 3 : 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
