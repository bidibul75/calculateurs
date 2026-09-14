// lib/utils/extensions/list_extensions.dart

import 'package:flutter/foundation.dart';

/// Utility extensions for the List class
extension ListExtensions<E> on List<E> {
  /// Returns the index of the first occurrence of a sublist
  /// or -1 if the sublist isn't contained in the list
  int indexOfSublist(List<E> short) {
    final int bigLen = length;
    final int shortLen = short.length;
    if (shortLen == 0 || shortLen > bigLen) return -1;

    for (int i = 0; i <= bigLen - shortLen; i++) {
      if (listEquals(sublist(i, i + shortLen), short)) {
        return i;
      }
    }
    return -1;
  }
}
