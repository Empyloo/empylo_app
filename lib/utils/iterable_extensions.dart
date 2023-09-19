// Path: lib/utils/iterable_extensions.dart

/// Returns the first element of the iterable that satisfies the given [check].
///
/// Iterates over the elements of the [items] iterable and returns the first
/// element for which the [check] function returns `true`. If no such element is
/// found, returns `null`.
///
/// The [check] function must not throw or modify the iterable.
///
/// Example:
///
/// ```dart
/// final numbers = [1, 2, 3, 4];
/// final result = firstWhereOrNull(numbers, (n) => n.isEven);
/// print(result); // 2
/// ```
T? firstWhereOrNull<T>(Iterable<T> items, bool Function(T) check) {
  for (final item in items) {
    if (check(item)) {
      return item;
    }
  }
  return null;
}
