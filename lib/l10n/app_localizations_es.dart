// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Calculadora';

  @override
  String get basicHistoryCopy => 'Copiar historial';

  @override
  String get basicHistorySave => 'Guardar historial';

  @override
  String get basicHistoryClear => 'Borrar historial';

  @override
  String get basicHistoryEmpty => 'El historial está vacío.';

  @override
  String get basicHistoryCopied => 'Historial copiado al portapapeles.';

  @override
  String get basicHistoryExportUnsupported =>
      'La exportación de archivos no está disponible en esta plataforma.';

  @override
  String get basicHistoryExportError => 'No se puede guardar el historial.';

  @override
  String basicHistoryExported(Object path) {
    return 'Historial guardado en: $path';
  }

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
  String get themeBackgroundNeutral => 'Gris suave';

  @override
  String get themeBackgroundWallpaper => 'Fondo de pantalla';

  @override
  String get themeBackgroundMetal => 'Metal cepillado';

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
  String get menuSectionConversions => 'Conversiones';

  @override
  String get menuSectionIpTools => 'Herramientas IP';

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
  String get menuIpv4Address => 'Dirección IPv4';

  @override
  String get menuIpv4Supernet => 'Superred IPv4';

  @override
  String get ipv4Title => 'Dirección IPv4';

  @override
  String get ipv4InputLabel => 'Dirección IPv4 en CIDR';

  @override
  String get ipv4InputHint => 'Ejemplo: 192.168.1.34/24';

  @override
  String get ipv4ActionCalculate => 'Calcular';

  @override
  String get ipv4ActionClear => 'Limpiar';

  @override
  String get ipv4ResultCopy => 'Copiar resultado';

  @override
  String get ipv4ResultSave => 'Guardar resultado';

  @override
  String get ipv4ResultCopied => 'Resultado copiado al portapapeles.';

  @override
  String get ipv4ResultExportUnsupported =>
      'La exportación de archivos no está disponible en esta plataforma.';

  @override
  String get ipv4ResultExportError => 'No se puede guardar el resultado.';

  @override
  String ipv4ResultExported(Object path) {
    return 'Resultado guardado en: $path';
  }

  @override
  String get ipv4ErrorEmptyCidr => 'Introduce una dirección IPv4 en CIDR.';

  @override
  String get ipv4ErrorInvalidCidr => 'Formato CIDR IPv4 inválido.';

  @override
  String get ipv4ErrorGeneric => 'No se puede procesar este CIDR IPv4.';

  @override
  String get ipv4InfoPrefix => 'Prefijo';

  @override
  String get ipv4InfoClass => 'Clase';

  @override
  String get ipv4InfoScope => 'Ámbito';

  @override
  String get ipv4InfoMask => 'Máscara de subred';

  @override
  String get ipv4InfoWildcard => 'Máscara wildcard';

  @override
  String get ipv4InfoNetwork => 'Dirección de red';

  @override
  String get ipv4InfoBroadcast => 'Dirección de broadcast';

  @override
  String get ipv4InfoFirstHost => 'Primer host útil';

  @override
  String get ipv4InfoLastHost => 'Último host útil';

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
  String get ipv4ScopePublic => 'Pública';

  @override
  String get ipv4ScopeLoopback => 'Loopback';

  @override
  String get ipv4ScopeLinkLocal => 'Link-local';

  @override
  String get ipv4ScopeMulticast => 'Multicast';

  @override
  String get ipv4ScopeReserved => 'Reservada/Experimental';

  @override
  String get ipv4SupernetTitle => 'Superred IPv4';

  @override
  String get ipv4SupernetInputLabel => 'Dirección IPv4 en CIDR';

  @override
  String get ipv4SupernetInputHint => 'Ejemplo: 192.168.1.0/24';

  @override
  String get ipv4SupernetActionAdd => 'Agregar';

  @override
  String get ipv4SupernetActionCalculate => 'Calcular superred';

  @override
  String get ipv4SupernetActionReset => 'Reiniciar';

  @override
  String get ipv4SupernetAddressesTitle => 'Direcciones';

  @override
  String get ipv4SupernetResultTitle => 'Resultado de superred';

  @override
  String get ipv4SupernetResultValue => 'Superred de cobertura';

  @override
  String get ipv4SupernetRelationsTitle => 'Relaciones entre direcciones';

  @override
  String get ipv4SupernetContiguousYes =>
      'Todas las direcciones son contiguas.';

  @override
  String get ipv4SupernetContiguousNo =>
      'No todas las direcciones son contiguas.';

  @override
  String get ipv4SupernetErrorEmptyAddress =>
      'Introduce una dirección IPv4 en CIDR.';

  @override
  String get ipv4SupernetErrorInvalidCidr => 'Formato CIDR IPv4 inválido.';

  @override
  String get ipv4SupernetErrorNeedTwo =>
      'Agrega al menos dos direcciones IPv4.';

  @override
  String get ipv4SupernetErrorGeneric =>
      'No se puede calcular la superred para esta lista.';

  @override
  String ipv4SupernetDuplicateMessage(Object address, int count) {
    return 'Duplicado eliminado: $address ($count entradas)';
  }

  @override
  String get relationEqual => 'iguales';

  @override
  String get relationOutside => 'separadas';

  @override
  String get relationContiguous => 'contiguas';

  @override
  String get relationAInsideB => 'dentro de';

  @override
  String get relationBInsideA => 'B dentro de A';

  @override
  String get relationOverlap => 'solapamiento';

  @override
  String get relationIntersecting => 'intersección';

  @override
  String relationUnknown(Object code) {
    return 'relación desconocida ($code)';
  }

  @override
  String get menuIpv6Address => 'Dirección IPv6';

  @override
  String get menuIpv6Supernet => 'Supernet IPv6';

  @override
  String get ipv6Title => 'Dirección IPv6';

  @override
  String get ipv6InputLabel => 'Dirección IPv6 en CIDR';

  @override
  String get ipv6InputHint => 'Ejemplo: 2001:db8::1/64';

  @override
  String get ipv6ActionCalculate => 'Calcular';

  @override
  String get ipv6ActionClear => 'Limpiar';

  @override
  String get ipv6ResultCopy => 'Copiar resultado';

  @override
  String get ipv6ResultSave => 'Guardar resultado';

  @override
  String get ipv6ResultCopied => 'Resultado copiado al portapapeles.';

  @override
  String get ipv6ResultExportUnsupported =>
      'La exportación de archivos no está disponible en esta plataforma.';

  @override
  String get ipv6ResultExportError => 'Imposible guardar el resultado.';

  @override
  String ipv6ResultExported(Object path) {
    return 'Resultado guardado en: $path';
  }

  @override
  String get ipv6ErrorEmptyAddress => 'Dirección IPv6 vacía.';

  @override
  String get ipv6ErrorGeneric => 'Imposible procesar esta dirección IPv6.';

  @override
  String get ipv6InfoPrefix => 'Prefijo';

  @override
  String get ipv6InfoType => 'Tipo';

  @override
  String get ipv6InfoExpandedAddress => 'Dirección expandida';

  @override
  String get ipv6InfoSimplifiedAddress => 'Dirección simplificada';

  @override
  String get ipv6InfoNetwork => 'Dirección de red';

  @override
  String get ipv6InfoSimplifiedNetwork => 'Dirección de red simplificada';

  @override
  String get ipv6InfoTotalAddresses => 'Total de direcciones';

  @override
  String get ipv6InfoNetworkBinary => 'Red (binario)';

  @override
  String get ipv6TypeUnknown => 'Dirección desconocida.';

  @override
  String get ipv6SupernetTitle => 'Supernet IPv6';

  @override
  String get ipv6SupernetInputLabel => 'Dirección IPv6 en CIDR';

  @override
  String get ipv6SupernetInputHint => 'Ejemplo: 2001:db8::/64';

  @override
  String get ipv6SupernetActionAdd => 'Agregar';

  @override
  String get ipv6SupernetActionCalculate => 'Calcular supernet';

  @override
  String get ipv6SupernetActionReset => 'Reiniciar';

  @override
  String get ipv6SupernetAddressesTitle => 'Direcciones';

  @override
  String get ipv6SupernetResultTitle => 'Resultado del supernet';

  @override
  String get ipv6SupernetResultValue => 'Supernet couvrant';

  @override
  String get ipv6SupernetRelationsTitle => 'Relaciones entre direcciones';

  @override
  String get ipv6SupernetContiguousYes =>
      'Todas las direcciones son contiguas.';

  @override
  String get ipv6SupernetContiguousNo =>
      'Las direcciones no son todas contiguas.';

  @override
  String get ipv6SupernetErrorEmptyAddress =>
      'Por favor, ingrese una dirección IPv6.';

  @override
  String get ipv6SupernetErrorInvalidCidr => 'Formato CIDR IPv6 inválido.';

  @override
  String get ipv6SupernetErrorNeedTwo =>
      'Por favor, agregue al menos dos direcciones IPv6.';

  @override
  String get ipv6SupernetErrorGeneric =>
      'Imposible calcular el supernet para esta lista.';

  @override
  String ipv6SupernetDuplicateMessage(Object address, int count) {
    return 'Duplicado eliminado: $address ($count entradas)';
  }

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
  String get ipv6ErrorInvalidSuffix => 'Sufijo IPv6 inválido.';

  @override
  String get ipv6ErrorInvalidAddress => 'Dirección IPv6 inválida.';

  @override
  String get ipv6ErrorInvalidMacFormat => 'Formato de dirección MAC inválido.';
}
