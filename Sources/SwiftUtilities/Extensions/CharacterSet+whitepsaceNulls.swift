import Foundation

/// Extension to provide additional character set functionality
extension CharacterSet {
    /// A character set containing whitespace characters, newlines, and null characters.
    ///
    /// This character set combines the standard `whitespacesAndNewlines` set with the null character (`\0`).
    /// It is useful for stripping or detecting all types of whitespace including null terminators.
    ///
    /// Example usage:
    /// ```swift
    /// let text = "Hello\0 World\n"
    /// let cleaned = text.components(separatedBy: .whitespacesNewlinesAndNulls).joined()
    /// // Result: "HelloWorld"
    /// ```
    static let whitespacesNewlinesAndNulls = CharacterSet.whitespacesAndNewlines.union(CharacterSet(["\0"]))
}
