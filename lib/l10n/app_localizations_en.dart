// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Basic calculator';

  @override
  String get menuThemes => 'Themes';

  @override
  String get menuWhoAmI => 'Who am I';

  @override
  String get menuDonate => 'Donate';

  @override
  String get close => 'Close';

  @override
  String get whoAmITitle => 'Who am I';

  @override
  String get whoAmIBody =>
      'My name is Walter Bianchi, I am a software developer with a passion for creating useful and beautiful applications.\n\nI built this calculator to provide a simple yet powerful tool for calculations.\n\nI hope you find it helpful!\n\nI\'m looking for a job, so if you like this project (written in Flutter) and want to work with me, don\'t hesitate to contact me!\n';

  @override
  String get whoAmILinkedIn => 'LinkedIn Profile';

  @override
  String get whoAmIDonateCta => 'Donations welcome!';

  @override
  String get donateTitle => 'Donate';

  @override
  String get donateIntro =>
      'Thank you for using this calculator!\n\nIf you find this app useful and want to support its development, you can make a donation:\n';

  @override
  String get donateViaPaypal => 'Donate via PayPal';

  @override
  String get donateOutro => 'Every contribution helps improve this app!';

  @override
  String get themeSettingsTitle => 'Theme Settings';

  @override
  String get themeBackgroundColor => 'Background Color:';

  @override
  String get themeDisplayTextColor => 'Display Text Color:';

  @override
  String get themeButtonGroupsColor => 'Button Groups Color:';

  @override
  String get themeButtonTextColor => 'Button Text Color:';

  @override
  String get colorWhite => 'White';

  @override
  String get colorDark => 'Dark';

  @override
  String get colorLightBlue => 'Light Blue';

  @override
  String get colorLightAmber => 'Light Amber';

  @override
  String get colorBlack => 'Black';

  @override
  String get colorBlue => 'Blue';

  @override
  String get colorGreen => 'Green';

  @override
  String get colorDarkGrey => 'Dark Grey';

  @override
  String get colorPurple => 'Purple';

  @override
  String get colorTeal => 'Teal';

  @override
  String get colorLightGrey => 'Light Grey';

  @override
  String get colorYellow => 'Yellow';

  @override
  String get photoCredit => 'Photo: Bady Abbas on Unsplash';

  @override
  String get menuSectionHealth => 'Health';

  @override
  String get menuSectionConversions => 'IP Tools';

  @override
  String get menuSectionFinance => 'Finance';

  @override
  String get menuSectionRealEstate => 'Real Estate';

  @override
  String get bmiTitle => 'BMI Calculator';

  @override
  String get menuBmi => 'BMI Calculator';

  @override
  String get bmiPromptHeight => 'Height (m):';

  @override
  String get bmiPromptWeight => 'Weight (kg):';

  @override
  String get bmiPromptResult => 'BMI:';

  @override
  String get bmiActionEnter => 'Enter';

  @override
  String get bmiErrorInvalidHeight => 'Error: incorrect height';

  @override
  String get bmiErrorInvalidWeight => 'Error: incorrect weight';

  @override
  String get bmiErrorGeneric => 'Error';

  @override
  String get bmiCategoryUnderweight => 'Underweight';

  @override
  String get bmiCategoryNormal => 'Normal weight';

  @override
  String get bmiCategoryOverweight => 'Overweight';

  @override
  String get bmiCategoryObese => 'Obese';

  @override
  String get menuIpv4Address => 'IPv4 Address';

  @override
  String get menuIpv4Supernet => 'IPv4 Supernet';

  @override
  String get ipv4Title => 'IPv4 Address';

  @override
  String get ipv4InputLabel => 'IPv4 CIDR address';

  @override
  String get ipv4InputHint => 'Example: 192.168.1.34/24';

  @override
  String get ipv4ActionCalculate => 'Calculate';

  @override
  String get ipv4ActionClear => 'Clear';

  @override
  String get ipv4ErrorEmptyCidr => 'Please enter an IPv4 CIDR address.';

  @override
  String get ipv4ErrorInvalidCidr => 'Invalid IPv4 CIDR format.';

  @override
  String get ipv4ErrorGeneric => 'Unable to process this IPv4 CIDR.';

  @override
  String get ipv4InfoPrefix => 'Prefix';

  @override
  String get ipv4InfoClass => 'Class';

  @override
  String get ipv4InfoScope => 'Scope';

  @override
  String get ipv4InfoMask => 'Subnet mask';

  @override
  String get ipv4InfoWildcard => 'Wildcard mask';

  @override
  String get ipv4InfoNetwork => 'Network address';

  @override
  String get ipv4InfoBroadcast => 'Broadcast address';

  @override
  String get ipv4InfoFirstHost => 'First usable host';

  @override
  String get ipv4InfoLastHost => 'Last usable host';

  @override
  String get ipv4InfoTotalAddresses => 'Total addresses';

  @override
  String get ipv4InfoUsableHosts => 'Usable hosts';

  @override
  String get ipv4InfoNetworkBinary => 'Network (binary)';

  @override
  String get ipv4InfoBroadcastBinary => 'Broadcast (binary)';

  @override
  String get ipv4ScopePrivate => 'Private';

  @override
  String get ipv4ScopePublic => 'Public';

  @override
  String get ipv4ScopeLoopback => 'Loopback';

  @override
  String get ipv4ScopeLinkLocal => 'Link-local';

  @override
  String get ipv4ScopeMulticast => 'Multicast';

  @override
  String get ipv4ScopeReserved => 'Reserved/Experimental';

  @override
  String get ipv4SupernetTitle => 'IPv4 Supernet';

  @override
  String get ipv4SupernetInputLabel => 'IPv4 CIDR address';

  @override
  String get ipv4SupernetInputHint => 'Example: 192.168.1.0/24';

  @override
  String get ipv4SupernetActionAdd => 'Add';

  @override
  String get ipv4SupernetActionCalculate => 'Calculate supernet';

  @override
  String get ipv4SupernetActionReset => 'Reset';

  @override
  String get ipv4SupernetAddressesTitle => 'Addresses';

  @override
  String get ipv4SupernetResultTitle => 'Supernet result';

  @override
  String get ipv4SupernetResultValue => 'Covering supernet';

  @override
  String get ipv4SupernetRelationsTitle => 'Address relations';

  @override
  String get ipv4SupernetContiguousYes => 'All addresses are contiguous.';

  @override
  String get ipv4SupernetContiguousNo => 'Addresses are not all contiguous.';

  @override
  String get ipv4SupernetErrorEmptyAddress =>
      'Please enter an IPv4 CIDR address.';

  @override
  String get ipv4SupernetErrorInvalidCidr => 'Invalid IPv4 CIDR format.';

  @override
  String get ipv4SupernetErrorNeedTwo =>
      'Please add at least two IPv4 addresses.';

  @override
  String get ipv4SupernetErrorGeneric =>
      'Unable to compute supernet for this list.';

  @override
  String ipv4SupernetDuplicateMessage(Object address, int count) {
    return 'Duplicate removed: $address ($count entries)';
  }

  @override
  String get relationEqual => 'equal';

  @override
  String get relationOutside => 'outside';

  @override
  String get relationContiguous => 'contiguous';

  @override
  String get relationAInsideB => 'A inside B';

  @override
  String get relationBInsideA => 'B inside A';

  @override
  String get relationOverlap => 'overlap';

  @override
  String get relationIntersecting => 'intersecting';

  @override
  String relationUnknown(Object code) {
    return 'unknown ($code)';
  }

  @override
  String get ipv6TypeLoopback => 'Loopback address.';

  @override
  String get ipv6TypeLinkLocal =>
      'Link-Local address (communication on the same switch, non routable).';

  @override
  String get ipv6TypeGlobalUnicast =>
      'Global Unicast address (public address routable on Internet).';

  @override
  String get ipv6TypeUniqueLocal =>
      'Unique Local address (equivalent to IPv4 private addresses).';

  @override
  String get ipv6TypeMulticast => 'Multicast address.';

  @override
  String get ipv6TypeUnspecified => 'Unspecified address.';

  @override
  String get ipv6ErrorInvalidCidrFormat => 'Invalid IPv6 CIDR format.';

  @override
  String get ipv6ErrorEmptyAddress => 'Empty IPv6 address.';

  @override
  String get ipv6ErrorInvalidSuffix => 'Invalid IPv6 suffix.';

  @override
  String get ipv6ErrorInvalidAddress => 'Invalid IPv6 address.';

  @override
  String get ipv6ErrorInvalidMacFormat => 'Invalid MAC address format.';
}
