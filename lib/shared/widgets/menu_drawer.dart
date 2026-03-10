// lib/calculators/basic_calc/sreens/menu_drawer.dart

import 'package:calculators/l10n/app_localizations.dart';
import 'package:calculators/navigation/menu_catalog.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:calculators/shared/theme/theme_dialog.dart' as shared_theme_dialog;
import 'package:calculators/shared/theme/theme_manager.dart' as shared_theme;

const String _actionThemes = 'action:themes';
const String _actionWhoAmI = 'action:who_am_i';
const String _actionDonate = 'action:donate';
const String _routePrefix = 'route:';

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
                  showDonateDialog(context); // links to the donation dialog
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currentRoute = ModalRoute.of(context)?.settings.name;
    final modules = buildModuleMenuCatalog(l10n);

    final List<PopupMenuEntry<String>> items = [
      PopupMenuItem<String>(value: _actionThemes, child: Text(l10n.menuThemes)),
      PopupMenuItem<String>(value: _actionWhoAmI, child: Text(l10n.menuWhoAmI)),
      PopupMenuItem<String>(value: _actionDonate, child: Text(l10n.menuDonate)),
    ];

    for (final section in ModuleSection.values) {
      final sectionModules = modules.where((module) => module.section == section).toList();
      if (sectionModules.isEmpty) {
        continue;
      }

      items.add(const PopupMenuDivider());
      items.add(
        PopupMenuItem<String>(
          enabled: false,
          child: Text(sectionTitle(section, l10n), style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      );

      for (final module in sectionModules) {
        items.add(PopupMenuItem<String>(value: '$_routePrefix${module.routeName}', child: Text(module.label)));
      }
    }

    return PopupMenuButton<String>(
      icon: const Icon(Icons.menu),
      onSelected: (String value) {
        if (value == _actionThemes) {
          shared_theme_dialog.showThemeDialog(context, themeManager);
          return;
        }
        if (value == _actionWhoAmI) {
          showWhoAmIDialog(context);
          return;
        }
        if (value == _actionDonate) {
          showDonateDialog(context);
          return;
        }
        if (value.startsWith(_routePrefix)) {
          final routeName = value.substring(_routePrefix.length);
          if (routeName == currentRoute) {
            return;
          }

          // Schedule navigation after popup route teardown to avoid transient layout/hit-test issues.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context, rootNavigator: true).pushNamed(routeName);
          });
        }
      },
      itemBuilder: (BuildContext context) => items,
    );
  }
}
