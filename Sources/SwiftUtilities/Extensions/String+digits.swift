import Foundation

/// Extends `StringProtocol` to provide functionality for extracting numeric digits.
extension StringProtocol  {
    /// Returns an array of integers containing all numeric digits in the string.
    ///
    /// This property extracts all numeric digits from the string and converts them to integers.
    /// Non-numeric characters are ignored.
    ///
    /// Example:
    /// ```swift
    /// let text = "abc123def456"
    /// print(text.digits) // Prints: [1, 2, 3, 4, 5, 6]
    /// ```
    var digits: [Int] { compactMap(\.wholeNumberValue) }
}

/// Extends types conforming to `LosslessStringConvertible` to provide string conversion.
extension LosslessStringConvertible {
    /// Converts the value to its string representation.
    ///
    /// This property provides a convenient way to convert any `LosslessStringConvertible`
    /// type to a string using the type's default string conversion.
    var string: String { .init(self) }
}

/// Extends numeric types that can be converted to and from strings without loss.
extension Numeric where Self: LosslessStringConvertible {
    /// Returns an array of integers containing all digits in the numeric value.
    ///
    /// This property first converts the numeric value to a string, then extracts
    /// all digits from that string representation.
    ///
    /// Example:
    /// ```swift
    /// let number = 12345
    /// print(number.digits) // Prints: [1, 2, 3, 4, 5]
    /// ```
    var digits: [Int] { string.digits }
}
