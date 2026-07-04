// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Calcolatrice';

  @override
  String get basicHistoryCopy => 'Copia cronologia';

  @override
  String get basicHistorySave => 'Salva cronologia';

  @override
  String get basicHistoryClear => 'Cancella cronologia';

  @override
  String get basicHistoryEmpty => 'La cronologia è vuota.';

  @override
  String get basicHistoryCopied => 'Cronologia copiata negli appunti.';

  @override
  String get basicHistoryExportUnsupported =>
      'L\'esportazione file non è disponibile su questa piattaforma.';

  @override
  String get basicHistoryExportError => 'Impossibile salvare la cronologia.';

  @override
  String basicHistoryExported(Object path) {
    return 'Cronologia salvata in: $path';
  }

  @override
  String get menuThemes => 'Temi';

  @override
  String get menuWhoAmI => 'Chi sono';

  @override
  String get menuDonate => 'Dona';

  @override
  String get close => 'Chiudi';

  @override
  String get whoAmITitle => 'Chi sono';

  @override
  String get whoAmIBody =>
      'Mi chiamo Walter Bianchi, sono uno sviluppatore software appassionato di applicazioni utili e belle.\n\nHo creato questa calcolatrice per offrire uno strumento di calcolo semplice ma potente.\n\nSpero che ti sia utile.\n\nSto cercando lavoro, quindi se ti piace questo progetto (scritto in Flutter) e vuoi lavorare con me, non esitare a contattarmi.\n';

  @override
  String get whoAmILinkedIn => 'Profilo LinkedIn';

  @override
  String get whoAmIDonateCta => 'Donazioni benvenute';

  @override
  String get donateTitle => 'Dona';

  @override
  String get donateIntro =>
      'Grazie per usare questa calcolatrice.\n\nSe trovi utile questa app e vuoi supportarne lo sviluppo, puoi fare una donazione:\n';

  @override
  String get donateViaPaypal => 'Dona con PayPal';

  @override
  String get donateOutro => 'Ogni contributo aiuta a migliorare questa app.';

  @override
  String get themeSettingsTitle => 'Impostazioni tema';

  @override
  String get themeBackgroundColor => 'Colore di sfondo:';

  @override
  String get themeBackgroundNeutral => 'Grigio tenue';

  @override
  String get themeBackgroundWallpaper => 'Sfondo';

  @override
  String get themeBackgroundMetal => 'Metallo spazzolato';

  @override
  String get themeDisplayTextColor => 'Colore testo display:';

  @override
  String get themeButtonGroupsColor => 'Colore gruppi di pulsanti:';

  @override
  String get themeButtonTextColor => 'Colore testo pulsanti:';

  @override
  String get colorWhite => 'Bianco';

  @override
  String get colorDark => 'Scuro';

  @override
  String get colorLightBlue => 'Azzurro chiaro';

  @override
  String get colorLightAmber => 'Ambra chiaro';

  @override
  String get colorBlack => 'Nero';

  @override
  String get colorBlue => 'Blu';

  @override
  String get colorGreen => 'Verde';

  @override
  String get colorDarkGrey => 'Grigio scuro';

  @override
  String get colorPurple => 'Viola';

  @override
  String get colorTeal => 'Verde acqua';

  @override
  String get colorLightGrey => 'Grigio chiaro';

  @override
  String get colorYellow => 'Giallo';

  @override
  String get photoCredit => 'Foto: Bady Abbas su Unsplash';

  @override
  String get menuSectionHealth => 'Salute';

  @override
  String get menuSectionConversions => 'Conversioni';

  @override
  String get menuSectionIpTools => 'Strumenti IP';

  @override
  String get menuSectionFinance => 'Finanza';

  @override
  String get menuSectionRealEstate => 'Immobiliare';

  @override
  String get bmiTitle => 'Calcolatore BMI';

  @override
  String get menuBmi => 'Calcolatore BMI';

  @override
  String get bmiPromptHeight => 'Altezza (m):';

  @override
  String get bmiPromptWeight => 'Peso (kg):';

  @override
  String get bmiPromptResult => 'BMI:';

  @override
  String get bmiActionEnter => 'Invio';

  @override
  String get bmiErrorInvalidHeight => 'Errore: altezza non valida';

  @override
  String get bmiErrorInvalidWeight => 'Errore: peso non valido';

  @override
  String get bmiErrorGeneric => 'Errore';

  @override
  String get bmiCategoryUnderweight => 'Sottopeso';

  @override
  String get bmiCategoryNormal => 'Peso normale';

  @override
  String get bmiCategoryOverweight => 'Sovrappeso';

  @override
  String get bmiCategoryObese => 'Obesità';

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
  String get menuDistance => 'Convertitore di distanza';

  @override
  String get distanceTitle => 'Convertitore di distanza';

  @override
  String get distanceLabelMetric => 'Metrico';

  @override
  String get distanceLabelImperial => 'Imperiale';

  @override
  String get distanceLabelNautical => 'Miglio nautico';

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
  String get menuIpv4Address => 'Indirizzo IPv4';

  @override
  String get menuIpv4Supernet => 'Supernet IPv4';

  @override
  String get ipv4Title => 'Indirizzo IPv4';

  @override
  String get ipv4InputLabel => 'Indirizzo IPv4 in CIDR';

  @override
  String get ipv4InputHint => 'Esempio: 192.168.1.34/24';

  @override
  String get ipv4ActionCalculate => 'Calcola';

  @override
  String get ipv4ActionClear => 'Cancella';

  @override
  String get ipv4ResultCopy => 'Copia risultato';

  @override
  String get ipv4ResultSave => 'Salva risultato';

  @override
  String get ipv4ResultCopied => 'Risultato copiato negli appunti.';

  @override
  String get ipv4ResultExportUnsupported =>
      'L\'esportazione file non è disponibile su questa piattaforma.';

  @override
  String get ipv4ResultExportError => 'Impossibile salvare il risultato.';

  @override
  String ipv4ResultExported(Object path) {
    return 'Risultato salvato in: $path';
  }

  @override
  String get ipv4ErrorEmptyCidr => 'Inserisci un indirizzo IPv4 in CIDR.';

  @override
  String get ipv4ErrorInvalidCidr => 'Formato CIDR IPv4 non valido.';

  @override
  String get ipv4ErrorGeneric => 'Impossibile elaborare questo CIDR IPv4.';

  @override
  String get ipv4InfoPrefix => 'Prefisso';

  @override
  String get ipv4InfoClass => 'Classe';

  @override
  String get ipv4InfoScope => 'Ambito';

  @override
  String get ipv4InfoMask => 'Maschera di sottorete';

  @override
  String get ipv4InfoWildcard => 'Maschera wildcard';

  @override
  String get ipv4InfoNetwork => 'Indirizzo di rete';

  @override
  String get ipv4InfoBroadcast => 'Indirizzo broadcast';

  @override
  String get ipv4InfoFirstHost => 'Primo host utilizzabile';

  @override
  String get ipv4InfoLastHost => 'Ultimo host utilizzabile';

  @override
  String get ipv4InfoTotalAddresses => 'Totale indirizzi';

  @override
  String get ipv4InfoUsableHosts => 'Host utilizzabili';

  @override
  String get ipv4InfoNetworkBinary => 'Rete (binario)';

  @override
  String get ipv4InfoBroadcastBinary => 'Broadcast (binario)';

  @override
  String get ipv4ScopePrivate => 'Privata';

  @override
  String get ipv4ScopePublic => 'Pubblica';

  @override
  String get ipv4ScopeLoopback => 'Loopback';

  @override
  String get ipv4ScopeLinkLocal => 'Link-local';

  @override
  String get ipv4ScopeMulticast => 'Multicast';

  @override
  String get ipv4ScopeReserved => 'Riservata/Sperimentale';

  @override
  String get ipv4SupernetTitle => 'Supernet IPv4';

  @override
  String get ipv4SupernetInputLabel => 'Indirizzo IPv4 in CIDR';

  @override
  String get ipv4SupernetInputHint => 'Esempio: 192.168.1.0/24';

  @override
  String get ipv4SupernetActionAdd => 'Aggiungi';

  @override
  String get ipv4SupernetActionCalculate => 'Calcola supernet';

  @override
  String get ipv4SupernetActionReset => 'Reimposta';

  @override
  String get ipv4SupernetAddressesTitle => 'Indirizzi';

  @override
  String get ipv4SupernetResultTitle => 'Risultato supernet';

  @override
  String get ipv4SupernetResultValue => 'Supernet di copertura';

  @override
  String get ipv4SupernetRelationsTitle => 'Relazioni tra indirizzi';

  @override
  String get ipv4SupernetContiguousYes => 'Tutti gli indirizzi sono contigui.';

  @override
  String get ipv4SupernetContiguousNo =>
      'Gli indirizzi non sono tutti contigui.';

  @override
  String get ipv4SupernetErrorEmptyAddress =>
      'Inserisci un indirizzo IPv4 in CIDR.';

  @override
  String get ipv4SupernetErrorInvalidCidr => 'Formato CIDR IPv4 non valido.';

  @override
  String get ipv4SupernetErrorNeedTwo => 'Aggiungi almeno due indirizzi IPv4.';

  @override
  String get ipv4SupernetErrorGeneric =>
      'Impossibile calcolare il supernet per questa lista.';

  @override
  String ipv4SupernetDuplicateMessage(Object address, int count) {
    return 'Duplicato rimosso: $address ($count voci)';
  }

  @override
  String get relationEqual => 'uguali';

  @override
  String get relationOutside => 'separati';

  @override
  String get relationContiguous => 'contigui';

  @override
  String get relationAInsideB => 'dentro';

  @override
  String get relationBInsideA => 'B dentro A';

  @override
  String get relationOverlap => 'sovrapposizione';

  @override
  String get relationIntersecting => 'intersezione';

  @override
  String relationUnknown(Object code) {
    return 'relazione sconosciuta ($code)';
  }

  @override
  String get menuIpv6Address => 'Indirizzo IPv6';

  @override
  String get menuIpv6Supernet => 'Supernet IPv6';

  @override
  String get ipv6Title => 'Indirizzo IPv6';

  @override
  String get ipv6InputLabel => 'Indirizzo IPv6 in CIDR';

  @override
  String get ipv6InputHint => 'Esempio: 2001:db8::1/64';

  @override
  String get ipv6ActionCalculate => 'Calcola';

  @override
  String get ipv6ActionClear => 'Cancella';

  @override
  String get ipv6ResultCopy => 'Copia risultato';

  @override
  String get ipv6ResultSave => 'Salva risultato';

  @override
  String get ipv6ResultCopied => 'Risultato copiato negli appunti.';

  @override
  String get ipv6ResultExportUnsupported =>
      'L\'esportazione file non è disponibile su questa piattaforma.';

  @override
  String get ipv6ResultExportError => 'Impossibile salvare il risultato.';

  @override
  String ipv6ResultExported(Object path) {
    return 'Risultato salvato in: $path';
  }

  @override
  String get ipv6ErrorEmptyAddress => 'Indirizzo IPv6 vuoto.';

  @override
  String get ipv6ErrorGeneric => 'Impossibile elaborare questo indirizzo IPv6.';

  @override
  String get ipv6InfoPrefix => 'Prefisso';

  @override
  String get ipv6InfoType => 'Tipo';

  @override
  String get ipv6InfoExpandedAddress => 'Indirizzo espanso';

  @override
  String get ipv6InfoSimplifiedAddress => 'Indirizzo semplificato';

  @override
  String get ipv6InfoNetwork => 'Indirizzo di rete';

  @override
  String get ipv6InfoSimplifiedNetwork => 'Indirizzo di rete semplificato';

  @override
  String get ipv6InfoTotalAddresses => 'Totale indirizzi';

  @override
  String get ipv6InfoNetworkBinary => 'Rete (binario)';

  @override
  String get ipv6TypeUnknown => 'Indirizzo sconosciuto.';

  @override
  String get ipv6SupernetTitle => 'Supernet IPv6';

  @override
  String get ipv6SupernetInputLabel => 'Indirizzo IPv6 in CIDR';

  @override
  String get ipv6SupernetInputHint => 'Esempio: 2001:db8::/64';

  @override
  String get ipv6SupernetActionAdd => 'Aggiungi';

  @override
  String get ipv6SupernetActionCalculate => 'Calcola supernet';

  @override
  String get ipv6SupernetActionReset => 'Reimposta';

  @override
  String get ipv6SupernetAddressesTitle => 'Indirizzi';

  @override
  String get ipv6SupernetResultTitle => 'Risultato supernet';

  @override
  String get ipv6SupernetResultValue => 'Supernet di copertura';

  @override
  String get ipv6SupernetRelationsTitle => 'Relazioni tra indirizzi';

  @override
  String get ipv6SupernetContiguousYes => 'Tutti gli indirizzi sono contigui.';

  @override
  String get ipv6SupernetContiguousNo =>
      'Gli indirizzi non sono tutti contigui.';

  @override
  String get ipv6SupernetErrorEmptyAddress => 'Inserisci un indirizzo IPv6.';

  @override
  String get ipv6SupernetErrorInvalidCidr => 'Formato CIDR IPv6 non valido.';

  @override
  String get ipv6SupernetErrorNeedTwo => 'Aggiungi almeno due indirizzi IPv6.';

  @override
  String get ipv6SupernetErrorGeneric =>
      'Impossibile calcolare il supernet per questa lista.';

  @override
  String ipv6SupernetDuplicateMessage(Object address, int count) {
    return 'Duplicato rimosso: $address ($count voci)';
  }

  @override
  String get ipv6TypeLoopback => 'Indirizzo loopback.';

  @override
  String get ipv6TypeLinkLocal =>
      'Indirizzo link-local (comunicazione sullo stesso switch, non instradabile).';

  @override
  String get ipv6TypeGlobalUnicast =>
      'Indirizzo global unicast (indirizzo pubblico instradabile su Internet).';

  @override
  String get ipv6TypeUniqueLocal =>
      'Indirizzo unique local (equivalente agli indirizzi privati IPv4).';

  @override
  String get ipv6TypeMulticast => 'Indirizzo multicast.';

  @override
  String get ipv6TypeUnspecified => 'Indirizzo non specificato.';

  @override
  String get ipv6ErrorInvalidCidrFormat => 'Formato CIDR IPv6 non valido.';

  @override
  String get ipv6ErrorInvalidSuffix => 'Suffisso IPv6 non valido.';

  @override
  String get ipv6ErrorInvalidAddress => 'Indirizzo IPv6 non valido.';

  @override
  String get ipv6ErrorInvalidMacFormat =>
      'Formato dell\'indirizzo MAC non valido.';
}
