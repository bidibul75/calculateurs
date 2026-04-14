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
  /// **'Calculator'**
  String get appTitle;

  /// No description provided for @basicHistoryCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy history'**
  String get basicHistoryCopy;

  /// No description provided for @basicHistorySave.
  ///
  /// In en, this message translates to:
  /// **'Save history'**
  String get basicHistorySave;

  /// No description provided for @basicHistoryClear.
  ///
  /// In en, this message translates to:
  /// **'Clear history'**
  String get basicHistoryClear;

  /// No description provided for @basicHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'History is empty.'**
  String get basicHistoryEmpty;

  /// No description provided for @basicHistoryCopied.
  ///
  /// In en, this message translates to:
  /// **'History copied to clipboard.'**
  String get basicHistoryCopied;

  /// No description provided for @basicHistoryExportUnsupported.
  ///
  /// In en, this message translates to:
  /// **'File export is not available on this platform.'**
  String get basicHistoryExportUnsupported;

  /// No description provided for @basicHistoryExportError.
  ///
  /// In en, this message translates to:
  /// **'Unable to save history.'**
  String get basicHistoryExportError;

  /// No description provided for @basicHistoryExported.
  ///
  /// In en, this message translates to:
  /// **'History saved to: {path}'**
  String basicHistoryExported(Object path);

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

  /// No description provided for @themeBackgroundNeutral.
  ///
  /// In en, this message translates to:
  /// **'Soft grey'**
  String get themeBackgroundNeutral;

  /// No description provided for @themeBackgroundWallpaper.
  ///
  /// In en, this message translates to:
  /// **'Wallpaper'**
  String get themeBackgroundWallpaper;

  /// No description provided for @themeBackgroundMetal.
  ///
  /// In en, this message translates to:
  /// **'Brushed metal'**
  String get themeBackgroundMetal;

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

  /// No description provided for @menuSectionHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get menuSectionHealth;

  /// No description provided for @menuSectionConversions.
  ///
  /// In en, this message translates to:
  /// **'IP Tools'**
  String get menuSectionConversions;

  /// No description provided for @menuSectionFinance.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get menuSectionFinance;

  /// No description provided for @menuSectionRealEstate.
  ///
  /// In en, this message translates to:
  /// **'Real Estate'**
  String get menuSectionRealEstate;

  /// No description provided for @bmiTitle.
  ///
  /// In en, this message translates to:
  /// **'BMI Calculator'**
  String get bmiTitle;

  /// No description provided for @menuBmi.
  ///
  /// In en, this message translates to:
  /// **'BMI Calculator'**
  String get menuBmi;

  /// No description provided for @bmiPromptHeight.
  ///
  /// In en, this message translates to:
  /// **'Height (m):'**
  String get bmiPromptHeight;

  /// No description provided for @bmiPromptWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg):'**
  String get bmiPromptWeight;

  /// No description provided for @bmiPromptResult.
  ///
  /// In en, this message translates to:
  /// **'BMI:'**
  String get bmiPromptResult;

  /// No description provided for @bmiActionEnter.
  ///
  /// In en, this message translates to:
  /// **'Enter'**
  String get bmiActionEnter;

  /// No description provided for @bmiErrorInvalidHeight.
  ///
  /// In en, this message translates to:
  /// **'Error: incorrect height'**
  String get bmiErrorInvalidHeight;

  /// No description provided for @bmiErrorInvalidWeight.
  ///
  /// In en, this message translates to:
  /// **'Error: incorrect weight'**
  String get bmiErrorInvalidWeight;

  /// No description provided for @bmiErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get bmiErrorGeneric;

  /// No description provided for @bmiCategoryUnderweight.
  ///
  /// In en, this message translates to:
  /// **'Underweight'**
  String get bmiCategoryUnderweight;

  /// No description provided for @bmiCategoryNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal weight'**
  String get bmiCategoryNormal;

  /// No description provided for @bmiCategoryOverweight.
  ///
  /// In en, this message translates to:
  /// **'Overweight'**
  String get bmiCategoryOverweight;

  /// No description provided for @bmiCategoryObese.
  ///
  /// In en, this message translates to:
  /// **'Obese'**
  String get bmiCategoryObese;

  /// No description provided for @menuIpv4Address.
  ///
  /// In en, this message translates to:
  /// **'IPv4 Address'**
  String get menuIpv4Address;

  /// No description provided for @menuIpv4Supernet.
  ///
  /// In en, this message translates to:
  /// **'IPv4 Supernet'**
  String get menuIpv4Supernet;

  /// No description provided for @ipv4Title.
  ///
  /// In en, this message translates to:
  /// **'IPv4 Address'**
  String get ipv4Title;

  /// No description provided for @ipv4InputLabel.
  ///
  /// In en, this message translates to:
  /// **'IPv4 CIDR address'**
  String get ipv4InputLabel;

  /// No description provided for @ipv4InputHint.
  ///
  /// In en, this message translates to:
  /// **'Example: 192.168.1.34/24'**
  String get ipv4InputHint;

  /// No description provided for @ipv4ActionCalculate.
  ///
  /// In en, this message translates to:
  /// **'Calculate'**
  String get ipv4ActionCalculate;

  /// No description provided for @ipv4ActionClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get ipv4ActionClear;

  /// No description provided for @ipv4ResultCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy result'**
  String get ipv4ResultCopy;

  /// No description provided for @ipv4ResultSave.
  ///
  /// In en, this message translates to:
  /// **'Save result'**
  String get ipv4ResultSave;

  /// No description provided for @ipv4ResultCopied.
  ///
  /// In en, this message translates to:
  /// **'Result copied to clipboard.'**
  String get ipv4ResultCopied;

  /// No description provided for @ipv4ResultExportUnsupported.
  ///
  /// In en, this message translates to:
  /// **'File export is not available on this platform.'**
  String get ipv4ResultExportUnsupported;

  /// No description provided for @ipv4ResultExportError.
  ///
  /// In en, this message translates to:
  /// **'Unable to save result.'**
  String get ipv4ResultExportError;

  /// No description provided for @ipv4ResultExported.
  ///
  /// In en, this message translates to:
  /// **'Result saved to: {path}'**
  String ipv4ResultExported(Object path);

  /// No description provided for @ipv4ErrorEmptyCidr.
  ///
  /// In en, this message translates to:
  /// **'Please enter an IPv4 CIDR address.'**
  String get ipv4ErrorEmptyCidr;

  /// No description provided for @ipv4ErrorInvalidCidr.
  ///
  /// In en, this message translates to:
  /// **'Invalid IPv4 CIDR format.'**
  String get ipv4ErrorInvalidCidr;

  /// No description provided for @ipv4ErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Unable to process this IPv4 CIDR.'**
  String get ipv4ErrorGeneric;

  /// No description provided for @ipv4InfoPrefix.
  ///
  /// In en, this message translates to:
  /// **'Prefix'**
  String get ipv4InfoPrefix;

  /// No description provided for @ipv4InfoClass.
  ///
  /// In en, this message translates to:
  /// **'Class'**
  String get ipv4InfoClass;

  /// No description provided for @ipv4InfoScope.
  ///
  /// In en, this message translates to:
  /// **'Scope'**
  String get ipv4InfoScope;

  /// No description provided for @ipv4InfoMask.
  ///
  /// In en, this message translates to:
  /// **'Subnet mask'**
  String get ipv4InfoMask;

  /// No description provided for @ipv4InfoWildcard.
  ///
  /// In en, this message translates to:
  /// **'Wildcard mask'**
  String get ipv4InfoWildcard;

  /// No description provided for @ipv4InfoNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network address'**
  String get ipv4InfoNetwork;

  /// No description provided for @ipv4InfoBroadcast.
  ///
  /// In en, this message translates to:
  /// **'Broadcast address'**
  String get ipv4InfoBroadcast;

  /// No description provided for @ipv4InfoFirstHost.
  ///
  /// In en, this message translates to:
  /// **'First usable host'**
  String get ipv4InfoFirstHost;

  /// No description provided for @ipv4InfoLastHost.
  ///
  /// In en, this message translates to:
  /// **'Last usable host'**
  String get ipv4InfoLastHost;

  /// No description provided for @ipv4InfoTotalAddresses.
  ///
  /// In en, this message translates to:
  /// **'Total addresses'**
  String get ipv4InfoTotalAddresses;

  /// No description provided for @ipv4InfoUsableHosts.
  ///
  /// In en, this message translates to:
  /// **'Usable hosts'**
  String get ipv4InfoUsableHosts;

  /// No description provided for @ipv4InfoNetworkBinary.
  ///
  /// In en, this message translates to:
  /// **'Network (binary)'**
  String get ipv4InfoNetworkBinary;

  /// No description provided for @ipv4InfoBroadcastBinary.
  ///
  /// In en, this message translates to:
  /// **'Broadcast (binary)'**
  String get ipv4InfoBroadcastBinary;

  /// No description provided for @ipv4ScopePrivate.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get ipv4ScopePrivate;

  /// No description provided for @ipv4ScopePublic.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get ipv4ScopePublic;

  /// No description provided for @ipv4ScopeLoopback.
  ///
  /// In en, this message translates to:
  /// **'Loopback'**
  String get ipv4ScopeLoopback;

  /// No description provided for @ipv4ScopeLinkLocal.
  ///
  /// In en, this message translates to:
  /// **'Link-local'**
  String get ipv4ScopeLinkLocal;

  /// No description provided for @ipv4ScopeMulticast.
  ///
  /// In en, this message translates to:
  /// **'Multicast'**
  String get ipv4ScopeMulticast;

  /// No description provided for @ipv4ScopeReserved.
  ///
  /// In en, this message translates to:
  /// **'Reserved/Experimental'**
  String get ipv4ScopeReserved;

  /// No description provided for @ipv4SupernetTitle.
  ///
  /// In en, this message translates to:
  /// **'IPv4 Supernet'**
  String get ipv4SupernetTitle;

  /// No description provided for @ipv4SupernetInputLabel.
  ///
  /// In en, this message translates to:
  /// **'IPv4 CIDR address'**
  String get ipv4SupernetInputLabel;

  /// No description provided for @ipv4SupernetInputHint.
  ///
  /// In en, this message translates to:
  /// **'Example: 192.168.1.0/24'**
  String get ipv4SupernetInputHint;

  /// No description provided for @ipv4SupernetActionAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get ipv4SupernetActionAdd;

  /// No description provided for @ipv4SupernetActionCalculate.
  ///
  /// In en, this message translates to:
  /// **'Calculate supernet'**
  String get ipv4SupernetActionCalculate;

  /// No description provided for @ipv4SupernetActionReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get ipv4SupernetActionReset;

  /// No description provided for @ipv4SupernetAddressesTitle.
  ///
  /// In en, this message translates to:
  /// **'Addresses'**
  String get ipv4SupernetAddressesTitle;

  /// No description provided for @ipv4SupernetResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Supernet result'**
  String get ipv4SupernetResultTitle;

  /// No description provided for @ipv4SupernetResultValue.
  ///
  /// In en, this message translates to:
  /// **'Covering supernet'**
  String get ipv4SupernetResultValue;

  /// No description provided for @ipv4SupernetRelationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Address relations'**
  String get ipv4SupernetRelationsTitle;

  /// No description provided for @ipv4SupernetContiguousYes.
  ///
  /// In en, this message translates to:
  /// **'All addresses are contiguous.'**
  String get ipv4SupernetContiguousYes;

  /// No description provided for @ipv4SupernetContiguousNo.
  ///
  /// In en, this message translates to:
  /// **'Addresses are not all contiguous.'**
  String get ipv4SupernetContiguousNo;

  /// No description provided for @ipv4SupernetErrorEmptyAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter an IPv4 CIDR address.'**
  String get ipv4SupernetErrorEmptyAddress;

  /// No description provided for @ipv4SupernetErrorInvalidCidr.
  ///
  /// In en, this message translates to:
  /// **'Invalid IPv4 CIDR format.'**
  String get ipv4SupernetErrorInvalidCidr;

  /// No description provided for @ipv4SupernetErrorNeedTwo.
  ///
  /// In en, this message translates to:
  /// **'Please add at least two IPv4 addresses.'**
  String get ipv4SupernetErrorNeedTwo;

  /// No description provided for @ipv4SupernetErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Unable to compute supernet for this list.'**
  String get ipv4SupernetErrorGeneric;

  /// No description provided for @ipv4SupernetDuplicateMessage.
  ///
  /// In en, this message translates to:
  /// **'Duplicate removed: {address} ({count} entries)'**
  String ipv4SupernetDuplicateMessage(Object address, int count);

  /// No description provided for @relationEqual.
  ///
  /// In en, this message translates to:
  /// **'equal'**
  String get relationEqual;

  /// No description provided for @relationOutside.
  ///
  /// In en, this message translates to:
  /// **'outside'**
  String get relationOutside;

  /// No description provided for @relationContiguous.
  ///
  /// In en, this message translates to:
  /// **'contiguous'**
  String get relationContiguous;

  /// No description provided for @relationAInsideB.
  ///
  /// In en, this message translates to:
  /// **'inside'**
  String get relationAInsideB;

  /// No description provided for @relationBInsideA.
  ///
  /// In en, this message translates to:
  /// **'B inside A'**
  String get relationBInsideA;

  /// No description provided for @relationOverlap.
  ///
  /// In en, this message translates to:
  /// **'overlap'**
  String get relationOverlap;

  /// No description provided for @relationIntersecting.
  ///
  /// In en, this message translates to:
  /// **'intersecting'**
  String get relationIntersecting;

  /// No description provided for @relationUnknown.
  ///
  /// In en, this message translates to:
  /// **'unknown ({code})'**
  String relationUnknown(Object code);

  /// No description provided for @menuIpv6Address.
  ///
  /// In en, this message translates to:
  /// **'IPv6 Address'**
  String get menuIpv6Address;

  /// No description provided for @menuIpv6Supernet.
  ///
  /// In en, this message translates to:
  /// **'IPv6 Supernet'**
  String get menuIpv6Supernet;

  /// No description provided for @ipv6Title.
  ///
  /// In en, this message translates to:
  /// **'IPv6 Address'**
  String get ipv6Title;

  /// No description provided for @ipv6InputLabel.
  ///
  /// In en, this message translates to:
  /// **'IPv6 CIDR address'**
  String get ipv6InputLabel;

  /// No description provided for @ipv6InputHint.
  ///
  /// In en, this message translates to:
  /// **'Example: 2001:db8::1/64'**
  String get ipv6InputHint;

  /// No description provided for @ipv6ActionCalculate.
  ///
  /// In en, this message translates to:
  /// **'Calculate'**
  String get ipv6ActionCalculate;

  /// No description provided for @ipv6ActionClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get ipv6ActionClear;

  /// No description provided for @ipv6ResultCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy result'**
  String get ipv6ResultCopy;

  /// No description provided for @ipv6ResultSave.
  ///
  /// In en, this message translates to:
  /// **'Save result'**
  String get ipv6ResultSave;

  /// No description provided for @ipv6ResultCopied.
  ///
  /// In en, this message translates to:
  /// **'Result copied to clipboard.'**
  String get ipv6ResultCopied;

  /// No description provided for @ipv6ResultExportUnsupported.
  ///
  /// In en, this message translates to:
  /// **'File export is not available on this platform.'**
  String get ipv6ResultExportUnsupported;

  /// No description provided for @ipv6ResultExportError.
  ///
  /// In en, this message translates to:
  /// **'Unable to save result.'**
  String get ipv6ResultExportError;

  /// No description provided for @ipv6ResultExported.
  ///
  /// In en, this message translates to:
  /// **'Result saved to: {path}'**
  String ipv6ResultExported(Object path);

  /// No description provided for @ipv6ErrorEmptyAddress.
  ///
  /// In en, this message translates to:
  /// **'Empty IPv6 address.'**
  String get ipv6ErrorEmptyAddress;

  /// No description provided for @ipv6ErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Unable to process this IPv6 address.'**
  String get ipv6ErrorGeneric;

  /// No description provided for @ipv6InfoPrefix.
  ///
  /// In en, this message translates to:
  /// **'Prefix'**
  String get ipv6InfoPrefix;

  /// No description provided for @ipv6InfoType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get ipv6InfoType;

  /// No description provided for @ipv6InfoExpandedAddress.
  ///
  /// In en, this message translates to:
  /// **'Expanded address'**
  String get ipv6InfoExpandedAddress;

  /// No description provided for @ipv6InfoSimplifiedAddress.
  ///
  /// In en, this message translates to:
  /// **'Simplified address'**
  String get ipv6InfoSimplifiedAddress;

  /// No description provided for @ipv6InfoNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network address'**
  String get ipv6InfoNetwork;

  /// No description provided for @ipv6InfoSimplifiedNetwork.
  ///
  /// In en, this message translates to:
  /// **'Simplified network address'**
  String get ipv6InfoSimplifiedNetwork;

  /// No description provided for @ipv6InfoTotalAddresses.
  ///
  /// In en, this message translates to:
  /// **'Total addresses'**
  String get ipv6InfoTotalAddresses;

  /// No description provided for @ipv6InfoNetworkBinary.
  ///
  /// In en, this message translates to:
  /// **'Network (binary)'**
  String get ipv6InfoNetworkBinary;

  /// No description provided for @ipv6TypeUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown address.'**
  String get ipv6TypeUnknown;

  /// No description provided for @ipv6SupernetTitle.
  ///
  /// In en, this message translates to:
  /// **'IPv6 Supernet'**
  String get ipv6SupernetTitle;

  /// No description provided for @ipv6SupernetInputLabel.
  ///
  /// In en, this message translates to:
  /// **'IPv6 CIDR address'**
  String get ipv6SupernetInputLabel;

  /// No description provided for @ipv6SupernetInputHint.
  ///
  /// In en, this message translates to:
  /// **'Example: 2001:db8::/64'**
  String get ipv6SupernetInputHint;

  /// No description provided for @ipv6SupernetActionAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get ipv6SupernetActionAdd;

  /// No description provided for @ipv6SupernetActionCalculate.
  ///
  /// In en, this message translates to:
  /// **'Calculate supernet'**
  String get ipv6SupernetActionCalculate;

  /// No description provided for @ipv6SupernetActionReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get ipv6SupernetActionReset;

  /// No description provided for @ipv6SupernetAddressesTitle.
  ///
  /// In en, this message translates to:
  /// **'Addresses'**
  String get ipv6SupernetAddressesTitle;

  /// No description provided for @ipv6SupernetResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Supernet result'**
  String get ipv6SupernetResultTitle;

  /// No description provided for @ipv6SupernetResultValue.
  ///
  /// In en, this message translates to:
  /// **'Covering supernet'**
  String get ipv6SupernetResultValue;

  /// No description provided for @ipv6SupernetRelationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Address relations'**
  String get ipv6SupernetRelationsTitle;

  /// No description provided for @ipv6SupernetContiguousYes.
  ///
  /// In en, this message translates to:
  /// **'All addresses are contiguous.'**
  String get ipv6SupernetContiguousYes;

  /// No description provided for @ipv6SupernetContiguousNo.
  ///
  /// In en, this message translates to:
  /// **'Addresses are not all contiguous.'**
  String get ipv6SupernetContiguousNo;

  /// No description provided for @ipv6SupernetErrorEmptyAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter an IPv6 address.'**
  String get ipv6SupernetErrorEmptyAddress;

  /// No description provided for @ipv6SupernetErrorInvalidCidr.
  ///
  /// In en, this message translates to:
  /// **'Invalid IPv6 CIDR format.'**
  String get ipv6SupernetErrorInvalidCidr;

  /// No description provided for @ipv6SupernetErrorNeedTwo.
  ///
  /// In en, this message translates to:
  /// **'Please add at least two IPv6 addresses.'**
  String get ipv6SupernetErrorNeedTwo;

  /// No description provided for @ipv6SupernetErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Unable to compute supernet for this list.'**
  String get ipv6SupernetErrorGeneric;

  /// No description provided for @ipv6SupernetDuplicateMessage.
  ///
  /// In en, this message translates to:
  /// **'Duplicate removed: {address} ({count} entries)'**
  String ipv6SupernetDuplicateMessage(Object address, int count);

  /// No description provided for @ipv6TypeLoopback.
  ///
  /// In en, this message translates to:
  /// **'Loopback address.'**
  String get ipv6TypeLoopback;

  /// No description provided for @ipv6TypeLinkLocal.
  ///
  /// In en, this message translates to:
  /// **'Link-Local address (communication on the same switch, non routable).'**
  String get ipv6TypeLinkLocal;

  /// No description provided for @ipv6TypeGlobalUnicast.
  ///
  /// In en, this message translates to:
  /// **'Global Unicast address (public address routable on Internet).'**
  String get ipv6TypeGlobalUnicast;

  /// No description provided for @ipv6TypeUniqueLocal.
  ///
  /// In en, this message translates to:
  /// **'Unique Local address (equivalent to IPv4 private addresses).'**
  String get ipv6TypeUniqueLocal;

  /// No description provided for @ipv6TypeMulticast.
  ///
  /// In en, this message translates to:
  /// **'Multicast address.'**
  String get ipv6TypeMulticast;

  /// No description provided for @ipv6TypeUnspecified.
  ///
  /// In en, this message translates to:
  /// **'Unspecified address.'**
  String get ipv6TypeUnspecified;

  /// No description provided for @ipv6ErrorInvalidCidrFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid IPv6 CIDR format.'**
  String get ipv6ErrorInvalidCidrFormat;

  /// No description provided for @ipv6ErrorInvalidSuffix.
  ///
  /// In en, this message translates to:
  /// **'Invalid IPv6 suffix.'**
  String get ipv6ErrorInvalidSuffix;

  /// No description provided for @ipv6ErrorInvalidAddress.
  ///
  /// In en, this message translates to:
  /// **'Invalid IPv6 address.'**
  String get ipv6ErrorInvalidAddress;

  /// No description provided for @ipv6ErrorInvalidMacFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid MAC address format.'**
  String get ipv6ErrorInvalidMacFormat;
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
