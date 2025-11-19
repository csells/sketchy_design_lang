/// Text casing options for transforming displayed text.
enum TitleCasing {
  /// No text transformation applied.
  none,

  /// All characters uppercase.
  allCaps,

  /// First letter of each word capitalized.
  titleCase,

  /// All characters lowercase.
  allLower,
}

/// Applies the specified [casing] transformation to [text].
///
/// Returns the transformed text according to the casing rule:
/// - [TitleCasing.none]: Returns text unchanged
/// - [TitleCasing.allCaps]: Converts all characters to uppercase
/// - [TitleCasing.titleCase]: Capitalizes first letter of each word
/// - [TitleCasing.allLower]: Converts all characters to lowercase
///
/// Example:
/// ```dart
/// applyTitleCasing('hello world', TitleCasing.titleCase); // 'Hello World'
/// applyTitleCasing('hello world', TitleCasing.allCaps);   // 'HELLO WORLD'
/// applyTitleCasing('HELLO WORLD', TitleCasing.allLower);  // 'hello world'
/// ```
String applyTitleCasing(String text, TitleCasing casing) {
  switch (casing) {
    case TitleCasing.none:
      return text;
    case TitleCasing.allCaps:
      return text.toUpperCase();
    case TitleCasing.titleCase:
      return toTitleCase(text);
    case TitleCasing.allLower:
      return text.toLowerCase();
  }
}

/// Converts text to title case (first letter of each word capitalized).
///
/// Words are separated by spaces. Each word has its first character
/// capitalized and remaining characters lowercased.
///
/// Examples:
/// - 'hello world' → 'Hello World'
/// - 'HELLO WORLD' → 'Hello World'
/// - 'hello' → 'Hello'
/// - '' → ''
String toTitleCase(String text) {
  if (text.isEmpty) return text;

  return text.split(' ').map((word) {
    if (word.isEmpty) return word;
    return word[0].toUpperCase() +
        (word.length > 1 ? word.substring(1).toLowerCase() : '');
  }).join(' ');
}
