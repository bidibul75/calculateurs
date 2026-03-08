import 'package:calculators/l10n/app_localizations.dart';
import 'package:calculators/navigation/app_routes.dart';

enum ModuleSection {
  health,
  conversions,
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
  ];
}

String sectionTitle(ModuleSection section, AppLocalizations l10n) {
  switch (section) {
    case ModuleSection.health:
      return l10n.menuSectionHealth;
    case ModuleSection.conversions:
      return l10n.menuSectionConversions;
    case ModuleSection.finance:
      return l10n.menuSectionFinance;
    case ModuleSection.realEstate:
      return l10n.menuSectionRealEstate;
  }
}

