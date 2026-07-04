// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'Rekenmachine';

  @override
  String get basicHistoryCopy => 'Geschiedenis kopiëren';

  @override
  String get basicHistorySave => 'Geschiedenis opslaan';

  @override
  String get basicHistoryClear => 'Geschiedenis wissen';

  @override
  String get basicHistoryEmpty => 'De geschiedenis is leeg.';

  @override
  String get basicHistoryCopied => 'Geschiedenis gekopieerd naar het klembord.';

  @override
  String get basicHistoryExportUnsupported =>
      'Bestandsuitvoer is niet beschikbaar op dit platform.';

  @override
  String get basicHistoryExportError => 'Kan de geschiedenis niet opslaan.';

  @override
  String basicHistoryExported(Object path) {
    return 'Geschiedenis opgeslagen onder: $path';
  }

  @override
  String get menuThemes => 'Thema\'s';

  @override
  String get menuWhoAmI => 'Wie ben ik';

  @override
  String get menuDonate => 'Doneren';

  @override
  String get close => 'Sluiten';

  @override
  String get whoAmITitle => 'Wie ben ik';

  @override
  String get whoAmIBody =>
      'Mijn naam is Walter Bianchi. Ik ben softwareontwikkelaar met een passie voor het maken van nuttige en mooie applicaties.\n\nIk heb deze rekenmachine gebouwd om een eenvoudige maar krachtige tool voor berekeningen te bieden.\n\nIk hoop dat je hem nuttig vindt!\n\nIk ben op zoek naar een baan. Dus als je dit project leuk vindt (gemaakt met Flutter) en graag met me wilt samenwerken, aarzel dan niet om contact met me op te nemen!\n';

  @override
  String get whoAmILinkedIn => 'LinkedIn-profiel';

  @override
  String get whoAmIDonateCta => 'Donaties zijn welkom!';

  @override
  String get donateTitle => 'Doneren';

  @override
  String get donateIntro =>
      'Bedankt dat je deze rekenmachine gebruikt!\n\nAls je deze app nuttig vindt en de ontwikkeling ervan wilt ondersteunen, kun je doneren:\n';

  @override
  String get donateViaPaypal => 'Doneren via PayPal';

  @override
  String get donateOutro => 'Elke bijdrage helpt deze app te verbeteren!';

  @override
  String get themeSettingsTitle => 'Thema-instellingen';

  @override
  String get themeBackgroundColor => 'Achtergrondkleur:';

  @override
  String get themeBackgroundNeutral => 'Zachtgrijs';

  @override
  String get themeBackgroundWallpaper => 'Achtergrond';

  @override
  String get themeBackgroundMetal => 'Geborsteld metaal';

  @override
  String get themeDisplayTextColor => 'Tekstkleur voor weergave:';

  @override
  String get themeButtonGroupsColor => 'Kleur van knopgroepen:';

  @override
  String get themeButtonTextColor => 'Kleur van knoppen:';

  @override
  String get colorWhite => 'Wit';

  @override
  String get colorDark => 'Donker';

  @override
  String get colorLightBlue => 'Lichtblauw';

  @override
  String get colorLightAmber => 'Licht amber';

  @override
  String get colorBlack => 'Zwart';

  @override
  String get colorBlue => 'Blauw';

  @override
  String get colorGreen => 'Groen';

  @override
  String get colorDarkGrey => 'Donkergrijs';

  @override
  String get colorPurple => 'Paars';

  @override
  String get colorTeal => 'Teal';

  @override
  String get colorLightGrey => 'Lichtgrijs';

  @override
  String get colorYellow => 'Geel';

  @override
  String get photoCredit => 'Foto: Bady Abbas op Unsplash';

  @override
  String get menuSectionHealth => 'Gezondheid';

  @override
  String get menuSectionConversions => 'Conversies';

  @override
  String get menuSectionIpTools => 'IP-tools';

  @override
  String get menuSectionFinance => 'Financiën';

  @override
  String get menuSectionRealEstate => 'Vastgoed';

  @override
  String get bmiTitle => 'BMI-rekenmachine';

  @override
  String get menuBmi => 'BMI-rekenmachine';

  @override
  String get bmiPromptHeight => 'Lengte (m):';

  @override
  String get bmiPromptWeight => 'Gewicht (kg):';

  @override
  String get bmiPromptResult => 'BMI:';

  @override
  String get bmiActionEnter => 'Invoeren';

  @override
  String get bmiErrorInvalidHeight => 'Fout: onjuiste lengte';

  @override
  String get bmiErrorInvalidWeight => 'Fout: onjuist gewicht';

  @override
  String get bmiErrorGeneric => 'Fout';

  @override
  String get bmiCategoryUnderweight => 'Ondergewicht';

  @override
  String get bmiCategoryNormal => 'Normaal gewicht';

  @override
  String get bmiCategoryOverweight => 'Overgewicht';

  @override
  String get bmiCategoryObese => 'Obesitas';

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
  String get menuDistance => 'Afstandsconverter';

  @override
  String get distanceTitle => 'Afstandsconverter';

  @override
  String get distanceLabelMetric => 'Metrisch';

  @override
  String get distanceLabelImperial => 'Imperiaal';

  @override
  String get distanceLabelNautical => 'Nautische mijl';

  @override
  String get distanceUnitKm => 'km';

  @override
  String get distanceUnitM => 'm';

  @override
  String get distanceUnitCm => 'cm';

  @override
  String get distanceUnitMm => 'mm';

  @override
  String get distanceUnitMi => 'mi';

  @override
  String get distanceUnitYd => 'yd';

  @override
  String get distanceUnitFt => 'ft';

  @override
  String get distanceUnitInch => 'inch';

  @override
  String get distanceUnitNmi => 'nmi';

  @override
  String get menuIpv4Address => 'IPv4-adres';

  @override
  String get menuIpv4Supernet => 'IPv4-supernet';

  @override
  String get ipv4Title => 'IPv4-adres';

  @override
  String get ipv4InputLabel => 'IPv4-CIDR-adres';

  @override
  String get ipv4InputHint => 'Voorbeeld: 192.168.1.34/24';

  @override
  String get ipv4ActionCalculate => 'Bereken';

  @override
  String get ipv4ActionClear => 'Wissen';

  @override
  String get ipv4ResultCopy => 'Resultaat kopiëren';

  @override
  String get ipv4ResultSave => 'Resultaat opslaan';

  @override
  String get ipv4ResultCopied => 'Resultaat gekopieerd naar het klembord.';

  @override
  String get ipv4ResultExportUnsupported =>
      'Bestandsuitvoer is niet beschikbaar op dit platform.';

  @override
  String get ipv4ResultExportError => 'Kan het resultaat niet opslaan.';

  @override
  String ipv4ResultExported(Object path) {
    return 'Resultaat opgeslagen onder: $path';
  }

  @override
  String get ipv4ErrorEmptyCidr => 'Voer een IPv4 CIDR-adres in.';

  @override
  String get ipv4ErrorInvalidCidr => 'Ongeldig IPv4 CIDR-formaat.';

  @override
  String get ipv4ErrorGeneric => 'Kan deze IPv4 CIDR niet verwerken.';

  @override
  String get ipv4InfoPrefix => 'Prefix';

  @override
  String get ipv4InfoClass => 'Klasse';

  @override
  String get ipv4InfoScope => 'Bereik';

  @override
  String get ipv4InfoMask => 'Subnetmasker';

  @override
  String get ipv4InfoWildcard => 'Wildcard-masker';

  @override
  String get ipv4InfoNetwork => 'Netwerkadres';

  @override
  String get ipv4InfoBroadcast => 'Broadcast-adres';

  @override
  String get ipv4InfoFirstHost => 'Eerste bruikbare host';

  @override
  String get ipv4InfoLastHost => 'Laatste bruikbare host';

  @override
  String get ipv4InfoTotalAddresses => 'Totaal aantal adressen';

  @override
  String get ipv4InfoUsableHosts => 'Beschikbare hosts';

  @override
  String get ipv4InfoNetworkBinary => 'Netwerk (binair)';

  @override
  String get ipv4InfoBroadcastBinary => 'Broadcast (binair)';

  @override
  String get ipv4ScopePrivate => 'Privé';

  @override
  String get ipv4ScopePublic => 'Publiek';

  @override
  String get ipv4ScopeLoopback => 'Loopback';

  @override
  String get ipv4ScopeLinkLocal => 'Link-local';

  @override
  String get ipv4ScopeMulticast => 'Multicast';

  @override
  String get ipv4ScopeReserved => 'Gereserveerd/Experimenteel';

  @override
  String get ipv4SupernetTitle => 'IPv4-supernet';

  @override
  String get ipv4SupernetInputLabel => 'IPv4-CIDR-adres';

  @override
  String get ipv4SupernetInputHint => 'Voorbeeld: 192.168.1.0/24';

  @override
  String get ipv4SupernetActionAdd => 'Toevoegen';

  @override
  String get ipv4SupernetActionCalculate => 'Supernet berekenen';

  @override
  String get ipv4SupernetActionReset => 'Resetten';

  @override
  String get ipv4SupernetAddressesTitle => 'Adressen';

  @override
  String get ipv4SupernetResultTitle => 'Supernetresultaat';

  @override
  String get ipv4SupernetResultValue => 'Overkoepelend supernet';

  @override
  String get ipv4SupernetRelationsTitle => 'Adresrelaties';

  @override
  String get ipv4SupernetContiguousYes => 'Alle adressen zijn aaneengesloten.';

  @override
  String get ipv4SupernetContiguousNo =>
      'Niet alle adressen zijn aaneengesloten.';

  @override
  String get ipv4SupernetErrorEmptyAddress => 'Voer een IPv4 CIDR-adres in.';

  @override
  String get ipv4SupernetErrorInvalidCidr => 'Ongeldig IPv4 CIDR-formaat.';

  @override
  String get ipv4SupernetErrorNeedTwo =>
      'Voeg ten minste twee IPv4-adressen toe.';

  @override
  String get ipv4SupernetErrorGeneric =>
      'Kan supernet voor deze lijst niet berekenen.';

  @override
  String ipv4SupernetDuplicateMessage(Object address, int count) {
    return 'Dubbel verwijderd: $address ($count vermeldingen)';
  }

  @override
  String get relationEqual => 'gelijk';

  @override
  String get relationOutside => 'buiten';

  @override
  String get relationContiguous => 'aaneengesloten';

  @override
  String get relationAInsideB => 'in B';

  @override
  String get relationBInsideA => 'B in A';

  @override
  String get relationOverlap => 'overlap';

  @override
  String get relationIntersecting => 'snijdend';

  @override
  String relationUnknown(Object code) {
    return 'onbekend ($code)';
  }

  @override
  String get menuIpv6Address => 'IPv6-adres';

  @override
  String get menuIpv6Supernet => 'IPv6-supernet';

  @override
  String get ipv6Title => 'IPv6-adres';

  @override
  String get ipv6InputLabel => 'IPv6-CIDR-adres';

  @override
  String get ipv6InputHint => 'Voorbeeld: 2001:db8::1/64';

  @override
  String get ipv6ActionCalculate => 'Bereken';

  @override
  String get ipv6ActionClear => 'Wissen';

  @override
  String get ipv6ResultCopy => 'Resultaat kopiëren';

  @override
  String get ipv6ResultSave => 'Resultaat opslaan';

  @override
  String get ipv6ResultCopied => 'Resultaat gekopieerd naar het klembord.';

  @override
  String get ipv6ResultExportUnsupported =>
      'Bestandsuitvoer is niet beschikbaar op dit platform.';

  @override
  String get ipv6ResultExportError => 'Kan het resultaat niet opslaan.';

  @override
  String ipv6ResultExported(Object path) {
    return 'Resultaat opgeslagen onder: $path';
  }

  @override
  String get ipv6ErrorEmptyAddress => 'Leeg IPv6-adres.';

  @override
  String get ipv6ErrorGeneric => 'Kan dit IPv6-adres niet verwerken.';

  @override
  String get ipv6InfoPrefix => 'Prefix';

  @override
  String get ipv6InfoType => 'Type';

  @override
  String get ipv6InfoExpandedAddress => 'Uitgebreid adres';

  @override
  String get ipv6InfoSimplifiedAddress => 'Vereenvoudigd adres';

  @override
  String get ipv6InfoNetwork => 'Netwerkadres';

  @override
  String get ipv6InfoSimplifiedNetwork => 'Vereenvoudigd netwerkadres';

  @override
  String get ipv6InfoTotalAddresses => 'Totaal aantal adressen';

  @override
  String get ipv6InfoNetworkBinary => 'Netwerk (binair)';

  @override
  String get ipv6TypeUnknown => 'Onbekend adres.';

  @override
  String get ipv6SupernetTitle => 'IPv6-supernet';

  @override
  String get ipv6SupernetInputLabel => 'IPv6-CIDR-adres';

  @override
  String get ipv6SupernetInputHint => 'Voorbeeld: 2001:db8::/64';

  @override
  String get ipv6SupernetActionAdd => 'Toevoegen';

  @override
  String get ipv6SupernetActionCalculate => 'Supernet berekenen';

  @override
  String get ipv6SupernetActionReset => 'Resetten';

  @override
  String get ipv6SupernetAddressesTitle => 'Adressen';

  @override
  String get ipv6SupernetResultTitle => 'Supernetresultaat';

  @override
  String get ipv6SupernetResultValue => 'Overkoepelend supernet';

  @override
  String get ipv6SupernetRelationsTitle => 'Adresrelaties';

  @override
  String get ipv6SupernetContiguousYes => 'Alle adressen zijn aaneengesloten.';

  @override
  String get ipv6SupernetContiguousNo =>
      'Niet alle adressen zijn aaneengesloten.';

  @override
  String get ipv6SupernetErrorEmptyAddress => 'Voer een IPv6-adres in.';

  @override
  String get ipv6SupernetErrorInvalidCidr => 'Ongeldig IPv6 CIDR-formaat.';

  @override
  String get ipv6SupernetErrorNeedTwo =>
      'Voeg ten minste twee IPv6-adressen toe.';

  @override
  String get ipv6SupernetErrorGeneric =>
      'Kan supernet voor deze lijst niet berekenen.';

  @override
  String ipv6SupernetDuplicateMessage(Object address, int count) {
    return 'Dubbel verwijderd: $address ($count vermeldingen)';
  }

  @override
  String get ipv6TypeLoopback => 'Loopback-adres.';

  @override
  String get ipv6TypeLinkLocal =>
      'Link-Local-adres (communicatie op dezelfde switch, niet routable).';

  @override
  String get ipv6TypeGlobalUnicast =>
      'Global Unicast-adres (publiek adres dat op internet routable is).';

  @override
  String get ipv6TypeUniqueLocal =>
      'Unique Local-adres (equivalent met privé IPv4-adressen).';

  @override
  String get ipv6TypeMulticast => 'Multicast-adres.';

  @override
  String get ipv6TypeUnspecified => 'Niet-gespecificeerd adres.';

  @override
  String get ipv6ErrorInvalidCidrFormat => 'Ongeldig IPv6 CIDR-formaat.';

  @override
  String get ipv6ErrorInvalidSuffix => 'Ongeldige IPv6-suffix.';

  @override
  String get ipv6ErrorInvalidAddress => 'Ongeldig IPv6-adres.';

  @override
  String get ipv6ErrorInvalidMacFormat => 'Ongeldig MAC-adresformaat.';
}
