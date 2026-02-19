import 'package:decimal/decimal.dart';
import 'package:intl/intl.dart';
import 'package:intl/number_symbols.dart';
import 'package:intl/number_symbols_data.dart';

extension DecimalFormatting on Decimal {
  String toPreciseFormattedString() {
    // 1. Récupérer la locale (ex: "fr_FR" ou "en_US")
    final String locale = Intl.getCurrentLocale();
    final NumberSymbols symbols = numberFormatSymbols[locale]
        ?? numberFormatSymbols['en_US']!;

    // 2. Convertir le Decimal en String brut (ex: "1234.5000")
    String val = toString();

    // 3. Nettoyer le ".0" si c'est un entier (ex: "10.0" -> "10")
    if (val.contains('.') && double.tryParse(val) != null) {
      // On vérifie si après la virgule c'est que des zéros
      // Decimal gère ça bien, mais une sécurité ne fait pas de mal
      if (RegExp(r'\.0+$').hasMatch(val)) {
        val = val.split('.')[0];
      }
    }

    // 4. Séparer partie entière et partie décimale
    List<String> parts = val.split('.');
    String integerPart = parts[0];
    String? decimalPart = parts.length > 1 ? parts[1] : null;

    // 5. Appliquer le séparateur de milliers sur la partie entière
    // Regex magique pour mettre des espaces tous les 3 chiffres
    final regex = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    integerPart = integerPart.replaceAllMapped(regex, (Match m) {
      return '${m[1]}${symbols.GROUP_SEP}';
    });

    // 6. Recombiner avec le séparateur décimal local (virgule ou point)
    if (decimalPart != null) {
      return '$integerPart${symbols.DECIMAL_SEP}$decimalPart';
    }

    return integerPart;
  }
}