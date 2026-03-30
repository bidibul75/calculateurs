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
  String get colorTeal => 'Sarcelle';

  @override
  String get colorLightGrey => 'Gris clair';

  @override
  String get colorYellow => 'Jaune';

  @override
  String get photoCredit => 'Photo : Bady Abbas sur Unsplash';

  @override
  String get menuSectionHealth => 'Santé';

  @override
  String get menuSectionConversions => 'Conversions';

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
  String get ipv6TypeLoopback => 'Adresse loopback.';

  @override
  String get ipv6TypeLinkLocal =>
      'Adresse link-local (communication sur le même switch, non routable).';

  @override
  String get ipv6TypeGlobalUnicast =>
      'Adresse global unicast (adresse publique routable sur Internet).';

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
