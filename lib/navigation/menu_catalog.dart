// lib/navigation/menu_catalog.dart
import 'package:calculators/l10n/app_localizations.dart';
import 'package:calculators/navigation/app_routes.dart';
import 'package:flutter/material.dart';

enum ModuleSection {
  health,
  conversions,
  ipTools,
  finance,
  realEstate,
}

class ModuleMenuItem {
  final Icon? icon;
  final ModuleSection section;
  final String routeName;
  final String label;

  const ModuleMenuItem({
    this.icon,
    required this.section,
    required this.routeName,
    required this.label,
  });
}

List<ModuleMenuItem> buildModuleMenuCatalog(AppLocalizations l10n) {
  return [
    ModuleMenuItem(
      icon: Icon(Icons.scale),
      section: ModuleSection.health,
      routeName: AppRoutes.bmi,
      label: l10n.menuBmi,
    ),
    ModuleMenuItem(
      icon: Icon(Icons.thermostat),
      section: ModuleSection.conversions,
      routeName: AppRoutes.temperature,
      label: l10n.menuTemperature,
    ),
    ModuleMenuItem(
      icon: Icon(Icons.straighten),
      section: ModuleSection.conversions,
      routeName: AppRoutes.distance,
      label: l10n.menuDistance,
    ),
    ModuleMenuItem(
      icon: Icon(Icons.settings_ethernet),
      section: ModuleSection.ipTools,
      routeName: AppRoutes.ipv4Address,
      label: l10n.menuIpv4Address,
    ),
    ModuleMenuItem(
      icon: Icon(Icons.settings_ethernet),
      section: ModuleSection.ipTools,
      routeName: AppRoutes.ipv4Supernet,
      label: l10n.menuIpv4Supernet,
    ),
    ModuleMenuItem(
      icon: Icon(Icons.settings_ethernet),
      section: ModuleSection.ipTools,
      routeName: AppRoutes.ipv6Address,
      label: l10n.menuIpv6Address,
    ),
    ModuleMenuItem(
      icon: Icon(Icons.settings_ethernet),
      section: ModuleSection.ipTools,
      routeName: AppRoutes.ipv6Supernet,
      label: l10n.menuIpv6Supernet,
    ),
    ModuleMenuItem(
      icon: const Icon(Icons.functions),
      section: ModuleSection.conversions,
      routeName: AppRoutes.average,
      label: l10n.menuAverage,
    ),
  ];
}

String sectionTitle(ModuleSection section, AppLocalizations l10n) {
  switch (section) {
    case ModuleSection.health:
      return l10n.menuSectionHealth;
    case ModuleSection.conversions:
      return l10n.menuSectionConversions;
    case ModuleSection.ipTools:
      return l10n.menuSectionIpTools;
    case ModuleSection.finance:
      return l10n.menuSectionFinance;
    case ModuleSection.realEstate:
      return l10n.menuSectionRealEstate;
  }
}
