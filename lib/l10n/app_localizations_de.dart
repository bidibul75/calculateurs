// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Rechner';

  @override
  String get basicHistoryCopy => 'Verlauf kopieren';

  @override
  String get basicHistorySave => 'Verlauf speichern';

  @override
  String get basicHistoryClear => 'Verlauf löschen';

  @override
  String get basicHistoryEmpty => 'Der Verlauf ist leer.';

  @override
  String get basicHistoryCopied => 'Verlauf in die Zwischenablage kopiert.';

  @override
  String get basicHistoryExportUnsupported =>
      'Dateiexport ist auf dieser Plattform nicht verfügbar.';

  @override
  String get basicHistoryExportError =>
      'Der Verlauf konnte nicht gespeichert werden.';

  @override
  String basicHistoryExported(Object path) {
    return 'Verlauf gespeichert unter: $path';
  }

  @override
  String get menuThemes => 'Themen';

  @override
  String get menuWhoAmI => 'Wer bin ich';

  @override
  String get menuDonate => 'Spenden';

  @override
  String get close => 'Schließen';

  @override
  String get whoAmITitle => 'Wer bin ich';

  @override
  String get whoAmIBody =>
      'Mein Name ist Walter Bianchi, ich bin Softwareentwickler mit einer Leidenschaft dafür, nützliche und schöne Anwendungen zu erstellen.\n\nIch habe diesen Rechner gebaut, um ein einfaches, aber leistungsstarkes Werkzeug für Berechnungen bereitzustellen.\n\nIch hoffe, Sie finden ihn hilfreich!\n\nIch suche gerade einen Job. Wenn Ihnen dieses Projekt gefällt (geschrieben in Flutter) und Sie mit mir zusammenarbeiten möchten, zögern Sie nicht, mich zu kontaktieren!\n';

  @override
  String get whoAmILinkedIn => 'LinkedIn-Profil';

  @override
  String get whoAmIDonateCta => 'Spenden sind willkommen!';

  @override
  String get donateTitle => 'Spenden';

  @override
  String get donateIntro =>
      'Danke, dass Sie diesen Rechner verwenden!\n\nWenn Sie diese App nützlich finden und ihre Entwicklung unterstützen möchten, können Sie spenden:\n';

  @override
  String get donateViaPaypal => 'Spenden über PayPal';

  @override
  String get donateOutro => 'Jeder Beitrag hilft, diese App zu verbessern!';

  @override
  String get themeSettingsTitle => 'Theme-Einstellungen';

  @override
  String get themeBackgroundColor => 'Hintergrundfarbe:';

  @override
  String get themeBackgroundNeutral => 'Weiches Grau';

  @override
  String get themeBackgroundWallpaper => 'Hintergrund';

  @override
  String get themeBackgroundMetal => 'Gebürstetes Metall';

  @override
  String get themeDisplayTextColor => 'Textfarbe der Anzeige:';

  @override
  String get themeButtonGroupsColor => 'Farbe der Tasten-Gruppen:';

  @override
  String get themeButtonTextColor => 'Farbe der Tasten:';

  @override
  String get colorWhite => 'Weiß';

  @override
  String get colorDark => 'Dunkel';

  @override
  String get colorLightBlue => 'Hellblau';

  @override
  String get colorLightAmber => 'Hellamber';

  @override
  String get colorBlack => 'Schwarz';

  @override
  String get colorBlue => 'Blau';

  @override
  String get colorGreen => 'Grün';

  @override
  String get colorDarkGrey => 'Dunkelgrau';

  @override
  String get colorPurple => 'Lila';

  @override
  String get colorTeal => 'Türkis';

  @override
  String get colorLightGrey => 'Hellgrau';

  @override
  String get colorYellow => 'Gelb';

  @override
  String get photoCredit => 'Foto: Bady Abbas auf Unsplash';

  @override
  String get menuSectionHealth => 'Gesundheit';

  @override
  String get menuSectionConversions => 'IP-Tools';

  @override
  String get menuSectionFinance => 'Finanzen';

  @override
  String get menuSectionRealEstate => 'Immobilien';

  @override
  String get bmiTitle => 'BMI-Rechner';

  @override
  String get menuBmi => 'BMI-Rechner';

  @override
  String get bmiPromptHeight => 'Größe (m):';

  @override
  String get bmiPromptWeight => 'Gewicht (kg):';

  @override
  String get bmiPromptResult => 'BMI:';

  @override
  String get bmiActionEnter => 'Eingeben';

  @override
  String get bmiErrorInvalidHeight => 'Fehler: falsche Größe';

  @override
  String get bmiErrorInvalidWeight => 'Fehler: falsches Gewicht';

  @override
  String get bmiErrorGeneric => 'Fehler';

  @override
  String get bmiCategoryUnderweight => 'Untergewicht';

  @override
  String get bmiCategoryNormal => 'Normalgewicht';

  @override
  String get bmiCategoryOverweight => 'Übergewicht';

  @override
  String get bmiCategoryObese => 'Adipositas';

  @override
  String get menuIpv4Address => 'IPv4-Adresse';

  @override
  String get menuIpv4Supernet => 'IPv4-Supernet';

  @override
  String get ipv4Title => 'IPv4-Adresse';

  @override
  String get ipv4InputLabel => 'IPv4-CIDR-Adresse';

  @override
  String get ipv4InputHint => 'Beispiel: 192.168.1.34/24';

  @override
  String get ipv4ActionCalculate => 'Berechnen';

  @override
  String get ipv4ActionClear => 'Löschen';

  @override
  String get ipv4ResultCopy => 'Ergebnis kopieren';

  @override
  String get ipv4ResultSave => 'Ergebnis speichern';

  @override
  String get ipv4ResultCopied => 'Ergebnis in die Zwischenablage kopiert.';

  @override
  String get ipv4ResultExportUnsupported =>
      'Dateiexport ist auf dieser Plattform nicht verfügbar.';

  @override
  String get ipv4ResultExportError =>
      'Das Ergebnis konnte nicht gespeichert werden.';

  @override
  String ipv4ResultExported(Object path) {
    return 'Ergebnis gespeichert unter: $path';
  }

  @override
  String get ipv4ErrorEmptyCidr => 'Bitte eine IPv4-CIDR-Adresse eingeben.';

  @override
  String get ipv4ErrorInvalidCidr => 'Ungültiges IPv4-CIDR-Format.';

  @override
  String get ipv4ErrorGeneric =>
      'Diese IPv4-CIDR konnte nicht verarbeitet werden.';

  @override
  String get ipv4InfoPrefix => 'Präfix';

  @override
  String get ipv4InfoClass => 'Klasse';

  @override
  String get ipv4InfoScope => 'Bereich';

  @override
  String get ipv4InfoMask => 'Subnetzmaske';

  @override
  String get ipv4InfoWildcard => 'Wildcard-Maske';

  @override
  String get ipv4InfoNetwork => 'Netzwerkadresse';

  @override
  String get ipv4InfoBroadcast => 'Broadcast-Adresse';

  @override
  String get ipv4InfoFirstHost => 'Erster nutzbarer Host';

  @override
  String get ipv4InfoLastHost => 'Letzter nutzbarer Host';

  @override
  String get ipv4InfoTotalAddresses => 'Anzahl der Adressen';

  @override
  String get ipv4InfoUsableHosts => 'Nutzbare Hosts';

  @override
  String get ipv4InfoNetworkBinary => 'Netzwerk (binär)';

  @override
  String get ipv4InfoBroadcastBinary => 'Broadcast (binär)';

  @override
  String get ipv4ScopePrivate => 'Privat';

  @override
  String get ipv4ScopePublic => 'Öffentlich';

  @override
  String get ipv4ScopeLoopback => 'Loopback';

  @override
  String get ipv4ScopeLinkLocal => 'Link-local';

  @override
  String get ipv4ScopeMulticast => 'Multicast';

  @override
  String get ipv4ScopeReserved => 'Reserviert/Experimentell';

  @override
  String get ipv4SupernetTitle => 'IPv4-Supernet';

  @override
  String get ipv4SupernetInputLabel => 'IPv4-CIDR-Adresse';

  @override
  String get ipv4SupernetInputHint => 'Beispiel: 192.168.1.0/24';

  @override
  String get ipv4SupernetActionAdd => 'Hinzufügen';

  @override
  String get ipv4SupernetActionCalculate => 'Supernet berechnen';

  @override
  String get ipv4SupernetActionReset => 'Zurücksetzen';

  @override
  String get ipv4SupernetAddressesTitle => 'Adressen';

  @override
  String get ipv4SupernetResultTitle => 'Supernet-Ergebnis';

  @override
  String get ipv4SupernetResultValue => 'Abdeckendes Supernet';

  @override
  String get ipv4SupernetRelationsTitle => 'Adressbeziehungen';

  @override
  String get ipv4SupernetContiguousYes => 'Alle Adressen sind zusammenhängend.';

  @override
  String get ipv4SupernetContiguousNo =>
      'Nicht alle Adressen sind zusammenhängend.';

  @override
  String get ipv4SupernetErrorEmptyAddress =>
      'Bitte eine IPv4-CIDR-Adresse eingeben.';

  @override
  String get ipv4SupernetErrorInvalidCidr => 'Ungültiges IPv4-CIDR-Format.';

  @override
  String get ipv4SupernetErrorNeedTwo =>
      'Bitte mindestens zwei IPv4-Adressen hinzufügen.';

  @override
  String get ipv4SupernetErrorGeneric =>
      'Supernet für diese Liste konnte nicht berechnet werden.';

  @override
  String ipv4SupernetDuplicateMessage(Object address, int count) {
    return 'Duplikat entfernt: $address ($count Einträge)';
  }

  @override
  String get relationEqual => 'gleich';

  @override
  String get relationOutside => 'außerhalb';

  @override
  String get relationContiguous => 'zusammenhängend';

  @override
  String get relationAInsideB => 'in B enthalten';

  @override
  String get relationBInsideA => 'B in A';

  @override
  String get relationOverlap => 'Überlappung';

  @override
  String get relationIntersecting => 'sich schneidend';

  @override
  String relationUnknown(Object code) {
    return 'unbekannt ($code)';
  }

  @override
  String get menuIpv6Address => 'IPv6-Adresse';

  @override
  String get menuIpv6Supernet => 'IPv6-Supernet';

  @override
  String get ipv6Title => 'IPv6-Adresse';

  @override
  String get ipv6InputLabel => 'IPv6-CIDR-Adresse';

  @override
  String get ipv6InputHint => 'Beispiel: 2001:db8::1/64';

  @override
  String get ipv6ActionCalculate => 'Berechnen';

  @override
  String get ipv6ActionClear => 'Löschen';

  @override
  String get ipv6ResultCopy => 'Ergebnis kopieren';

  @override
  String get ipv6ResultSave => 'Ergebnis speichern';

  @override
  String get ipv6ResultCopied => 'Ergebnis in die Zwischenablage kopiert.';

  @override
  String get ipv6ResultExportUnsupported =>
      'Dateiexport ist auf dieser Plattform nicht verfügbar.';

  @override
  String get ipv6ResultExportError =>
      'Das Ergebnis konnte nicht gespeichert werden.';

  @override
  String ipv6ResultExported(Object path) {
    return 'Ergebnis gespeichert unter: $path';
  }

  @override
  String get ipv6ErrorEmptyAddress => 'Leere IPv6-Adresse.';

  @override
  String get ipv6ErrorGeneric =>
      'Diese IPv6-Adresse konnte nicht verarbeitet werden.';

  @override
  String get ipv6InfoPrefix => 'Präfix';

  @override
  String get ipv6InfoType => 'Typ';

  @override
  String get ipv6InfoExpandedAddress => 'Erweiterte Adresse';

  @override
  String get ipv6InfoSimplifiedAddress => 'Vereinfachte Adresse';

  @override
  String get ipv6InfoNetwork => 'Netzwerkadresse';

  @override
  String get ipv6InfoSimplifiedNetwork => 'Vereinfachte Netzwerkadresse';

  @override
  String get ipv6InfoTotalAddresses => 'Anzahl der Adressen';

  @override
  String get ipv6InfoNetworkBinary => 'Netzwerk (binär)';

  @override
  String get ipv6TypeUnknown => 'Unbekannte Adresse.';

  @override
  String get ipv6SupernetTitle => 'IPv6-Supernet';

  @override
  String get ipv6SupernetInputLabel => 'IPv6-CIDR-Adresse';

  @override
  String get ipv6SupernetInputHint => 'Beispiel: 2001:db8::/64';

  @override
  String get ipv6SupernetActionAdd => 'Hinzufügen';

  @override
  String get ipv6SupernetActionCalculate => 'Supernet berechnen';

  @override
  String get ipv6SupernetActionReset => 'Zurücksetzen';

  @override
  String get ipv6SupernetAddressesTitle => 'Adressen';

  @override
  String get ipv6SupernetResultTitle => 'Supernet-Ergebnis';

  @override
  String get ipv6SupernetResultValue => 'Abdeckendes Supernet';

  @override
  String get ipv6SupernetRelationsTitle => 'Adressbeziehungen';

  @override
  String get ipv6SupernetContiguousYes => 'Alle Adressen sind zusammenhängend.';

  @override
  String get ipv6SupernetContiguousNo =>
      'Nicht alle Adressen sind zusammenhängend.';

  @override
  String get ipv6SupernetErrorEmptyAddress =>
      'Bitte eine IPv6-Adresse eingeben.';

  @override
  String get ipv6SupernetErrorInvalidCidr => 'Ungültiges IPv6-CIDR-Format.';

  @override
  String get ipv6SupernetErrorNeedTwo =>
      'Bitte mindestens zwei IPv6-Adressen hinzufügen.';

  @override
  String get ipv6SupernetErrorGeneric =>
      'Supernet für diese Liste konnte nicht berechnet werden.';

  @override
  String ipv6SupernetDuplicateMessage(Object address, int count) {
    return 'Duplikat entfernt: $address ($count Einträge)';
  }

  @override
  String get ipv6TypeLoopback => 'Loopback-Adresse.';

  @override
  String get ipv6TypeLinkLocal =>
      'Link-Local-Adresse (Kommunikation im selben Switch, nicht routbar).';

  @override
  String get ipv6TypeGlobalUnicast =>
      'Global Unicast Adresse (öffentliche Adresse, im Internet routbar).';

  @override
  String get ipv6TypeUniqueLocal =>
      'Unique-Local-Adresse (entspricht privaten IPv4-Adressen).';

  @override
  String get ipv6TypeMulticast => 'Multicast-Adresse.';

  @override
  String get ipv6TypeUnspecified => 'Nicht spezifizierte Adresse.';

  @override
  String get ipv6ErrorInvalidCidrFormat => 'Ungültiges IPv6-CIDR-Format.';

  @override
  String get ipv6ErrorInvalidSuffix => 'Ungültiger IPv6-Suffix.';

  @override
  String get ipv6ErrorInvalidAddress => 'Ungültige IPv6-Adresse.';

  @override
  String get ipv6ErrorInvalidMacFormat => 'Ungültiges MAC-Adressformat.';
}
