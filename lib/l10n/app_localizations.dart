import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Basic calculator'**
  String get appTitle;

  /// No description provided for @menuThemes.
  ///
  /// In en, this message translates to:
  /// **'Themes'**
  String get menuThemes;

  /// No description provided for @menuWhoAmI.
  ///
  /// In en, this message translates to:
  /// **'Who am I'**
  String get menuWhoAmI;

  /// No description provided for @menuDonate.
  ///
  /// In en, this message translates to:
  /// **'Donate'**
  String get menuDonate;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @whoAmITitle.
  ///
  /// In en, this message translates to:
  /// **'Who am I'**
  String get whoAmITitle;

  /// No description provided for @whoAmIBody.
  ///
  /// In en, this message translates to:
  /// **'My name is Walter Bianchi, I am a software developer with a passion for creating useful and beautiful applications.\n\nI built this calculator to provide a simple yet powerful tool for calculations.\n\nI hope you find it helpful!\n\nI\'m looking for a job, so if you like this project (written in Flutter) and want to work with me, don\'t hesitate to contact me!\n'**
  String get whoAmIBody;

  /// No description provided for @whoAmILinkedIn.
  ///
  /// In en, this message translates to:
  /// **'LinkedIn Profile'**
  String get whoAmILinkedIn;

  /// No description provided for @whoAmIDonateCta.
  ///
  /// In en, this message translates to:
  /// **'Donations welcome!'**
  String get whoAmIDonateCta;

  /// No description provided for @donateTitle.
  ///
  /// In en, this message translates to:
  /// **'Donate'**
  String get donateTitle;

  /// No description provided for @donateIntro.
  ///
  /// In en, this message translates to:
  /// **'Thank you for using this calculator!\n\nIf you find this app useful and want to support its development, you can make a donation:\n'**
  String get donateIntro;

  /// No description provided for @donateViaPaypal.
  ///
  /// In en, this message translates to:
  /// **'Donate via PayPal'**
  String get donateViaPaypal;

  /// No description provided for @donateOutro.
  ///
  /// In en, this message translates to:
  /// **'Every contribution helps improve this app!'**
  String get donateOutro;

  /// No description provided for @themeSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Theme Settings'**
  String get themeSettingsTitle;

  /// No description provided for @themeBackgroundColor.
  ///
  /// In en, this message translates to:
  /// **'Background Color:'**
  String get themeBackgroundColor;

  /// No description provided for @themeDisplayTextColor.
  ///
  /// In en, this message translates to:
  /// **'Display Text Color:'**
  String get themeDisplayTextColor;

  /// No description provided for @themeButtonGroupsColor.
  ///
  /// In en, this message translates to:
  /// **'Button Groups Color:'**
  String get themeButtonGroupsColor;

  /// No description provided for @themeButtonTextColor.
  ///
  /// In en, this message translates to:
  /// **'Button Text Color:'**
  String get themeButtonTextColor;

  /// No description provided for @colorWhite.
  ///
  /// In en, this message translates to:
  /// **'White'**
  String get colorWhite;

  /// No description provided for @colorDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get colorDark;

  /// No description provided for @colorLightBlue.
  ///
  /// In en, this message translates to:
  /// **'Light Blue'**
  String get colorLightBlue;

  /// No description provided for @colorLightAmber.
  ///
  /// In en, this message translates to:
  /// **'Light Amber'**
  String get colorLightAmber;

  /// No description provided for @colorBlack.
  ///
  /// In en, this message translates to:
  /// **'Black'**
  String get colorBlack;

  /// No description provided for @colorBlue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get colorBlue;

  /// No description provided for @colorGreen.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get colorGreen;

  /// No description provided for @colorDarkGrey.
  ///
  /// In en, this message translates to:
  /// **'Dark Grey'**
  String get colorDarkGrey;

  /// No description provided for @colorPurple.
  ///
  /// In en, this message translates to:
  /// **'Purple'**
  String get colorPurple;

  /// No description provided for @colorTeal.
  ///
  /// In en, this message translates to:
  /// **'Teal'**
  String get colorTeal;

  /// No description provided for @colorLightGrey.
  ///
  /// In en, this message translates to:
  /// **'Light Grey'**
  String get colorLightGrey;

  /// No description provided for @colorYellow.
  ///
  /// In en, this message translates to:
  /// **'Yellow'**
  String get colorYellow;

  /// No description provided for @photoCredit.
  ///
  /// In en, this message translates to:
  /// **'Photo: Bady Abbas on Unsplash'**
  String get photoCredit;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'fr', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
