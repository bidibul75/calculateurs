import 'package:calculators/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'theme_manager.dart';

/// Shows a dialog to customize shared theme settings.
void showThemeDialog(BuildContext context, ThemeManager themeManager) {
  final l10n = AppLocalizations.of(context);
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AnimatedBuilder(
        animation: themeManager,
        builder: (context, _) {
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
                    runSpacing: 8,
                    children: [
                      _BackgroundImageOption(
                        assetPath: ThemeManager.wallpaperAssetPath,
                        label: l10n.themeBackgroundWallpaper,
                        isSelected: themeManager.backgroundPresetId == ThemeManager.backgroundPresetWallpaper,
                        onTap: () => themeManager.setBackgroundPreset(ThemeManager.backgroundPresetWallpaper),
                      ),
                      _BackgroundImageOption(
                        assetPath: ThemeManager.brushedMetalAssetPath,
                        label: l10n.themeBackgroundMetal,
                        isSelected: themeManager.backgroundPresetId == ThemeManager.backgroundPresetBrushedMetal,
                        onTap: () => themeManager.setBackgroundPreset(ThemeManager.backgroundPresetBrushedMetal),
                      ),
                      _ColorOption(
                        color: Colors.grey[200]!,
                        label: l10n.themeBackgroundNeutral,
                        isSelected: themeManager.backgroundPresetId == ThemeManager.backgroundPresetSoftGrey,
                        onTap: () => themeManager.setBackgroundPreset(ThemeManager.backgroundPresetSoftGrey),
                      ),
                      _ColorOption(
                        color: Colors.white,
                        label: l10n.colorWhite,
                        isSelected: themeManager.backgroundPresetId == ThemeManager.backgroundPresetWhite,
                        onTap: () => themeManager.setBackgroundPreset(ThemeManager.backgroundPresetWhite),
                      ),
                      _ColorOption(
                        color: Colors.grey[900]!,
                        label: l10n.colorDark,
                        isSelected: themeManager.backgroundPresetId == ThemeManager.backgroundPresetDark,
                        onTap: () => themeManager.setBackgroundPreset(ThemeManager.backgroundPresetDark),
                      ),
                      _ColorOption(
                        color: Colors.blue[50]!,
                        label: l10n.colorLightBlue,
                        isSelected: themeManager.backgroundPresetId == ThemeManager.backgroundPresetLightBlue,
                        onTap: () => themeManager.setBackgroundPreset(ThemeManager.backgroundPresetLightBlue),
                      ),
                      _ColorOption(
                        color: Colors.amber[50]!,
                        label: l10n.colorLightAmber,
                        isSelected: themeManager.backgroundPresetId == ThemeManager.backgroundPresetLightAmber,
                        onTap: () => themeManager.setBackgroundPreset(ThemeManager.backgroundPresetLightAmber),
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
    },
  );
}

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
        child: Center(child: Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10))),
      ),
    );
  }
}

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

class _BackgroundImageOption extends StatelessWidget {
  final String assetPath;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _BackgroundImageOption({
    required this.assetPath,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 68,
        height: 68,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isSelected ? Colors.black : Colors.grey, width: isSelected ? 3 : 1),
          image: DecorationImage(image: AssetImage(assetPath), fit: BoxFit.cover),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withAlpha(110)],
                ),
              ),
            ),
            const Center(
              child: Icon(Icons.photo_library_outlined, color: Colors.white, size: 22),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(110),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


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

