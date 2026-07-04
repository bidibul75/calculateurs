// lib/shared/widgets/menu_drawer.dart
// lib/calculators/basic_calc/sreens/menu_drawer.dart

import 'dart:async';

import 'package:calculators/l10n/app_localizations.dart';
import 'package:calculators/navigation/app_routes.dart';
import 'package:calculators/navigation/menu_catalog.dart';
import 'package:calculators/shared/theme/theme_dialog.dart' as shared_theme_dialog;
import 'package:calculators/shared/theme/theme_manager.dart' as shared_theme;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Shows the "Who am I" dialog
void showWhoAmIDialog(BuildContext context) {
  final l10n = AppLocalizations.of(context);
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(l10n.whoAmITitle),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.whoAmIBody),
              const SizedBox(height: 8),
              // Email link
              // TODO : verify if I want to use this email address
              InkWell(
                onTap: () => _launchUrl('mailto:dev@calculation.center'),
                child: const Text(
                  '📧 dev@calculation.center',
                  style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                ),
              ),
              const SizedBox(height: 8),
              // LinkedIn link
              // TODO : replace the link by the good one
              InkWell(
                onTap: () => _launchUrl('https://www.linkedin.com/in/LINKEDIN_PROFILE/'),
                child: Text(
                  '🔗 ${l10n.whoAmILinkedIn}',
                  style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  showDonateDialog(context);
                },
                child: Text(
                  l10n.whoAmIDonateCta,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.close))],
      );
    },
  );
}

/// Launch URL helper function
Future<void> _launchUrl(String urlString) async {
  final Uri url = Uri.parse(urlString);
  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $urlString');
  }
}

/// Shows the "Donate" dialog
void showDonateDialog(BuildContext context) {
  final l10n = AppLocalizations.of(context);
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(l10n.donateTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.donateIntro),
            const SizedBox(height: 16),
            // Donation link
            // TODO : replace the link by the good one
            InkWell(
              onTap: () => _launchUrl('https://www.paypal.com/donate/?hosted_button_id=YOUR_BUTTON_ID'),
              child: Row(
                children: [
                  const Icon(Icons.favorite, color: Colors.red),
                  const SizedBox(width: 8),
                  Text(
                    l10n.donateViaPaypal,
                    style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline, fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(l10n.donateOutro, style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.close))],
      );
    },
  );
}

/// The burger menu displayed in the AppBar
class MenuDrawer extends StatelessWidget {
  final shared_theme.ThemeManager themeManager;

  const MenuDrawer({super.key, required this.themeManager});

  bool _isMobilePlatform(TargetPlatform platform) {
    return platform == TargetPlatform.android || platform == TargetPlatform.iOS;
  }

  void _navigateToRoute(BuildContext context, String routeName) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    if (currentRoute == routeName) {
      return;
    }
    unawaited(AppRoutes.saveLastRoute(routeName));
    Navigator.of(context, rootNavigator: true).pushNamed(routeName);
  }

  List<Widget> _buildMenuTiles(
    BuildContext context,
    BuildContext sheetContext,
    AppLocalizations l10n,
    List<ModuleMenuItem> healthModules,
    List<ModuleMenuItem> conversionModules,
    List<ModuleMenuItem> ipToolsModules,
  ) {
    return [
      ListTile(
        leading: const Icon(Icons.palette_outlined),
        title: Text(l10n.menuThemes),
        onTap: () {
          Navigator.of(sheetContext).pop();
          shared_theme_dialog.showThemeDialog(context, themeManager);
        },
      ),
      ListTile(
        leading: const Icon(Icons.badge_outlined),
        title: Text(l10n.menuWhoAmI),
        onTap: () {
          Navigator.of(sheetContext).pop();
          showWhoAmIDialog(context);
        },
      ),
      ListTile(
        leading: const Icon(Icons.favorite_outline),
        title: Text(l10n.menuDonate),
        onTap: () {
          Navigator.of(sheetContext).pop();
          showDonateDialog(context);
        },
      ),
      const Divider(),
      ListTile(
        leading: const Icon(Icons.calculate_outlined),
        title: Text(l10n.appTitle),
        onTap: () {
          Navigator.of(sheetContext).pop();
          _navigateToRoute(context, AppRoutes.home);
        },
      ),
      if (healthModules.isNotEmpty)
        ExpansionTile(
          leading: const Icon(Icons.health_and_safety_outlined),
          title: Text(sectionTitle(ModuleSection.health, l10n)),
          children: [
            for (final module in healthModules)
              ListTile(
                contentPadding: const EdgeInsets.only(left: 56, right: 16),
                title: Text(module.label),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _navigateToRoute(context, module.routeName);
                },
              ),
          ],
        ),
      if (conversionModules.isNotEmpty)
        ExpansionTile(
          leading: const Icon(Icons.swap_horiz_outlined),
          title: Text(sectionTitle(ModuleSection.conversions, l10n)),
          children: [
            for (final module in conversionModules)
              ListTile(
                contentPadding: const EdgeInsets.only(left: 56, right: 16),
                title: Text(module.label),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _navigateToRoute(context, module.routeName);
                },
              ),
          ],
        ),
      if (ipToolsModules.isNotEmpty)
        ExpansionTile(
          leading: const Icon(Icons.language_outlined),
          title: Text(sectionTitle(ModuleSection.ipTools, l10n)),
          children: [
            for (final module in ipToolsModules)
              ListTile(
                contentPadding: const EdgeInsets.only(left: 56, right: 16),
                title: Text(module.label),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _navigateToRoute(context, module.routeName);
                },
              ),
          ],
        ),
    ];
  }

  void _showMenuSheet(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final modules = buildModuleMenuCatalog(l10n);
    final healthModules = modules.where((module) => module.section == ModuleSection.health).toList();
    final conversionModules = modules.where((module) => module.section == ModuleSection.conversions).toList();
    final ipToolsModules = modules.where((module) => module.section == ModuleSection.ipTools).toList();
    final isMobileSheet = !kIsWeb && _isMobilePlatform(Theme.of(context).platform);

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: isMobileSheet,
      builder: (sheetContext) {
        final menuList = ListView(
          padding: EdgeInsets.only(top: isMobileSheet ? 8 : 0, bottom: isMobileSheet ? 16 : 0),
          children: _buildMenuTiles(context, sheetContext, l10n, healthModules, conversionModules, ipToolsModules),
        );

        return SafeArea(
          child: isMobileSheet
              ? ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: MediaQuery.of(sheetContext).size.height * 0.92),
                  child: Scrollbar(thumbVisibility: true, child: menuList),
                )
              : menuList,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(icon: const Icon(Icons.menu), onPressed: () => _showMenuSheet(context));
  }
}
