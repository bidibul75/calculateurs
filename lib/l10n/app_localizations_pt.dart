// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Calculadora';

  @override
  String get basicHistoryCopy => 'Copiar histórico';

  @override
  String get basicHistorySave => 'Salvar histórico';

  @override
  String get basicHistoryClear => 'Limpar histórico';

  @override
  String get basicHistoryEmpty => 'A história está vazia.';

  @override
  String get basicHistoryCopied =>
      'Histórico copiado para a área de transferência.';

  @override
  String get basicHistoryExportUnsupported =>
      'A exportação de arquivos não está disponível nesta plataforma.';

  @override
  String get basicHistoryExportError => 'Não foi possível salvar o histórico.';

  @override
  String basicHistoryExported(Object path) {
    return 'Histórico salvo em: $path';
  }

  @override
  String get menuThemes => 'Temas';

  @override
  String get menuWhoAmI => 'Quem sou eu';

  @override
  String get menuDonate => 'Doar';

  @override
  String get close => 'Fechar';

  @override
  String get whoAmITitle => 'Quem sou eu';

  @override
  String get whoAmIBody =>
      'Meu nome é Walter Bianchi, sou um desenvolvedor de software apaixonado por criar aplicativos úteis e bonitos.\n\nEu construí esta calculadora para fornecer uma ferramenta simples, mas poderosa para cálculos.\n\nEspero que você ache útil!\n\nEstou à procura de emprego, por isso se gostar deste projeto (escrito em Flutter) e quiser trabalhar comigo, não hesite em contactar-me!';

  @override
  String get whoAmILinkedIn => 'Perfil do LinkedIn';

  @override
  String get whoAmIDonateCta => 'Doações são bem-vindas!';

  @override
  String get donateTitle => 'Doar';

  @override
  String get donateIntro =>
      'Obrigado por usar esta calculadora!\n\nSe você acha este aplicativo útil e deseja apoiar seu desenvolvimento, você pode fazer uma doação:';

  @override
  String get donateViaPaypal => 'Doe via PayPal';

  @override
  String get donateOutro => 'Cada contribuição ajuda a melhorar este app!';

  @override
  String get themeSettingsTitle => 'Configurações de tema';

  @override
  String get themeBackgroundColor => 'Cor de fundo:';

  @override
  String get themeBackgroundNeutral => 'Cinza suave';

  @override
  String get themeBackgroundWallpaper => 'Papel de parede';

  @override
  String get themeBackgroundMetal => 'Metal escovado';

  @override
  String get themeDisplayTextColor => 'Exibir cor do texto:';

  @override
  String get themeButtonGroupsColor => 'Cor dos grupos de botões:';

  @override
  String get themeButtonTextColor => 'Cor do texto do botão:';

  @override
  String get colorWhite => 'Branco';

  @override
  String get colorDark => 'Escuro';

  @override
  String get colorLightBlue => 'Azul claro';

  @override
  String get colorLightAmber => 'Âmbar claro';

  @override
  String get colorBlack => 'Preto';

  @override
  String get colorBlue => 'Azul';

  @override
  String get colorGreen => 'Verde';

  @override
  String get colorDarkGrey => 'Cinza Escuro';

  @override
  String get colorPurple => 'Roxo';

  @override
  String get colorTeal => 'Cerceta';

  @override
  String get colorLightGrey => 'Cinza Claro';

  @override
  String get colorYellow => 'Amarelo';

  @override
  String get photoCredit => 'Foto: Bady Abbas no Unsplash';

  @override
  String get menuSectionHealth => 'Saúde';

  @override
  String get menuSectionConversions => 'Ferramentas IP';

  @override
  String get menuSectionFinance => 'Financiar';

  @override
  String get menuSectionRealEstate => 'Imobiliária';

  @override
  String get bmiTitle => 'Calculadora de IMC';

  @override
  String get menuBmi => 'Calculadora de IMC';

  @override
  String get bmiPromptHeight => 'Altura (m):';

  @override
  String get bmiPromptWeight => 'Peso (kg):';

  @override
  String get bmiPromptResult => 'IMC:';

  @override
  String get bmiActionEnter => 'Digitar';

  @override
  String get bmiErrorInvalidHeight => 'Erro: altura incorreta';

  @override
  String get bmiErrorInvalidWeight => 'Erro: peso incorreto';

  @override
  String get bmiErrorGeneric => 'Erro';

  @override
  String get bmiCategoryUnderweight => 'Abaixo do peso';

  @override
  String get bmiCategoryNormal => 'Peso normal';

  @override
  String get bmiCategoryOverweight => 'Sobrepeso';

  @override
  String get bmiCategoryObese => 'Obeso';

  @override
  String get menuIpv4Address => 'Endereço IPv4';

  @override
  String get menuIpv4Supernet => 'Super-rede IPv4';

  @override
  String get ipv4Title => 'Endereço IPv4';

  @override
  String get ipv4InputLabel => 'Endereço CIDR IPv4';

  @override
  String get ipv4InputHint => 'Exemplo: 192.168.1.34/24';

  @override
  String get ipv4ActionCalculate => 'Calcular';

  @override
  String get ipv4ActionClear => 'Claro';

  @override
  String get ipv4ResultCopy => 'Copiar resultado';

  @override
  String get ipv4ResultSave => 'Salvar resultado';

  @override
  String get ipv4ResultCopied =>
      'Resultado copiado para a área de transferência.';

  @override
  String get ipv4ResultExportUnsupported =>
      'A exportação de arquivos não está disponível nesta plataforma.';

  @override
  String get ipv4ResultExportError => 'Não foi possível salvar o resultado.';

  @override
  String ipv4ResultExported(Object path) {
    return 'Resultado salvo em: $path';
  }

  @override
  String get ipv4ErrorEmptyCidr => 'Insira um endereço CIDR IPv4.';

  @override
  String get ipv4ErrorInvalidCidr => 'Formato CIDR IPv4 inválido.';

  @override
  String get ipv4ErrorGeneric => 'Não é possível processar este CIDR IPv4.';

  @override
  String get ipv4InfoPrefix => 'Prefixo';

  @override
  String get ipv4InfoClass => 'Aula';

  @override
  String get ipv4InfoScope => 'Escopo';

  @override
  String get ipv4InfoMask => 'Máscara de sub-rede';

  @override
  String get ipv4InfoWildcard => 'Máscara curinga';

  @override
  String get ipv4InfoNetwork => 'Endereço de rede';

  @override
  String get ipv4InfoBroadcast => 'Endereço de transmissão';

  @override
  String get ipv4InfoFirstHost => 'Primeiro host utilizável';

  @override
  String get ipv4InfoLastHost => 'Último host utilizável';

  @override
  String get ipv4InfoTotalAddresses => 'Total de endereços';

  @override
  String get ipv4InfoUsableHosts => 'Hosts utilizáveis';

  @override
  String get ipv4InfoNetworkBinary => 'Rede (binário)';

  @override
  String get ipv4InfoBroadcastBinary => 'Transmissão (binário)';

  @override
  String get ipv4ScopePrivate => 'Privado';

  @override
  String get ipv4ScopePublic => 'Público';

  @override
  String get ipv4ScopeLoopback => 'La?o de retorno';

  @override
  String get ipv4ScopeLinkLocal => 'Link local';

  @override
  String get ipv4ScopeMulticast => 'Multitransmissão';

  @override
  String get ipv4ScopeReserved => 'Reservado/Experimental';

  @override
  String get ipv4SupernetTitle => 'Super-rede IPv4';

  @override
  String get ipv4SupernetInputLabel => 'Endereço CIDR IPv4';

  @override
  String get ipv4SupernetInputHint => 'Exemplo: 192.168.1.0/24';

  @override
  String get ipv4SupernetActionAdd => 'Adicionar';

  @override
  String get ipv4SupernetActionCalculate => 'Calcular super-rede';

  @override
  String get ipv4SupernetActionReset => 'Reiniciar';

  @override
  String get ipv4SupernetAddressesTitle => 'Endereços';

  @override
  String get ipv4SupernetResultTitle => 'Resultado da super-rede';

  @override
  String get ipv4SupernetResultValue => 'Cobrindo a super-rede';

  @override
  String get ipv4SupernetRelationsTitle => 'Relações de endereço';

  @override
  String get ipv4SupernetContiguousYes => 'Todos os endereços são contíguos.';

  @override
  String get ipv4SupernetContiguousNo =>
      'Os endereços não são todos contíguos.';

  @override
  String get ipv4SupernetErrorEmptyAddress => 'Insira um endereço CIDR IPv4.';

  @override
  String get ipv4SupernetErrorInvalidCidr => 'Formato CIDR IPv4 inválido.';

  @override
  String get ipv4SupernetErrorNeedTwo =>
      'Adicione pelo menos dois endereços IPv4.';

  @override
  String get ipv4SupernetErrorGeneric =>
      'Não é possível calcular a super-rede para esta lista.';

  @override
  String ipv4SupernetDuplicateMessage(Object address, int count) {
    return 'Duplicado removido: $address (entradas $count)';
  }

  @override
  String get relationEqual => 'igual';

  @override
  String get relationOutside => 'fora';

  @override
  String get relationContiguous => 'contíguo';

  @override
  String get relationAInsideB => 'dentro';

  @override
  String get relationBInsideA => 'B dentro de A';

  @override
  String get relationOverlap => 'sobreposição';

  @override
  String get relationIntersecting => 'cruzando';

  @override
  String relationUnknown(Object code) {
    return 'desconhecido ($code)';
  }

  @override
  String get menuIpv6Address => 'Endereço IPv6';

  @override
  String get menuIpv6Supernet => 'Super-rede IPv6';

  @override
  String get ipv6Title => 'Endereço IPv6';

  @override
  String get ipv6InputLabel => 'Endereço CIDR IPv6';

  @override
  String get ipv6InputHint => 'Exemplo: 2001:db8::1/64';

  @override
  String get ipv6ActionCalculate => 'Calcular';

  @override
  String get ipv6ActionClear => 'Claro';

  @override
  String get ipv6ResultCopy => 'Copiar resultado';

  @override
  String get ipv6ResultSave => 'Salvar resultado';

  @override
  String get ipv6ResultCopied =>
      'Resultado copiado para a área de transferência.';

  @override
  String get ipv6ResultExportUnsupported =>
      'A exportação de arquivos não está disponível nesta plataforma.';

  @override
  String get ipv6ResultExportError => 'Não foi possível salvar o resultado.';

  @override
  String ipv6ResultExported(Object path) {
    return 'Resultado salvo em: $path';
  }

  @override
  String get ipv6ErrorEmptyAddress => 'Endereço IPv6 vazio.';

  @override
  String get ipv6ErrorGeneric => 'Não é possível processar este endereço IPv6.';

  @override
  String get ipv6InfoPrefix => 'Prefixo';

  @override
  String get ipv6InfoType => 'Tipo';

  @override
  String get ipv6InfoExpandedAddress => 'Endereço expandido';

  @override
  String get ipv6InfoSimplifiedAddress => 'Endereço simplificado';

  @override
  String get ipv6InfoNetwork => 'Endereço de rede';

  @override
  String get ipv6InfoSimplifiedNetwork => 'Endereço de rede simplificado';

  @override
  String get ipv6InfoTotalAddresses => 'Total de endereços';

  @override
  String get ipv6InfoNetworkBinary => 'Rede (binário)';

  @override
  String get ipv6TypeUnknown => 'Endereço desconhecido.';

  @override
  String get ipv6SupernetTitle => 'Super-rede IPv6';

  @override
  String get ipv6SupernetInputLabel => 'Endereço CIDR IPv6';

  @override
  String get ipv6SupernetInputHint => 'Exemplo: 2001:db8::/64';

  @override
  String get ipv6SupernetActionAdd => 'Adicionar';

  @override
  String get ipv6SupernetActionCalculate => 'Calcular super-rede';

  @override
  String get ipv6SupernetActionReset => 'Reiniciar';

  @override
  String get ipv6SupernetAddressesTitle => 'Endereços';

  @override
  String get ipv6SupernetResultTitle => 'Resultado da super-rede';

  @override
  String get ipv6SupernetResultValue => 'Cobrindo a super-rede';

  @override
  String get ipv6SupernetRelationsTitle => 'Relações de endereço';

  @override
  String get ipv6SupernetContiguousYes => 'Todos os endereços são contíguos.';

  @override
  String get ipv6SupernetContiguousNo =>
      'Os endereços não são todos contíguos.';

  @override
  String get ipv6SupernetErrorEmptyAddress => 'Insira um endereço IPv6.';

  @override
  String get ipv6SupernetErrorInvalidCidr => 'Formato CIDR IPv6 inválido.';

  @override
  String get ipv6SupernetErrorNeedTwo =>
      'Adicione pelo menos dois endereços IPv6.';

  @override
  String get ipv6SupernetErrorGeneric =>
      'Não é possível calcular a super-rede para esta lista.';

  @override
  String ipv6SupernetDuplicateMessage(Object address, int count) {
    return 'Duplicado removido: $address (entradas $count)';
  }

  @override
  String get ipv6TypeLoopback => 'Endereço de loopback.';

  @override
  String get ipv6TypeLinkLocal =>
      'Endereço Link-Local (comunicação no mesmo switch, não roteável).';

  @override
  String get ipv6TypeGlobalUnicast =>
      'Endereço Unicast global (endereço público roteável na Internet).';

  @override
  String get ipv6TypeUniqueLocal =>
      'Endereço local exclusivo (equivalente a endereços privados IPv4).';

  @override
  String get ipv6TypeMulticast => 'Endereço multicast.';

  @override
  String get ipv6TypeUnspecified => 'Endereço não especificado.';

  @override
  String get ipv6ErrorInvalidCidrFormat => 'Formato CIDR IPv6 inválido.';

  @override
  String get ipv6ErrorInvalidSuffix => 'Sufixo IPv6 inválido.';

  @override
  String get ipv6ErrorInvalidAddress => 'Endereço IPv6 inválido.';

  @override
  String get ipv6ErrorInvalidMacFormat => 'Formato de endereço MAC inválido.';
}
