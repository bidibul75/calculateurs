// lib/shared/widgets/photo_credit_link.dart
import 'package:calculators/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PhotoCreditLink extends StatelessWidget {
  const PhotoCreditLink({
    super.key,
    this.color = Colors.white,
    this.fontSize = 12,
  });

  final Color color;
  final double fontSize;

  static final Uri _photoCreditUri = Uri.parse(
    'https://unsplash.com/fr/photos/champ-dherbe-verte-pendant-la-journee-5HI7Ea3yD-w?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText',
  );

  Future<void> _launchPhotoCredits() async {
    if (!await launchUrl(_photoCreditUri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch photo credits');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _launchPhotoCredits,
        child: Text(
          l10n.photoCredit,
          style: TextStyle(color: color, fontSize: fontSize, decoration: TextDecoration.underline),
        ),
      ),
    );
  }
}

