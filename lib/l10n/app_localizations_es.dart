// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Calculadora básica';

  @override
  String get menuThemes => 'Temas';

  @override
  String get menuWhoAmI => 'Quién soy';

  @override
  String get menuDonate => 'Donar';

  @override
  String get close => 'Cerrar';

  @override
  String get whoAmITitle => 'Quién soy';

  @override
  String get whoAmIBody =>
      'Me llamo Walter Bianchi, soy desarrollador de software y me apasiona crear aplicaciones útiles y bonitas.\n\nCreé esta calculadora para ofrecer una herramienta de cálculo simple pero potente.\n\nEspero que te resulte útil.\n\nEstoy buscando trabajo, así que si te gusta este proyecto (escrito en Flutter) y quieres trabajar conmigo, no dudes en contactarme.\n';

  @override
  String get whoAmILinkedIn => 'Perfil de LinkedIn';

  @override
  String get whoAmIDonateCta => 'Donaciones bienvenidas';

  @override
  String get donateTitle => 'Donar';

  @override
  String get donateIntro =>
      'Gracias por usar esta calculadora.\n\nSi esta aplicación te resulta útil y quieres apoyar su desarrollo, puedes hacer una donación:\n';

  @override
  String get donateViaPaypal => 'Donar con PayPal';

  @override
  String get donateOutro =>
      'Cada contribución ayuda a mejorar esta aplicación.';

  @override
  String get themeSettingsTitle => 'Configuración del tema';

  @override
  String get themeBackgroundColor => 'Color de fondo:';

  @override
  String get themeDisplayTextColor => 'Color del texto de pantalla:';

  @override
  String get themeButtonGroupsColor => 'Color de grupos de botones:';

  @override
  String get themeButtonTextColor => 'Color del texto de botones:';

  @override
  String get colorWhite => 'Blanco';

  @override
  String get colorDark => 'Oscuro';

  @override
  String get colorLightBlue => 'Azul claro';

  @override
  String get colorLightAmber => 'Ámbar claro';

  @override
  String get colorBlack => 'Negro';

  @override
  String get colorBlue => 'Azul';

  @override
  String get colorGreen => 'Verde';

  @override
  String get colorDarkGrey => 'Gris oscuro';

  @override
  String get colorPurple => 'Morado';

  @override
  String get colorTeal => 'Verde azulado';

  @override
  String get colorLightGrey => 'Gris claro';

  @override
  String get colorYellow => 'Amarillo';

  @override
  String get photoCredit => 'Foto: Bady Abbas en Unsplash';

  @override
  String get menuSectionHealth => 'Salud';

  @override
  String get menuSectionConversions => 'Herramientas IP';

  @override
  String get menuSectionFinance => 'Finanzas';

  @override
  String get menuSectionRealEstate => 'Inmobiliario';

  @override
  String get bmiTitle => 'Calculadora IMC';

  @override
  String get menuBmi => 'Calculadora IMC';

  @override
  String get bmiPromptHeight => 'Altura (m):';

  @override
  String get bmiPromptWeight => 'Peso (kg):';

  @override
  String get bmiPromptResult => 'IMC:';

  @override
  String get bmiActionEnter => 'Aceptar';

  @override
  String get bmiErrorInvalidHeight => 'Error: altura incorrecta';

  @override
  String get bmiErrorInvalidWeight => 'Error: peso incorrecto';

  @override
  String get bmiErrorGeneric => 'Error';

  @override
  String get bmiCategoryUnderweight => 'Bajo peso';

  @override
  String get bmiCategoryNormal => 'Peso normal';

  @override
  String get bmiCategoryOverweight => 'Sobrepeso';

  @override
  String get bmiCategoryObese => 'Obesidad';

  @override
  String get menuIpv4Address => 'Direccion IPv4';

  @override
  String get ipv4Title => 'Direccion IPv4';

  @override
  String get ipv4InputLabel => 'Direccion IPv4 en CIDR';

  @override
  String get ipv4InputHint => 'Ejemplo: 192.168.1.34/24';

  @override
  String get ipv4ActionCalculate => 'Calcular';

  @override
  String get ipv4ActionClear => 'Limpiar';

  @override
  String get ipv4ErrorEmptyCidr => 'Introduce una direccion IPv4 en CIDR.';

  @override
  String get ipv4ErrorInvalidCidr => 'Formato CIDR IPv4 invalido.';

  @override
  String get ipv4ErrorGeneric => 'No se puede procesar este CIDR IPv4.';

  @override
  String get ipv4InfoPrefix => 'Prefijo';

  @override
  String get ipv4InfoClass => 'Clase';

  @override
  String get ipv4InfoScope => 'Ambito';

  @override
  String get ipv4InfoMask => 'Mascara de subred';

  @override
  String get ipv4InfoWildcard => 'Mascara wildcard';

  @override
  String get ipv4InfoNetwork => 'Direccion de red';

  @override
  String get ipv4InfoBroadcast => 'Direccion de broadcast';

  @override
  String get ipv4InfoFirstHost => 'Primer host util';

  @override
  String get ipv4InfoLastHost => 'Ultimo host util';

  @override
  String get ipv4InfoTotalAddresses => 'Total de direcciones';

  @override
  String get ipv4InfoUsableHosts => 'Hosts utilizables';

  @override
  String get ipv4InfoNetworkBinary => 'Red (binario)';

  @override
  String get ipv4InfoBroadcastBinary => 'Broadcast (binario)';

  @override
  String get ipv4ScopePrivate => 'Privada';

  @override
  String get ipv4ScopePublic => 'Publica';

  @override
  String get ipv4ScopeLoopback => 'Loopback';

  @override
  String get ipv4ScopeLinkLocal => 'Link-local';

  @override
  String get ipv4ScopeMulticast => 'Multicast';

  @override
  String get ipv4ScopeReserved => 'Reservada/Experimental';

  @override
  String get ipv6TypeLoopback => 'Dirección loopback.';

  @override
  String get ipv6TypeLinkLocal =>
      'Dirección link-local (comunicación en el mismo switch, no enrutable).';

  @override
  String get ipv6TypeGlobalUnicast =>
      'Dirección global unicast (dirección pública enrutable en Internet).';

  @override
  String get ipv6TypeUniqueLocal =>
      'Dirección unique local (equivalente a direcciones privadas IPv4).';

  @override
  String get ipv6TypeMulticast => 'Dirección multicast.';

  @override
  String get ipv6TypeUnspecified => 'Dirección no especificada.';

  @override
  String get ipv6ErrorInvalidCidrFormat => 'Formato CIDR IPv6 inválido.';

  @override
  String get ipv6ErrorEmptyAddress => 'Dirección IPv6 vacía.';

  @override
  String get ipv6ErrorInvalidSuffix => 'Sufijo IPv6 inválido.';

  @override
  String get ipv6ErrorInvalidAddress => 'Dirección IPv6 inválida.';

  @override
  String get ipv6ErrorInvalidMacFormat => 'Formato de dirección MAC inválido.';
}
