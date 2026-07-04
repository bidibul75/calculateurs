// lib/navigation/menu_catalog.dart
import 'package:calculators/l10n/app_localizations.dart';
import 'package:calculators/navigation/app_routes.dart';

enum ModuleSection {
  health,
  conversions,
  ipTools,
  finance,
  realEstate,
}

class ModuleMenuItem {
  final ModuleSection section;
  final String routeName;
  final String label;

  const ModuleMenuItem({
    required this.section,
    required this.routeName,
    required this.label,
  });
}

List<ModuleMenuItem> buildModuleMenuCatalog(AppLocalizations l10n) {
  return [
    ModuleMenuItem(
      section: ModuleSection.health,
      routeName: AppRoutes.bmi,
      label: l10n.menuBmi,
    ),
    ModuleMenuItem(
      section: ModuleSection.conversions,
      routeName: AppRoutes.temperature,
      label: l10n.menuTemperature,
    ),
    ModuleMenuItem(
      section: ModuleSection.ipTools,
      routeName: AppRoutes.ipv4Address,
      label: l10n.menuIpv4Address,
    ),
    ModuleMenuItem(
      section: ModuleSection.ipTools,
      routeName: AppRoutes.ipv4Supernet,
      label: l10n.menuIpv4Supernet,
    ),
    ModuleMenuItem(
      section: ModuleSection.ipTools,
      routeName: AppRoutes.ipv6Address,
      label: l10n.menuIpv6Address,
    ),
    ModuleMenuItem(
      section: ModuleSection.ipTools,
      routeName: AppRoutes.ipv6Supernet,
      label: l10n.menuIpv6Supernet,
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
