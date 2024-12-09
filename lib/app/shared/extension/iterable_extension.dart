extension IterableExtension<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E) test) {
    for (final E element in this) {
      if (test(element)) return element;
    }
    return null;
  }

  E? lastWhereOrNull(bool Function(E element) test) {
    E? result;
    for (final E element in this) {
      if (test(element)) result = element;
    }
    return result;
  }

  int? indexWhereOrNull(bool Function(E) test) {
    int index = 0;
    for (final element in this) {
      if (test(element)) return index;
      index++;
    }
    return null;
  }
}
