// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class AppLocalizationsRo extends AppLocalizations {
  AppLocalizationsRo([String locale = 'ro']) : super(locale);

  @override
  String get appTitle => 'Calculatorul';

  @override
  String get basicHistoryCopy => 'Copiați istoricul';

  @override
  String get basicHistorySave => 'Salvați istoricul';

  @override
  String get basicHistoryClear => 'Ștergeți istoricul';

  @override
  String get basicHistoryEmpty => 'Istoria este goală.';

  @override
  String get basicHistoryCopied => 'Istoricul a fost copiat în clipboard.';

  @override
  String get basicHistoryExportUnsupported =>
      'Exportul fișierelor nu este disponibil pe această platformă.';

  @override
  String get basicHistoryExportError => 'Nu se poate salva istoricul.';

  @override
  String basicHistoryExported(Object path) {
    return 'Istoricul salvat pe: $path';
  }

  @override
  String get menuThemes => 'Teme';

  @override
  String get menuWhoAmI => 'cine sunt eu';

  @override
  String get menuDonate => 'Dona';

  @override
  String get close => 'Aproape';

  @override
  String get whoAmITitle => 'cine sunt eu';

  @override
  String get whoAmIBody =>
      'Numele meu este Walter Bianchi, sunt un dezvoltator de software cu o pasiune pentru crearea de aplicații utile și frumoase.\n\nAm construit acest calculator pentru a oferi un instrument simplu, dar puternic pentru calcule.\n\nSper să găsești de ajutor!\n\nCaut un loc de munca, asa ca daca iti place acest proiect (scris in Flutter) si vrei sa lucrezi cu mine, nu ezita sa ma contactezi!';

  @override
  String get whoAmILinkedIn => 'Profil LinkedIn';

  @override
  String get whoAmIDonateCta => 'Donații binevenite!';

  @override
  String get donateTitle => 'Dona';

  @override
  String get donateIntro =>
      'Vă mulțumim că ați folosit acest calculator!\n\nDacă vi se pare utilă această aplicație și doriți să susțineți dezvoltarea acesteia, puteți face o donație:';

  @override
  String get donateViaPaypal => 'Donează prin PayPal';

  @override
  String get donateOutro =>
      'Fiecare contribuție ajută la îmbunătățirea acestei aplicații!';

  @override
  String get themeSettingsTitle => 'Setări teme';

  @override
  String get themeBackgroundColor => 'Culoare de fundal:';

  @override
  String get themeBackgroundNeutral => 'Gri moale';

  @override
  String get themeBackgroundWallpaper => 'Tapet';

  @override
  String get themeBackgroundMetal => 'Metal periat';

  @override
  String get themeDisplayTextColor => 'Culoare text afișat:';

  @override
  String get themeButtonGroupsColor => 'Culoarea grupurilor de butoane:';

  @override
  String get themeButtonTextColor => 'Culoarea textului butonului:';

  @override
  String get colorWhite => 'Alb';

  @override
  String get colorDark => 'Întuneric';

  @override
  String get colorLightBlue => 'Albastru deschis';

  @override
  String get colorLightAmber => 'Chihlimbar deschis';

  @override
  String get colorBlack => 'Negru';

  @override
  String get colorBlue => 'Albastru';

  @override
  String get colorGreen => 'Verde';

  @override
  String get colorDarkGrey => 'Gri închis';

  @override
  String get colorPurple => 'Violet';

  @override
  String get colorTeal => 'Turcoaz';

  @override
  String get colorLightGrey => 'Gri deschis';

  @override
  String get colorYellow => 'Galben';

  @override
  String get photoCredit => 'Foto: Bady Abbas pe Unsplash';

  @override
  String get menuSectionHealth => 'Sănătate';

  @override
  String get menuSectionConversions => 'Conversii';

  @override
  String get menuSectionIpTools => 'Instrumente IP';

  @override
  String get menuSectionFinance => 'Finanţa';

  @override
  String get menuSectionRealEstate => 'Imobiliare';

  @override
  String get bmiTitle => 'Calculator IMC';

  @override
  String get menuBmi => 'Calculator IMC';

  @override
  String get bmiPromptHeight => 'Înălțime (m):';

  @override
  String get bmiPromptWeight => 'Greutate (kg):';

  @override
  String get bmiPromptResult => 'IMC:';

  @override
  String get bmiActionEnter => 'Intră';

  @override
  String get bmiErrorInvalidHeight => 'Eroare: înălțime incorectă';

  @override
  String get bmiErrorInvalidWeight => 'Eroare: greutate incorectă';

  @override
  String get bmiErrorGeneric => 'Eroare';

  @override
  String get bmiCategoryUnderweight => 'Subponderal';

  @override
  String get bmiCategoryNormal => 'Greutate normală';

  @override
  String get bmiCategoryOverweight => 'Excesul de greutate';

  @override
  String get bmiCategoryObese => 'Obez';

  @override
  String get temperatureTitle => 'Temperature Converter';

  @override
  String get menuTemperature => 'Temperature Converter';

  @override
  String get temperatureLabelCelsius => 'Celsius';

  @override
  String get temperatureLabelFahrenheit => 'Fahrenheit';

  @override
  String get temperatureLabelKelvin => 'Kelvin';

  @override
  String get temperatureLabelRankine => 'Rankine';

  @override
  String get menuIpv4Address => 'Adresa IPv4';

  @override
  String get menuIpv4Supernet => 'Supernet IPv4';

  @override
  String get ipv4Title => 'Adresa IPv4';

  @override
  String get ipv4InputLabel => 'Adresă IPv4 CIDR';

  @override
  String get ipv4InputHint => 'Exemplu: 192.168.1.34/24';

  @override
  String get ipv4ActionCalculate => 'Calcula';

  @override
  String get ipv4ActionClear => 'Clar';

  @override
  String get ipv4ResultCopy => 'Copiați rezultatul';

  @override
  String get ipv4ResultSave => 'Salvați rezultatul';

  @override
  String get ipv4ResultCopied => 'Rezultatul a fost copiat în clipboard.';

  @override
  String get ipv4ResultExportUnsupported =>
      'Exportul fișierelor nu este disponibil pe această platformă.';

  @override
  String get ipv4ResultExportError => 'Nu se poate salva rezultatul.';

  @override
  String ipv4ResultExported(Object path) {
    return 'Rezultatul salvat pe: $path';
  }

  @override
  String get ipv4ErrorEmptyCidr =>
      'Vă rugăm să introduceți o adresă CIDR IPv4.';

  @override
  String get ipv4ErrorInvalidCidr => 'Format IPv4 CIDR nevalid.';

  @override
  String get ipv4ErrorGeneric => 'Imposibil de procesat acest CIDR IPv4.';

  @override
  String get ipv4InfoPrefix => 'Prefixul';

  @override
  String get ipv4InfoClass => 'Clasă';

  @override
  String get ipv4InfoScope => 'Domeniul de aplicare';

  @override
  String get ipv4InfoMask => 'Mască de subrețea';

  @override
  String get ipv4InfoWildcard => 'Mască wildcard';

  @override
  String get ipv4InfoNetwork => 'Adresă de rețea';

  @override
  String get ipv4InfoBroadcast => 'Adresa de difuzare';

  @override
  String get ipv4InfoFirstHost => 'Prima gazdă utilizabilă';

  @override
  String get ipv4InfoLastHost => 'Ultima gazdă utilizabilă';

  @override
  String get ipv4InfoTotalAddresses => 'Total adrese';

  @override
  String get ipv4InfoUsableHosts => 'Gazde utilizabile';

  @override
  String get ipv4InfoNetworkBinary => 'Rețea (binară)';

  @override
  String get ipv4InfoBroadcastBinary => 'Difuzare (binară)';

  @override
  String get ipv4ScopePrivate => 'Privat';

  @override
  String get ipv4ScopePublic => 'Public?';

  @override
  String get ipv4ScopeLoopback => 'Bucl? local?';

  @override
  String get ipv4ScopeLinkLocal => 'Leg?tur? local?';

  @override
  String get ipv4ScopeMulticast => 'Multidifuzare';

  @override
  String get ipv4ScopeReserved => 'Rezervat/Experimental';

  @override
  String get ipv4SupernetTitle => 'Supernet IPv4';

  @override
  String get ipv4SupernetInputLabel => 'Adresă IPv4 CIDR';

  @override
  String get ipv4SupernetInputHint => 'Exemplu: 192.168.1.0/24';

  @override
  String get ipv4SupernetActionAdd => 'Adăuga';

  @override
  String get ipv4SupernetActionCalculate => 'Calculați supernet';

  @override
  String get ipv4SupernetActionReset => 'Resetați';

  @override
  String get ipv4SupernetAddressesTitle => 'Adrese';

  @override
  String get ipv4SupernetResultTitle => 'Rezultatul Supernet';

  @override
  String get ipv4SupernetResultValue => 'Acoperirea supernetului';

  @override
  String get ipv4SupernetRelationsTitle => 'Relații de adrese';

  @override
  String get ipv4SupernetContiguousYes => 'Toate adresele sunt învecinate.';

  @override
  String get ipv4SupernetContiguousNo => 'Adresele nu sunt toate învecinate.';

  @override
  String get ipv4SupernetErrorEmptyAddress =>
      'Vă rugăm să introduceți o adresă CIDR IPv4.';

  @override
  String get ipv4SupernetErrorInvalidCidr => 'Format IPv4 CIDR nevalid.';

  @override
  String get ipv4SupernetErrorNeedTwo =>
      'Vă rugăm să adăugați cel puțin două adrese IPv4.';

  @override
  String get ipv4SupernetErrorGeneric =>
      'Nu se poate calcula supernetul pentru această listă.';

  @override
  String ipv4SupernetDuplicateMessage(Object address, int count) {
    return 'Dublat eliminat: $address ($count intrări)';
  }

  @override
  String get relationEqual => 'egal';

  @override
  String get relationOutside => 'exterior';

  @override
  String get relationContiguous => 'învecinat';

  @override
  String get relationAInsideB => 'interior';

  @override
  String get relationBInsideA => 'B în interiorul A';

  @override
  String get relationOverlap => 'se suprapun';

  @override
  String get relationIntersecting => 'intersectându-se';

  @override
  String relationUnknown(Object code) {
    return 'necunoscut ($code)';
  }

  @override
  String get menuIpv6Address => 'Adresa IPv6';

  @override
  String get menuIpv6Supernet => 'Supernet IPv6';

  @override
  String get ipv6Title => 'Adresa IPv6';

  @override
  String get ipv6InputLabel => 'Adresă IPv6 CIDR';

  @override
  String get ipv6InputHint => 'Exemplu: 2001:db8::1/64';

  @override
  String get ipv6ActionCalculate => 'Calcula';

  @override
  String get ipv6ActionClear => 'Clar';

  @override
  String get ipv6ResultCopy => 'Copiați rezultatul';

  @override
  String get ipv6ResultSave => 'Salvați rezultatul';

  @override
  String get ipv6ResultCopied => 'Rezultatul a fost copiat în clipboard.';

  @override
  String get ipv6ResultExportUnsupported =>
      'Exportul fișierelor nu este disponibil pe această platformă.';

  @override
  String get ipv6ResultExportError => 'Nu se poate salva rezultatul.';

  @override
  String ipv6ResultExported(Object path) {
    return 'Rezultatul salvat pe: $path';
  }

  @override
  String get ipv6ErrorEmptyAddress => 'Adresă IPv6 goală.';

  @override
  String get ipv6ErrorGeneric => 'Nu se poate procesa această adresă IPv6.';

  @override
  String get ipv6InfoPrefix => 'Prefixul';

  @override
  String get ipv6InfoType => 'Tip';

  @override
  String get ipv6InfoExpandedAddress => 'Adresă extinsă';

  @override
  String get ipv6InfoSimplifiedAddress => 'Adresă simplificată';

  @override
  String get ipv6InfoNetwork => 'Adresă de rețea';

  @override
  String get ipv6InfoSimplifiedNetwork => 'Adresă de rețea simplificată';

  @override
  String get ipv6InfoTotalAddresses => 'Total adrese';

  @override
  String get ipv6InfoNetworkBinary => 'Rețea (binară)';

  @override
  String get ipv6TypeUnknown => 'Adresă necunoscută.';

  @override
  String get ipv6SupernetTitle => 'Supernet IPv6';

  @override
  String get ipv6SupernetInputLabel => 'Adresă IPv6 CIDR';

  @override
  String get ipv6SupernetInputHint => 'Exemplu: 2001:db8::/64';

  @override
  String get ipv6SupernetActionAdd => 'Adăuga';

  @override
  String get ipv6SupernetActionCalculate => 'Calculați supernet';

  @override
  String get ipv6SupernetActionReset => 'Resetați';

  @override
  String get ipv6SupernetAddressesTitle => 'Adrese';

  @override
  String get ipv6SupernetResultTitle => 'Rezultatul Supernet';

  @override
  String get ipv6SupernetResultValue => 'Acoperirea supernetului';

  @override
  String get ipv6SupernetRelationsTitle => 'Relații de adrese';

  @override
  String get ipv6SupernetContiguousYes => 'Toate adresele sunt învecinate.';

  @override
  String get ipv6SupernetContiguousNo => 'Adresele nu sunt toate învecinate.';

  @override
  String get ipv6SupernetErrorEmptyAddress =>
      'Vă rugăm să introduceți o adresă IPv6.';

  @override
  String get ipv6SupernetErrorInvalidCidr => 'Format IPv6 CIDR nevalid.';

  @override
  String get ipv6SupernetErrorNeedTwo =>
      'Vă rugăm să adăugați cel puțin două adrese IPv6.';

  @override
  String get ipv6SupernetErrorGeneric =>
      'Nu se poate calcula supernetul pentru această listă.';

  @override
  String ipv6SupernetDuplicateMessage(Object address, int count) {
    return 'Dublat eliminat: $address ($count intrări)';
  }

  @override
  String get ipv6TypeLoopback => 'Adresă loopback.';

  @override
  String get ipv6TypeLinkLocal =>
      'Link-Adresă locală (comunicare pe același switch, nedirecționabilă).';

  @override
  String get ipv6TypeGlobalUnicast =>
      'Adresă globală Unicast (adresă publică rutabilă pe Internet).';

  @override
  String get ipv6TypeUniqueLocal =>
      'Adresă locală unică (echivalentă cu adresele private IPv4).';

  @override
  String get ipv6TypeMulticast => 'Adresă multicast.';

  @override
  String get ipv6TypeUnspecified => 'Adresă nespecificată.';

  @override
  String get ipv6ErrorInvalidCidrFormat => 'Format IPv6 CIDR nevalid.';

  @override
  String get ipv6ErrorInvalidSuffix => 'Sufix IPv6 nevalid.';

  @override
  String get ipv6ErrorInvalidAddress => 'Adresă IPv6 nevalidă.';

  @override
  String get ipv6ErrorInvalidMacFormat => 'Format de adresă MAC nevalid.';
}
