/// Text casing options for transforming displayed text.
enum TextCase {
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
/// - [TextCase.none]: Returns text unchanged
/// - [TextCase.allCaps]: Converts all characters to uppercase
/// - [TextCase.titleCase]: Capitalizes first letter of each word
/// - [TextCase.allLower]: Converts all characters to lowercase
///
/// Example:
/// ```dart
/// applyTextCase('hello world', TextCase.titleCase); // 'Hello World'
/// applyTextCase('hello world', TextCase.allCaps);   // 'HELLO WORLD'
/// applyTextCase('HELLO WORLD', TextCase.allLower);  // 'hello world'
/// ```
String applyTextCase(String text, TextCase casing) {
  switch (casing) {
    case TextCase.none:
      return text;
    case TextCase.allCaps:
      return text.toUpperCase();
    case TextCase.titleCase:
      return toTitleCase(text);
    case TextCase.allLower:
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

  return text
      .split(' ')
      .map((word) {
        if (word.isEmpty) return word;
        return word[0].toUpperCase() +
            (word.length > 1 ? word.substring(1).toLowerCase() : '');
      })
      .join(' ');
}
