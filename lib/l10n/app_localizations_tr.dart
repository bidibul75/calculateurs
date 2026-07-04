// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Hesap Makinesi';

  @override
  String get basicHistoryCopy => 'Geçmişi kopyala';

  @override
  String get basicHistorySave => 'Geçmişi kaydet';

  @override
  String get basicHistoryClear => 'Geçmişi temizle';

  @override
  String get basicHistoryEmpty => 'Tarih boş.';

  @override
  String get basicHistoryCopied => 'Geçmiş panoya kopyalandı.';

  @override
  String get basicHistoryExportUnsupported =>
      'Dosya dışa aktarımı bu platformda mevcut değildir.';

  @override
  String get basicHistoryExportError => 'Geçmiş kaydedilemiyor.';

  @override
  String basicHistoryExported(Object path) {
    return 'Geçmiş şuraya kaydedildi: $path';
  }

  @override
  String get menuThemes => 'Temalar';

  @override
  String get menuWhoAmI => 'ben kimim';

  @override
  String get menuDonate => 'Bağış yapmak';

  @override
  String get close => 'Kapalı';

  @override
  String get whoAmITitle => 'ben kimim';

  @override
  String get whoAmIBody =>
      'Adım Walter Bianchi, kullanışlı ve güzel uygulamalar yaratma tutkusuna sahip bir yazılım geliştiricisiyim.\n\nBu hesap makinesini hesaplamalar için basit ama güçlü bir araç sağlamak üzere oluşturdum.\n\nUmarım faydalı bulursunuz!\n\nİş arıyorum, bu yüzden (Flutter\'da yazılmış) bu projeyi beğendiyseniz ve benimle çalışmak istiyorsanız benimle iletişime geçmekten çekinmeyin!';

  @override
  String get whoAmILinkedIn => 'LinkedIn Profili';

  @override
  String get whoAmIDonateCta => 'Bağışlar hoş karşılanır!';

  @override
  String get donateTitle => 'Bağış yapmak';

  @override
  String get donateIntro =>
      'Bu hesap makinesini kullandığınız için teşekkür ederiz!\n\nBu uygulamayı yararlı buluyorsanız ve geliştirilmesine destek olmak istiyorsanız bağışta bulunabilirsiniz:';

  @override
  String get donateViaPaypal => 'PayPal aracılığıyla bağış yapın';

  @override
  String get donateOutro =>
      'Her katkı bu uygulamayı geliştirmeye yardımcı olur!';

  @override
  String get themeSettingsTitle => 'Tema Ayarları';

  @override
  String get themeBackgroundColor => 'Arka Plan Rengi:';

  @override
  String get themeBackgroundNeutral => 'Yumuşak gri';

  @override
  String get themeBackgroundWallpaper => 'Duvar kağıdı';

  @override
  String get themeBackgroundMetal => 'Fırçalanmış metal';

  @override
  String get themeDisplayTextColor => 'Metin Rengini Görüntüle:';

  @override
  String get themeButtonGroupsColor => 'Düğme Grupları Rengi:';

  @override
  String get themeButtonTextColor => 'Düğme Metni Rengi:';

  @override
  String get colorWhite => 'Beyaz';

  @override
  String get colorDark => 'Karanlık';

  @override
  String get colorLightBlue => 'Açık Mavi';

  @override
  String get colorLightAmber => 'Açık Kehribar';

  @override
  String get colorBlack => 'Siyah';

  @override
  String get colorBlue => 'Mavi';

  @override
  String get colorGreen => 'Yeşil';

  @override
  String get colorDarkGrey => 'Koyu Gri';

  @override
  String get colorPurple => 'Mor';

  @override
  String get colorTeal => 'turkuaz';

  @override
  String get colorLightGrey => 'Açık Gri';

  @override
  String get colorYellow => 'Sarı';

  @override
  String get photoCredit => 'Fotoğraf: Unsplash\'ta Bady Abbas';

  @override
  String get menuSectionHealth => 'Sağlık';

  @override
  String get menuSectionConversions => 'Dönüşümler';

  @override
  String get menuSectionIpTools => 'IP Araçları';

  @override
  String get menuSectionFinance => 'Finans';

  @override
  String get menuSectionRealEstate => 'Gayrimenkul';

  @override
  String get bmiTitle => 'BMI Hesaplayıcı';

  @override
  String get menuBmi => 'BMI Hesaplayıcı';

  @override
  String get bmiPromptHeight => 'Yükseklik (m):';

  @override
  String get bmiPromptWeight => 'Ağırlık (kg):';

  @override
  String get bmiPromptResult => 'V?cut kitle indeksi:';

  @override
  String get bmiActionEnter => 'Girmek';

  @override
  String get bmiErrorInvalidHeight => 'Hata: yanlış yükseklik';

  @override
  String get bmiErrorInvalidWeight => 'Hata: yanlış ağırlık';

  @override
  String get bmiErrorGeneric => 'Hata';

  @override
  String get bmiCategoryUnderweight => 'Düşük kilolu';

  @override
  String get bmiCategoryNormal => 'Normal ağırlık';

  @override
  String get bmiCategoryOverweight => 'Fazla kilolu';

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
  String get menuDistance => 'Mesafe dönüştürücü';

  @override
  String get distanceTitle => 'Mesafe dönüştürücü';

  @override
  String get distanceLabelMetric => 'Metrik';

  @override
  String get distanceLabelImperial => 'İmparatorluk';

  @override
  String get distanceLabelNautical => 'Deniz mili';

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
  String get menuIpv4Address => 'IPv4 Adresi';

  @override
  String get menuIpv4Supernet => 'IPv4 Süpernet';

  @override
  String get ipv4Title => 'IPv4 Adresi';

  @override
  String get ipv4InputLabel => 'IPv4 CIDR adresi';

  @override
  String get ipv4InputHint => 'Örnek: 192.168.1.34/24';

  @override
  String get ipv4ActionCalculate => 'Hesaplamak';

  @override
  String get ipv4ActionClear => 'Temizlemek';

  @override
  String get ipv4ResultCopy => 'Sonucu kopyala';

  @override
  String get ipv4ResultSave => 'Sonucu kaydet';

  @override
  String get ipv4ResultCopied => 'Sonuç panoya kopyalandı.';

  @override
  String get ipv4ResultExportUnsupported =>
      'Dosya dışa aktarımı bu platformda mevcut değildir.';

  @override
  String get ipv4ResultExportError => 'Sonuç kaydedilemiyor.';

  @override
  String ipv4ResultExported(Object path) {
    return 'Sonuç şuraya kaydedildi: $path';
  }

  @override
  String get ipv4ErrorEmptyCidr => 'Lütfen bir IPv4 CIDR adresi girin.';

  @override
  String get ipv4ErrorInvalidCidr => 'Geçersiz IPv4 CIDR biçimi.';

  @override
  String get ipv4ErrorGeneric => 'Bu IPv4 CIDR işlenemiyor.';

  @override
  String get ipv4InfoPrefix => 'Önek';

  @override
  String get ipv4InfoClass => 'Sınıf';

  @override
  String get ipv4InfoScope => 'Kapsam';

  @override
  String get ipv4InfoMask => 'Alt ağ maskesi';

  @override
  String get ipv4InfoWildcard => 'Joker karakter maskesi';

  @override
  String get ipv4InfoNetwork => 'Ağ adresi';

  @override
  String get ipv4InfoBroadcast => 'Yayın adresi';

  @override
  String get ipv4InfoFirstHost => 'Kullanılabilir ilk ana bilgisayar';

  @override
  String get ipv4InfoLastHost => 'Kullanılabilir son ana bilgisayar';

  @override
  String get ipv4InfoTotalAddresses => 'Toplam adresler';

  @override
  String get ipv4InfoUsableHosts => 'Kullanılabilir ana bilgisayarlar';

  @override
  String get ipv4InfoNetworkBinary => 'Ağ (ikili)';

  @override
  String get ipv4InfoBroadcastBinary => 'Yayın (ikili)';

  @override
  String get ipv4ScopePrivate => 'Özel';

  @override
  String get ipv4ScopePublic => 'Halk';

  @override
  String get ipv4ScopeLoopback => 'Geri döngü';

  @override
  String get ipv4ScopeLinkLocal => 'Yerel bağlantı';

  @override
  String get ipv4ScopeMulticast => 'Çok noktaya yayın';

  @override
  String get ipv4ScopeReserved => 'Rezerve/Deneysel';

  @override
  String get ipv4SupernetTitle => 'IPv4 Süpernet';

  @override
  String get ipv4SupernetInputLabel => 'IPv4 CIDR adresi';

  @override
  String get ipv4SupernetInputHint => 'Örnek: 192.168.1.0/24';

  @override
  String get ipv4SupernetActionAdd => 'Eklemek';

  @override
  String get ipv4SupernetActionCalculate => 'Süper ağı hesapla';

  @override
  String get ipv4SupernetActionReset => 'Sıfırla';

  @override
  String get ipv4SupernetAddressesTitle => 'Adresler';

  @override
  String get ipv4SupernetResultTitle => 'Süpernet sonucu';

  @override
  String get ipv4SupernetResultValue => 'Süper ağı kapsayan';

  @override
  String get ipv4SupernetRelationsTitle => 'Adres ilişkileri';

  @override
  String get ipv4SupernetContiguousYes => 'Tüm adresler bitişiktir.';

  @override
  String get ipv4SupernetContiguousNo => 'Adreslerin hepsi bitişik değildir.';

  @override
  String get ipv4SupernetErrorEmptyAddress =>
      'Lütfen bir IPv4 CIDR adresi girin.';

  @override
  String get ipv4SupernetErrorInvalidCidr => 'Geçersiz IPv4 CIDR biçimi.';

  @override
  String get ipv4SupernetErrorNeedTwo =>
      'Lütfen en az iki IPv4 adresi ekleyin.';

  @override
  String get ipv4SupernetErrorGeneric =>
      'Bu liste için süper ağ hesaplanamıyor.';

  @override
  String ipv4SupernetDuplicateMessage(Object address, int count) {
    return 'Yinelenen kopya kaldırıldı: $address ($count girişleri)';
  }

  @override
  String get relationEqual => 'eşit';

  @override
  String get relationOutside => 'dıştan';

  @override
  String get relationContiguous => 'bitişik';

  @override
  String get relationAInsideB => 'içeri';

  @override
  String get relationBInsideA => 'A\'nın içindeki B';

  @override
  String get relationOverlap => 'örtüşmek';

  @override
  String get relationIntersecting => 'kesişen';

  @override
  String relationUnknown(Object code) {
    return 'bilinmiyor ($code)';
  }

  @override
  String get menuIpv6Address => 'IPv6 Adresi';

  @override
  String get menuIpv6Supernet => 'IPv6 Süpernet';

  @override
  String get ipv6Title => 'IPv6 Adresi';

  @override
  String get ipv6InputLabel => 'IPv6 CIDR adresi';

  @override
  String get ipv6InputHint => 'Örnek: 2001:db8::1/64';

  @override
  String get ipv6ActionCalculate => 'Hesaplamak';

  @override
  String get ipv6ActionClear => 'Temizlemek';

  @override
  String get ipv6ResultCopy => 'Sonucu kopyala';

  @override
  String get ipv6ResultSave => 'Sonucu kaydet';

  @override
  String get ipv6ResultCopied => 'Sonuç panoya kopyalandı.';

  @override
  String get ipv6ResultExportUnsupported =>
      'Dosya dışa aktarımı bu platformda mevcut değildir.';

  @override
  String get ipv6ResultExportError => 'Sonuç kaydedilemiyor.';

  @override
  String ipv6ResultExported(Object path) {
    return 'Sonuç şuraya kaydedildi: $path';
  }

  @override
  String get ipv6ErrorEmptyAddress => 'Boş IPv6 adresi.';

  @override
  String get ipv6ErrorGeneric => 'Bu IPv6 adresi işlenemiyor.';

  @override
  String get ipv6InfoPrefix => 'Önek';

  @override
  String get ipv6InfoType => 'Tip';

  @override
  String get ipv6InfoExpandedAddress => 'Genişletilmiş adres';

  @override
  String get ipv6InfoSimplifiedAddress => 'Basitleştirilmiş adres';

  @override
  String get ipv6InfoNetwork => 'Ağ adresi';

  @override
  String get ipv6InfoSimplifiedNetwork => 'Basitleştirilmiş ağ adresi';

  @override
  String get ipv6InfoTotalAddresses => 'Toplam adresler';

  @override
  String get ipv6InfoNetworkBinary => 'Ağ (ikili)';

  @override
  String get ipv6TypeUnknown => 'Bilinmeyen adres.';

  @override
  String get ipv6SupernetTitle => 'IPv6 Süpernet';

  @override
  String get ipv6SupernetInputLabel => 'IPv6 CIDR adresi';

  @override
  String get ipv6SupernetInputHint => 'Örnek: 2001:db8::/64';

  @override
  String get ipv6SupernetActionAdd => 'Eklemek';

  @override
  String get ipv6SupernetActionCalculate => 'Süper ağı hesapla';

  @override
  String get ipv6SupernetActionReset => 'Sıfırla';

  @override
  String get ipv6SupernetAddressesTitle => 'Adresler';

  @override
  String get ipv6SupernetResultTitle => 'Süpernet sonucu';

  @override
  String get ipv6SupernetResultValue => 'Süper ağı kapsayan';

  @override
  String get ipv6SupernetRelationsTitle => 'Adres ilişkileri';

  @override
  String get ipv6SupernetContiguousYes => 'Tüm adresler bitişiktir.';

  @override
  String get ipv6SupernetContiguousNo => 'Adreslerin hepsi bitişik değildir.';

  @override
  String get ipv6SupernetErrorEmptyAddress => 'Lütfen bir IPv6 adresi girin.';

  @override
  String get ipv6SupernetErrorInvalidCidr => 'Geçersiz IPv6 CIDR biçimi.';

  @override
  String get ipv6SupernetErrorNeedTwo =>
      'Lütfen en az iki IPv6 adresi ekleyin.';

  @override
  String get ipv6SupernetErrorGeneric =>
      'Bu liste için süper ağ hesaplanamıyor.';

  @override
  String ipv6SupernetDuplicateMessage(Object address, int count) {
    return 'Yinelenen kopya kaldırıldı: $address ($count girişleri)';
  }

  @override
  String get ipv6TypeLoopback => 'Geri döngü adresi.';

  @override
  String get ipv6TypeLinkLocal =>
      'Bağlantı-Yerel adres (aynı anahtar üzerinde iletişim, yönlendirilemez).';

  @override
  String get ipv6TypeGlobalUnicast =>
      'Küresel Tek Noktaya Yayın adresi (İnternet üzerinde yönlendirilebilir genel adres).';

  @override
  String get ipv6TypeUniqueLocal =>
      'Benzersiz Yerel adres (IPv4 özel adreslerine eşdeğer).';

  @override
  String get ipv6TypeMulticast => 'Çok noktaya yayın adresi.';

  @override
  String get ipv6TypeUnspecified => 'Belirtilmemiş adres.';

  @override
  String get ipv6ErrorInvalidCidrFormat => 'Geçersiz IPv6 CIDR biçimi.';

  @override
  String get ipv6ErrorInvalidSuffix => 'Geçersiz IPv6 son eki.';

  @override
  String get ipv6ErrorInvalidAddress => 'Geçersiz IPv6 adresi.';

  @override
  String get ipv6ErrorInvalidMacFormat => 'Geçersiz MAC adresi biçimi.';
}
