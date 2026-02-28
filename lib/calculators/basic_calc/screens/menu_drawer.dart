// lib/calculators/basic_calc/sreens/menu_drawer.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'theme/theme_dialog.dart';
import 'theme/theme_manager.dart';

/// Shows the "Who am I" dialog
void showWhoAmIDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Who am I'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'My name is Walter Bianchi, I am a software developer with a passion for creating useful and beautiful applications.\n\n'
                'I built this calculator to provide a simple yet powerful tool for calculations.\n\n'
                'I hope you find it helpful!\n\n'
                'I\'m looking for a job, so if you like this project (written in Flutter) and want to work with me, don\'t hesitate to contact me!\n',
              ),
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
                child: const Text(
                  '🔗 LinkedIn Profile',
                  style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  showDonateDialog(context); // links to the donation dialog
                },
                child: const Text(
                  'Donations welcome!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close'))],
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
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Donate'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thank you for using this calculator!\n\n'
              'If you find this app useful and want to support its development, you can make a donation:\n',
            ),
            const SizedBox(height: 16),
            // Donation link
            // TODO : replace the link by the good one
            InkWell(
              onTap: () => _launchUrl('https://www.paypal.com/donate/?hosted_button_id=YOUR_BUTTON_ID'),
              child: const Row(
                children: [
                  Icon(Icons.favorite, color: Colors.red),
                  SizedBox(width: 8),
                  Text(
                    'Donate via PayPal',
                    style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline, fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Every contribution helps improve this app!',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close'))],
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
        const PopupMenuItem<String>(value: 'themes', child: Text('Themes')),
        const PopupMenuItem<String>(value: 'who_am_i', child: Text('Who am I')),
        const PopupMenuItem<String>(value: 'donate', child: Text('Donate')),
      ],
    );
  }
}
