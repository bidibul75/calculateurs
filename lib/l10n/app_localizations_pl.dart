// lib/l10n/app_localizations_pl.dart
// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Kalkulator';

  @override
  String get basicHistoryCopy => 'Skopiuj historię';

  @override
  String get basicHistorySave => 'Zapisz historię';

  @override
  String get basicHistoryClear => 'Wyczyść historię';

  @override
  String get basicHistoryEmpty => 'Historia jest pusta.';

  @override
  String get basicHistoryCopied => 'Historia skopiowana do schowka.';

  @override
  String get basicHistoryExportUnsupported =>
      'Eksport plików nie jest dostępny na tej platformie.';

  @override
  String get basicHistoryExportError => 'Nie można zapisać historii.';

  @override
  String basicHistoryExported(Object path) {
    return 'Historia zapisana w: $path';
  }

  @override
  String get menuThemes => 'Motywy';

  @override
  String get menuWhoAmI => 'Kim jestem';

  @override
  String get menuDonate => 'Podarować';

  @override
  String get close => 'Zamknąć';

  @override
  String get whoAmITitle => 'Kim jestem';

  @override
  String get whoAmIBody =>
      'Nazywam się Walter Bianchi, jestem programistą z pasją do tworzenia użytecznych i pięknych aplikacji.\n\nStworzyłem ten kalkulator, aby zapewnić proste, ale potężne narzędzie do obliczeń.\n\nMam nadzieję, że uznasz to za pomocne!\n\nSzukam pracy, więc jeśli podoba Ci się ten projekt (napisany we Flutterze) i chcesz ze mną współpracować, nie wahaj się ze mną skontaktować!';

  @override
  String get whoAmILinkedIn => 'Profil LinkedIn';

  @override
  String get whoAmIDonateCta => 'Darowizny mile widziane!';

  @override
  String get donateTitle => 'Podarować';

  @override
  String get donateIntro =>
      'Dziękujemy za skorzystanie z tego kalkulatora!\n\nJeśli uznasz tę aplikację za przydatną i chcesz wesprzeć jej rozwój, możesz przekazać darowiznę:';

  @override
  String get donateViaPaypal => 'Przekaż darowiznę za pośrednictwem PayPal';

  @override
  String get donateOutro => 'Każdy wkład pomaga ulepszyć tę aplikację!';

  @override
  String get themeSettingsTitle => 'Ustawienia motywu';

  @override
  String get themeBackgroundColor => 'Kolor tła:';

  @override
  String get themeBackgroundNeutral => 'Miękki szary';

  @override
  String get themeBackgroundWallpaper => 'Tapeta';

  @override
  String get themeBackgroundMetal => 'Szczotkowany metal';

  @override
  String get themeDisplayTextColor => 'Kolor tekstu wyświetlacza:';

  @override
  String get themeButtonGroupsColor => 'Kolor grup przycisków:';

  @override
  String get themeButtonTextColor => 'Kolor tekstu przycisku:';

  @override
  String get colorWhite => 'Biały';

  @override
  String get colorDark => 'Ciemny';

  @override
  String get colorLightBlue => 'Jasnoniebieski';

  @override
  String get colorLightAmber => 'Jasny Bursztyn';

  @override
  String get colorBlack => 'Czarny';

  @override
  String get colorBlue => 'Niebieski';

  @override
  String get colorGreen => 'Zielony';

  @override
  String get colorDarkGrey => 'Ciemnoszary';

  @override
  String get colorPurple => 'Fioletowy';

  @override
  String get colorTeal => 'Cyraneczka';

  @override
  String get colorLightGrey => 'Jasnoszary';

  @override
  String get colorYellow => 'Żółty';

  @override
  String get photoCredit => 'Zdjęcie: Bady Abbas na Unsplash';

  @override
  String get menuSectionHealth => 'Zdrowie';

  @override
  String get menuSectionConversions => 'Konwersje';

  @override
  String get menuSectionIpTools => 'Narzędzia IP';

  @override
  String get menuSectionFinance => 'Finanse';

  @override
  String get menuSectionRealEstate => 'Nieruchomość';

  @override
  String get bmiTitle => 'Kalkulator BMI';

  @override
  String get menuBmi => 'Kalkulator BMI';

  @override
  String get bmiPromptHeight => 'Wysokość (m):';

  @override
  String get bmiPromptWeight => 'Waga (kg):';

  @override
  String get bmiPromptResult => 'Wska?nik BMI:';

  @override
  String get bmiActionEnter => 'Wchodzić';

  @override
  String get bmiErrorInvalidHeight => 'Błąd: nieprawidłowa wysokość';

  @override
  String get bmiErrorInvalidWeight => 'Błąd: nieprawidłowa waga';

  @override
  String get bmiErrorGeneric => 'Błąd';

  @override
  String get bmiCategoryUnderweight => 'Niedowaga';

  @override
  String get bmiCategoryNormal => 'Normalna waga';

  @override
  String get bmiCategoryOverweight => 'Nadwaga';

  @override
  String get bmiCategoryObese => 'Otyły';

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
  String get menuIpv4Address => 'Adres IPv4';

  @override
  String get menuIpv4Supernet => 'Supersieć IPv4';

  @override
  String get ipv4Title => 'Adres IPv4';

  @override
  String get ipv4InputLabel => 'Adres CIDR IPv4';

  @override
  String get ipv4InputHint => 'Przykład: 192.168.1.34/24';

  @override
  String get ipv4ActionCalculate => 'Obliczać';

  @override
  String get ipv4ActionClear => 'Jasne';

  @override
  String get ipv4ResultCopy => 'Skopiuj wynik';

  @override
  String get ipv4ResultSave => 'Zapisz wynik';

  @override
  String get ipv4ResultCopied => 'Wynik skopiowany do schowka.';

  @override
  String get ipv4ResultExportUnsupported =>
      'Eksport plików nie jest dostępny na tej platformie.';

  @override
  String get ipv4ResultExportError => 'Nie można zapisać wyniku.';

  @override
  String ipv4ResultExported(Object path) {
    return 'Wynik zapisany w: $path';
  }

  @override
  String get ipv4ErrorEmptyCidr => 'Wprowadź adres CIDR IPv4.';

  @override
  String get ipv4ErrorInvalidCidr => 'Nieprawidłowy format CIDR IPv4.';

  @override
  String get ipv4ErrorGeneric => 'Nie można przetworzyć tego CIDR IPv4.';

  @override
  String get ipv4InfoPrefix => 'Prefiks';

  @override
  String get ipv4InfoClass => 'Klasa';

  @override
  String get ipv4InfoScope => 'Zakres';

  @override
  String get ipv4InfoMask => 'Maska podsieci';

  @override
  String get ipv4InfoWildcard => 'Maska wieloznaczna';

  @override
  String get ipv4InfoNetwork => 'Adres sieciowy';

  @override
  String get ipv4InfoBroadcast => 'Adres rozgłoszeniowy';

  @override
  String get ipv4InfoFirstHost => 'Pierwszy użyteczny host';

  @override
  String get ipv4InfoLastHost => 'Ostatni użyteczny host';

  @override
  String get ipv4InfoTotalAddresses => 'Łączna liczba adresów';

  @override
  String get ipv4InfoUsableHosts => 'Użyteczne hosty';

  @override
  String get ipv4InfoNetworkBinary => 'Sieć (binarna)';

  @override
  String get ipv4InfoBroadcastBinary => 'Transmisja (binarna)';

  @override
  String get ipv4ScopePrivate => 'Prywatny';

  @override
  String get ipv4ScopePublic => 'Publiczny';

  @override
  String get ipv4ScopeLoopback => 'Pętla zwrotna';

  @override
  String get ipv4ScopeLinkLocal => 'Link-lokalny';

  @override
  String get ipv4ScopeMulticast => 'Multiemisji';

  @override
  String get ipv4ScopeReserved => 'Zarezerwowane/eksperymentalne';

  @override
  String get ipv4SupernetTitle => 'Supersieć IPv4';

  @override
  String get ipv4SupernetInputLabel => 'Adres CIDR IPv4';

  @override
  String get ipv4SupernetInputHint => 'Przykład: 192.168.1.0/24';

  @override
  String get ipv4SupernetActionAdd => 'Dodać';

  @override
  String get ipv4SupernetActionCalculate => 'Oblicz supersieć';

  @override
  String get ipv4SupernetActionReset => 'Nastawić';

  @override
  String get ipv4SupernetAddressesTitle => 'Adresy';

  @override
  String get ipv4SupernetResultTitle => 'Wynik supersieci';

  @override
  String get ipv4SupernetResultValue => 'Pokrycie supersieci';

  @override
  String get ipv4SupernetRelationsTitle => 'Relacje adresowe';

  @override
  String get ipv4SupernetContiguousYes => 'Wszystkie adresy sąsiadują ze sobą.';

  @override
  String get ipv4SupernetContiguousNo =>
      'Nie wszystkie adresy sąsiadują ze sobą.';

  @override
  String get ipv4SupernetErrorEmptyAddress => 'Wprowadź adres CIDR IPv4.';

  @override
  String get ipv4SupernetErrorInvalidCidr => 'Nieprawidłowy format CIDR IPv4.';

  @override
  String get ipv4SupernetErrorNeedTwo => 'Dodaj co najmniej dwa adresy IPv4.';

  @override
  String get ipv4SupernetErrorGeneric =>
      'Nie można obliczyć supersieci dla tej listy.';

  @override
  String ipv4SupernetDuplicateMessage(Object address, int count) {
    return 'Duplikat został usunięty: $address (wpisy $count)';
  }

  @override
  String get relationEqual => 'równy';

  @override
  String get relationOutside => 'poza';

  @override
  String get relationContiguous => 'przylegający';

  @override
  String get relationAInsideB => 'wewnątrz';

  @override
  String get relationBInsideA => 'B wewnątrz A';

  @override
  String get relationOverlap => 'zachodzić na siebie';

  @override
  String get relationIntersecting => 'krzyżujący';

  @override
  String relationUnknown(Object code) {
    return 'nieznany ($code)';
  }

  @override
  String get menuIpv6Address => 'Adres IPv6';

  @override
  String get menuIpv6Supernet => 'Supersieć IPv6';

  @override
  String get ipv6Title => 'Adres IPv6';

  @override
  String get ipv6InputLabel => 'Adres CIDR IPv6';

  @override
  String get ipv6InputHint => 'Przykład: 2001:db8::1/64';

  @override
  String get ipv6ActionCalculate => 'Obliczać';

  @override
  String get ipv6ActionClear => 'Jasne';

  @override
  String get ipv6ResultCopy => 'Skopiuj wynik';

  @override
  String get ipv6ResultSave => 'Zapisz wynik';

  @override
  String get ipv6ResultCopied => 'Wynik skopiowany do schowka.';

  @override
  String get ipv6ResultExportUnsupported =>
      'Eksport plików nie jest dostępny na tej platformie.';

  @override
  String get ipv6ResultExportError => 'Nie można zapisać wyniku.';

  @override
  String ipv6ResultExported(Object path) {
    return 'Wynik zapisany w: $path';
  }

  @override
  String get ipv6ErrorEmptyAddress => 'Pusty adres IPv6.';

  @override
  String get ipv6ErrorGeneric => 'Nie można przetworzyć tego adresu IPv6.';

  @override
  String get ipv6InfoPrefix => 'Prefiks';

  @override
  String get ipv6InfoType => 'Typ';

  @override
  String get ipv6InfoExpandedAddress => 'Rozwinięty adres';

  @override
  String get ipv6InfoSimplifiedAddress => 'Uproszczony adres';

  @override
  String get ipv6InfoNetwork => 'Adres sieciowy';

  @override
  String get ipv6InfoSimplifiedNetwork => 'Uproszczony adres sieciowy';

  @override
  String get ipv6InfoTotalAddresses => 'Łączna liczba adresów';

  @override
  String get ipv6InfoNetworkBinary => 'Sieć (binarna)';

  @override
  String get ipv6TypeUnknown => 'Nieznany adres.';

  @override
  String get ipv6SupernetTitle => 'Supersieć IPv6';

  @override
  String get ipv6SupernetInputLabel => 'Adres CIDR IPv6';

  @override
  String get ipv6SupernetInputHint => 'Przykład: 2001:db8::/64';

  @override
  String get ipv6SupernetActionAdd => 'Dodać';

  @override
  String get ipv6SupernetActionCalculate => 'Oblicz supersieć';

  @override
  String get ipv6SupernetActionReset => 'Nastawić';

  @override
  String get ipv6SupernetAddressesTitle => 'Adresy';

  @override
  String get ipv6SupernetResultTitle => 'Wynik supersieci';

  @override
  String get ipv6SupernetResultValue => 'Pokrycie supersieci';

  @override
  String get ipv6SupernetRelationsTitle => 'Relacje adresowe';

  @override
  String get ipv6SupernetContiguousYes => 'Wszystkie adresy sąsiadują ze sobą.';

  @override
  String get ipv6SupernetContiguousNo =>
      'Nie wszystkie adresy sąsiadują ze sobą.';

  @override
  String get ipv6SupernetErrorEmptyAddress => 'Proszę wprowadzić adres IPv6.';

  @override
  String get ipv6SupernetErrorInvalidCidr => 'Nieprawidłowy format CIDR IPv6.';

  @override
  String get ipv6SupernetErrorNeedTwo => 'Dodaj co najmniej dwa adresy IPv6.';

  @override
  String get ipv6SupernetErrorGeneric =>
      'Nie można obliczyć supersieci dla tej listy.';

  @override
  String ipv6SupernetDuplicateMessage(Object address, int count) {
    return 'Duplikat został usunięty: $address (wpisy $count)';
  }

  @override
  String get ipv6TypeLoopback => 'Adres zwrotny.';

  @override
  String get ipv6TypeLinkLocal =>
      'Link-Adres lokalny (komunikacja na tym samym przełączniku, bez możliwości routingu).';

  @override
  String get ipv6TypeGlobalUnicast =>
      'Globalny adres Unicast (adres publiczny z możliwością routingu w Internecie).';

  @override
  String get ipv6TypeUniqueLocal =>
      'Unikalny adres lokalny (równoważny adresom prywatnym IPv4).';

  @override
  String get ipv6TypeMulticast => 'Adres multiemisji.';

  @override
  String get ipv6TypeUnspecified => 'Nieokreślony adres.';

  @override
  String get ipv6ErrorInvalidCidrFormat => 'Nieprawidłowy format CIDR IPv6.';

  @override
  String get ipv6ErrorInvalidSuffix => 'Nieprawidłowy sufiks IPv6.';

  @override
  String get ipv6ErrorInvalidAddress => 'Nieprawidłowy adres IPv6.';

  @override
  String get ipv6ErrorInvalidMacFormat => 'Nieprawidłowy format adresu MAC.';
}
