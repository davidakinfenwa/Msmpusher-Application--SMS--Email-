class ListUtil {
  static int compareLists<T extends Comparable<T>>(List<T> a, List<T> b) {
    var aLength = a.length;
    var bLength = b.length;
    var minLength = aLength < bLength ? aLength : bLength;
    for (var i = 0; i < minLength; i++) {
      var result = a[i].compareTo(b[i]);
      if (result != 0) return result;
    }
    return aLength - bLength;
  }

  static int compareListsBy<T>(List<T> a, List<T> b, int Function(T a, T b) compare) {
    var aLength = a.length;
    var bLength = b.length;
    var minLength = aLength < bLength ? aLength : bLength;
    for (var i = 0; i < minLength; i++) {
      var result = compare(a[i], b[i]);
      if (result != 0) return result;
    }
    return aLength - bLength;
  }
}

extension CompareListExtension<T> on List<T> {
  int compare(List<T> other, int Function(T a, T b) compare) =>
      ListUtil.compareListsBy<T>(this, other, compare);
}

extension CompareListComparableExtension<T extends Comparable<T>> on List<T> {
  int compare(List<T> other, [int Function(T a, T b)? compare]) =>
      ListUtil.compareListsBy<T>(
          this, other, compare ?? (a, b) => a.compareTo(b));
}
