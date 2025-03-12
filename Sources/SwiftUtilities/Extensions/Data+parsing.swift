import Foundation

public extension Data {
    var unsignedBytes: [UInt8] {
        return [UInt8](self)
    }

    var signedBytes: [Int16] {
        self.withUnsafeBytes {
            Array($0.bindMemory(to: Int16.self)).map(Int16.init(littleEndian:))
        }
    }

    func parseSignedValue(offset: Int) -> Int {
        let bytes = Data(self[offset...offset + 1])
        return Int(bytes.withUnsafeBytes { ptr in
            ptr.load(as: Int16.self)
        })
    }

    func parseUnsignedValue(offset: Int) -> Int {
        let bytes = Data(self[offset...offset + 1])
        return Int(bytes.withUnsafeBytes { ptr in
            ptr.load(as: UInt16.self)
        })
    }
}

public extension Int {
    var data: Data {
        var int = self
        return Data(bytes: &int, count: MemoryLayout<Int>.size)
    }
    
    var byteArray: [UInt8] {
        var bytes: [UInt8] = []
        bytes.append(UInt8(self >> 8))
        bytes.append(UInt8(self & (0xff)))
        return bytes
    }
}

public extension UInt8 {
    var data: Data {
        var int = self
        return Data(bytes: &int, count: MemoryLayout<UInt8>.size)
    }

    static func byteArray<T>(from value: T) -> [UInt8] where T: FixedWidthInteger {
        let length: Int = 2 * MemoryLayout<UInt8>.size
        let bytes = withUnsafeBytes(of: value) { bytes in
            Array(bytes.prefix(length))
        }
        return bytes
    }
}

public extension UInt16 {
    var data: Data {
        var int = self
        return Data(bytes: &int, count: MemoryLayout<UInt16>.size)
    }
}

public extension UInt32 {
    var data: Data {
        var int = self
        return Data(bytes: &int, count: MemoryLayout<UInt32>.size)
    }

    var byteArrayLittleEndian: [UInt8] {
        return [
            UInt8((self & 0xFF000000) >> 24),
            UInt8((self & 0x00FF0000) >> 16),
            UInt8((self & 0x0000FF00) >> 8),
            UInt8(self & 0x000000FF)
        ]
    }
}
