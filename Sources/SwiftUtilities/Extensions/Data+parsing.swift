import Foundation

/// Extension providing utility methods for working with `Data` objects, particularly for binary parsing operations.
public extension Data {
    /// Converts the data to an array of unsigned bytes.
    /// - Returns: An array of `UInt8` values representing the data's bytes.
    var unsignedBytes: [UInt8] {
        return [UInt8](self)
    }

    /// Converts the data to an array of signed 16-bit integers in little-endian format.
    /// - Returns: An array of `Int16` values representing the data as signed integers.
    var signedBytes: [Int16] {
        self.withUnsafeBytes {
            Array($0.bindMemory(to: Int16.self)).map(Int16.init(littleEndian:))
        }
    }

    /// Parses a signed 16-bit integer value from the data at a specified offset.
    /// - Parameter offset: The starting position in the data to parse from.
    /// - Returns: A signed integer value parsed from two bytes at the specified offset.
    func parseSignedValue(offset: Int) -> Int {
        let bytes = Data(self[offset...offset + 1])
        return Int(bytes.withUnsafeBytes { ptr in
            ptr.load(as: Int16.self)
        })
    }

    /// Parses an unsigned 16-bit integer value from the data at a specified offset.
    /// - Parameter offset: The starting position in the data to parse from.
    /// - Returns: An unsigned integer value parsed from two bytes at the specified offset.
    func parseUnsignedValue(offset: Int) -> Int {
        let bytes = Data(self[offset...offset + 1])
        return Int(bytes.withUnsafeBytes { ptr in
            ptr.load(as: UInt16.self)
        })
    }

    /// Parses an unsigned 32-bit integer value from the data at a specified offset.
    /// - Parameter offset: The starting position in the data to parse from.
    /// - Returns: An unsigned integer value parsed from four bytes at the specified offset.
    func parseUnsignedValue32(offset: Int) -> Int {
        let bytes = Data(self[offset...offset + 3])
        return Int(bytes.withUnsafeBytes { ptr in
            ptr.load(as: UInt32.self)
        })
    }

    /// Parses a signed 32-bit integer value from the data at a specified offset.
    /// - Parameter offset: The starting position in the data to parse from.
    /// - Returns: A signed integer value parsed from four bytes at the specified offset.
    func parseSignedValue32(offset: Int) -> Int {
        let bytes = Data(self[offset...offset + 3])
        return Int(bytes.withUnsafeBytes { ptr in
            ptr.load(as: Int32.self)
        })
    }
    
    /// Converts the data to a hexadecimal string representation.
    /// - Returns: A string where each byte is represented as a two-digit hexadecimal number, separated by spaces.
    var hexString: String {
        return map { String(format: "%02X", $0) }.joined(separator: " ")
    }
}

/// Extension providing data conversion utilities for Integer values.
public extension Int {
    /// Converts the integer to a Data object.
    /// - Returns: A Data object containing the bytes of the integer.
    var data: Data {
        var int = self
        return Data(bytes: &int, count: MemoryLayout<Int>.size)
    }
    
    /// Converts the integer to a byte array representation.
    /// - Returns: An array of two bytes representing the integer in big-endian format.
    var byteArray: [UInt8] {
        var bytes: [UInt8] = []
        bytes.append(UInt8(self >> 8))
        bytes.append(UInt8(self & (0xff)))
        return bytes
    }
}

/// Extension providing data conversion utilities for UInt8 values.
public extension UInt8 {
    /// Converts the UInt8 to a Data object.
    /// - Returns: A Data object containing the single byte.
    var data: Data {
        var int = self
        return Data(bytes: &int, count: MemoryLayout<UInt8>.size)
    }

    /// Converts any fixed-width integer type to a byte array.
    /// - Parameter value: The fixed-width integer value to convert.
    /// - Returns: An array of bytes representing the value.
    static func byteArray<T>(from value: T) -> [UInt8] where T: FixedWidthInteger {
        let length: Int = 2 * MemoryLayout<UInt8>.size
        let bytes = withUnsafeBytes(of: value) { bytes in
            Array(bytes.prefix(length))
        }
        return bytes
    }
}

/// Extension providing data conversion utilities for UInt16 values.
public extension UInt16 {
    /// Converts the UInt16 to a Data object.
    /// - Returns: A Data object containing the two bytes of the UInt16.
    var data: Data {
        var int = self
        return Data(bytes: &int, count: MemoryLayout<UInt16>.size)
    }
}

/// Extension providing data conversion utilities for UInt32 values.
public extension UInt32 {
    /// Converts the UInt32 to a Data object.
    /// - Returns: A Data object containing the four bytes of the UInt32.
    var data: Data {
        var int = self
        return Data(bytes: &int, count: MemoryLayout<UInt32>.size)
    }

    /// Converts the UInt32 to a byte array in little-endian format.
    /// - Returns: An array of four bytes representing the UInt32 in little-endian order.
    var byteArrayLittleEndian: [UInt8] {
        return [
            UInt8((self & 0xFF000000) >> 24),
            UInt8((self & 0x00FF0000) >> 16),
            UInt8((self & 0x0000FF00) >> 8),
            UInt8(self & 0x000000FF)
        ]
    }
}
