import 'package:calculators/l10n/app_localizations.dart';

class Relation {
  final String addressA;
  final String relationAB;
  final String addressB;

  static Relation implementationObjetRelation(String addressA, String relationAB, String addressB) {
    if (relationAB == "B_inside_A") {
      return Relation(addressB, "A_inside_B", addressA);
    } else {
      return Relation(addressA, relationAB, addressB);
    }
  }

  static String relationLabel(AppLocalizations l10n, String relation) {
    switch (relation) {
      case 'equal':
        return l10n.relationEqual;
      case 'outside':
        return l10n.relationOutside;
      case 'contiguous':
        return l10n.relationContiguous;
      case 'A_inside_B':
        return l10n.relationAInsideB;
      case 'B_inside_A':
        return l10n.relationBInsideA;
      case 'overlap':
      case 'overlaps':
        return l10n.relationOverlap;
      case 'intersecting':
        return l10n.relationIntersecting;
      default:
        return l10n.relationUnknown(relation);
    }
  }

  static bool isAGoodRelation(String relation) => relation == 'contiguous';

  Relation(this.addressA, this.relationAB, this.addressB);
}
