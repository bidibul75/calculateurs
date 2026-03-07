// lib/calculators/basic_calc/sreens/menu_drawer.dart

import 'package:flutter/material.dart';
import 'package:calculators/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'theme/theme_dialog.dart';
import 'theme/theme_manager.dart';

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
            Text(
              l10n.donateOutro,
              style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.close))],
      );
    },
  );
}

/// The burger menu displayed in the AppBar
class MenuDrawer extends StatelessWidget {
  final ThemeManager themeManager;

  const MenuDrawer({super.key, required this.themeManager});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PopupMenuButton<String>(
      icon: const Icon(Icons.menu),
      onSelected: (String value) {
        if (value == 'themes') {
          showThemeDialog(context, themeManager);
        } else if (value == 'who_am_i') {
          showWhoAmIDialog(context);
        } else if (value == 'donate') {
          showDonateDialog(context);
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(value: 'themes', child: Text(l10n.menuThemes)),
        PopupMenuItem<String>(value: 'who_am_i', child: Text(l10n.menuWhoAmI)),
        PopupMenuItem<String>(value: 'donate', child: Text(l10n.menuDonate)),
      ],
    );
  }
}
