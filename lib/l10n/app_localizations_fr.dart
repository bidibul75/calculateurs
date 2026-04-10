// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Calculatrice basique';

  @override
  String get basicHistoryCopy => 'Copier l\'historique';

  @override
  String get basicHistorySave => 'Enregistrer l\'historique';

  @override
  String get basicHistoryClear => 'Effacer l\'historique';

  @override
  String get basicHistoryEmpty => 'L\'historique est vide.';

  @override
  String get basicHistoryCopied => 'Historique copié dans le presse-papiers.';

  @override
  String get basicHistoryExportUnsupported =>
      'L\'export de fichier n\'est pas disponible sur cette plateforme.';

  @override
  String get basicHistoryExportError =>
      'Impossible d\'enregistrer l\'historique.';

  @override
  String basicHistoryExported(Object path) {
    return 'Historique enregistré dans : $path';
  }

  @override
  String get menuThemes => 'Thèmes';

  @override
  String get menuWhoAmI => 'Qui suis-je';

  @override
  String get menuDonate => 'Faire un don';

  @override
  String get close => 'Fermer';

  @override
  String get whoAmITitle => 'Qui suis-je';

  @override
  String get whoAmIBody =>
      'Je m\'appelle Walter Bianchi, je suis développeur logiciel, passionné par la création d\'applications utiles et esthétiques.\n\nJ\'ai créé cette calculatrice pour proposer un outil simple mais puissant pour les calculs.\n\nJ\'espère qu\'elle vous sera utile !\n\nJe recherche un emploi, donc si vous aimez ce projet (écrit en Flutter) et souhaitez travailler avec moi, n\'hésitez pas à me contacter !\n';

  @override
  String get whoAmILinkedIn => 'Profil LinkedIn';

  @override
  String get whoAmIDonateCta => 'Les dons sont les bienvenus !';

  @override
  String get donateTitle => 'Faire un don';

  @override
  String get donateIntro =>
      'Merci d\'utiliser cette calculatrice !\n\nSi cette application vous est utile et que vous souhaitez soutenir son développement, vous pouvez faire un don :\n';

  @override
  String get donateViaPaypal => 'Faire un don via PayPal';

  @override
  String get donateOutro =>
      'Chaque contribution aide à améliorer cette application !';

  @override
  String get themeSettingsTitle => 'Paramètres du thème';

  @override
  String get themeBackgroundColor => 'Couleur d\'arrière-plan :';

  @override
  String get themeBackgroundNeutral => 'Gris doux';

  @override
  String get themeBackgroundWallpaper => 'Fond d\'écran';

  @override
  String get themeBackgroundMetal => 'Métal brossé';

  @override
  String get themeDisplayTextColor => 'Couleur du texte de l\'affichage :';

  @override
  String get themeButtonGroupsColor => 'Couleur des groupes de boutons :';

  @override
  String get themeButtonTextColor => 'Couleur du texte des boutons :';

  @override
  String get colorWhite => 'Blanc';

  @override
  String get colorDark => 'Sombre';

  @override
  String get colorLightBlue => 'Bleu clair';

  @override
  String get colorLightAmber => 'Ambre clair';

  @override
  String get colorBlack => 'Noir';

  @override
  String get colorBlue => 'Bleu';

  @override
  String get colorGreen => 'Vert';

  @override
  String get colorDarkGrey => 'Gris foncé';

  @override
  String get colorPurple => 'Violet';

  @override
  String get colorTeal => 'Bleu-vert';

  @override
  String get colorLightGrey => 'Gris clair';

  @override
  String get colorYellow => 'Jaune';

  @override
  String get photoCredit => 'Photo : Bady Abbas sur Unsplash';

  @override
  String get menuSectionHealth => 'Santé';

  @override
  String get menuSectionConversions => 'Outils IP';

  @override
  String get menuSectionFinance => 'Finances';

  @override
  String get menuSectionRealEstate => 'Immobilier';

  @override
  String get bmiTitle => 'Calculateur IMC';

  @override
  String get menuBmi => 'Calculateur IMC';

  @override
  String get bmiPromptHeight => 'Taille (m) :';

  @override
  String get bmiPromptWeight => 'Poids (kg) :';

  @override
  String get bmiPromptResult => 'IMC :';

  @override
  String get bmiActionEnter => 'Valider';

  @override
  String get bmiErrorInvalidHeight => 'Erreur : taille incorrecte';

  @override
  String get bmiErrorInvalidWeight => 'Erreur : poids incorrect';

  @override
  String get bmiErrorGeneric => 'Erreur';

  @override
  String get bmiCategoryUnderweight => 'Maigreur';

  @override
  String get bmiCategoryNormal => 'Poids normal';

  @override
  String get bmiCategoryOverweight => 'Surpoids';

  @override
  String get bmiCategoryObese => 'Obésité';

  @override
  String get menuIpv4Address => 'Adresse IPv4';

  @override
  String get menuIpv4Supernet => 'Supernet IPv4';

  @override
  String get ipv4Title => 'Adresse IPv4';

  @override
  String get ipv4InputLabel => 'Adresse IPv4 en CIDR';

  @override
  String get ipv4InputHint => 'Exemple : 192.168.1.34/24';

  @override
  String get ipv4ActionCalculate => 'Calculer';

  @override
  String get ipv4ActionClear => 'Effacer';

  @override
  String get ipv4ErrorEmptyCidr => 'Veuillez saisir une adresse IPv4 en CIDR.';

  @override
  String get ipv4ErrorInvalidCidr => 'Format CIDR IPv4 invalide.';

  @override
  String get ipv4ErrorGeneric => 'Impossible de traiter ce CIDR IPv4.';

  @override
  String get ipv4InfoPrefix => 'Préfixe';

  @override
  String get ipv4InfoClass => 'Classe';

  @override
  String get ipv4InfoScope => 'Portée';

  @override
  String get ipv4InfoMask => 'Masque de sous-réseau';

  @override
  String get ipv4InfoWildcard => 'Masque wildcard';

  @override
  String get ipv4InfoNetwork => 'Adresse réseau';

  @override
  String get ipv4InfoBroadcast => 'Adresse de diffusion';

  @override
  String get ipv4InfoFirstHost => 'Premier hôte utilisable';

  @override
  String get ipv4InfoLastHost => 'Dernier hôte utilisable';

  @override
  String get ipv4InfoTotalAddresses => 'Nombre total d\'adresses';

  @override
  String get ipv4InfoUsableHosts => 'Hôtes utilisables';

  @override
  String get ipv4InfoNetworkBinary => 'Réseau (binaire)';

  @override
  String get ipv4InfoBroadcastBinary => 'Diffusion (binaire)';

  @override
  String get ipv4ScopePrivate => 'Privée';

  @override
  String get ipv4ScopePublic => 'Publique';

  @override
  String get ipv4ScopeLoopback => 'Loopback';

  @override
  String get ipv4ScopeLinkLocal => 'Link-local';

  @override
  String get ipv4ScopeMulticast => 'Multicast';

  @override
  String get ipv4ScopeReserved => 'Réservée/Expérimentale';

  @override
  String get ipv4SupernetTitle => 'Supernet IPv4';

  @override
  String get ipv4SupernetInputLabel => 'Adresse IPv4 en CIDR';

  @override
  String get ipv4SupernetInputHint => 'Exemple : 192.168.1.0/24';

  @override
  String get ipv4SupernetActionAdd => 'Ajouter';

  @override
  String get ipv4SupernetActionCalculate => 'Calculer le supernet';

  @override
  String get ipv4SupernetActionReset => 'Réinitialiser';

  @override
  String get ipv4SupernetAddressesTitle => 'Adresses';

  @override
  String get ipv4SupernetResultTitle => 'Résultat du supernet';

  @override
  String get ipv4SupernetResultValue => 'Supernet couvrant';

  @override
  String get ipv4SupernetRelationsTitle => 'Relations entre adresses';

  @override
  String get ipv4SupernetContiguousYes => 'Toutes les adresses sont contiguës.';

  @override
  String get ipv4SupernetContiguousNo =>
      'Les adresses ne sont pas toutes contiguës.';

  @override
  String get ipv4SupernetErrorEmptyAddress =>
      'Veuillez saisir une adresse IPv4 en CIDR.';

  @override
  String get ipv4SupernetErrorInvalidCidr => 'Format CIDR IPv4 invalide.';

  @override
  String get ipv4SupernetErrorNeedTwo =>
      'Veuillez ajouter au moins deux adresses IPv4.';

  @override
  String get ipv4SupernetErrorGeneric =>
      'Impossible de calculer le supernet pour cette liste.';

  @override
  String ipv4SupernetDuplicateMessage(Object address, int count) {
    return 'Doublon retiré : $address ($count occurrences)';
  }

  @override
  String get relationEqual => 'égales';

  @override
  String get relationOutside => 'séparées';

  @override
  String get relationContiguous => 'contiguës';

  @override
  String get relationAInsideB => 'incluse dans';

  @override
  String get relationBInsideA => 'B incluse dans A';

  @override
  String get relationOverlap => 'chevauchement';

  @override
  String get relationIntersecting => 'intersection';

  @override
  String relationUnknown(Object code) {
    return 'relation inconnue ($code)';
  }

  @override
  String get ipv6TypeLoopback => 'Adresse loopback.';

  @override
  String get ipv6TypeLinkLocal =>
      'Adresse link-local (communication sur le même switch, non routable).';

  @override
  String get ipv6TypeGlobalUnicast =>
      'Adresse unicast globale (adresse publique routable sur Internet).';

  @override
  String get ipv6TypeUniqueLocal =>
      'Adresse unique local (équivalent aux adresses privées IPv4).';

  @override
  String get ipv6TypeMulticast => 'Adresse multicast.';

  @override
  String get ipv6TypeUnspecified => 'Adresse non spécifiée.';

  @override
  String get ipv6ErrorInvalidCidrFormat => 'Format CIDR IPv6 invalide.';

  @override
  String get ipv6ErrorEmptyAddress => 'Adresse IPv6 vide.';

  @override
  String get ipv6ErrorInvalidSuffix => 'Suffixe IPv6 invalide.';

  @override
  String get ipv6ErrorInvalidAddress => 'Adresse IPv6 invalide.';

  @override
  String get ipv6ErrorInvalidMacFormat => 'Format d\'adresse MAC invalide.';
}
