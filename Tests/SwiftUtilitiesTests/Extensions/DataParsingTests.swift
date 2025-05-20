import XCTest
@testable import SwiftUtilities

final class DataParsingTests: XCTestCase {
    func testUnsignedBytes() {
        let data = Data([0x01, 0x02, 0x03, 0x04])
        XCTAssertEqual(data.unsignedBytes, [0x01, 0x02, 0x03, 0x04])
    }
    
    func testSignedBytes() {
        let data = Data([0x01, 0x00, 0xFF, 0xFF]) // 1 and -1 in little-endian Int16
        let signedValues = data.signedBytes
        XCTAssertEqual(signedValues, [1, -1])
    }
    
    func testParseSignedValue() {
        let data = Data([0x01, 0x00, 0xFF, 0xFF]) // 1 and -1 in little-endian
        XCTAssertEqual(data.parseSignedValue(offset: 0), 1)
        XCTAssertEqual(data.parseSignedValue(offset: 2), -1)
    }
    
    func testParseUnsignedValue() {
        let data = Data([0x01, 0x00, 0xFF, 0xFF]) // 1 and 65535 in little-endian
        XCTAssertEqual(data.parseUnsignedValue(offset: 0), 1)
        XCTAssertEqual(data.parseUnsignedValue(offset: 2), 65535)
    }
    
    func testParseUnsignedValue32() {
        let data = Data([0x01, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF])
        XCTAssertEqual(data.parseUnsignedValue32(offset: 0), 1)
        XCTAssertEqual(data.parseUnsignedValue32(offset: 4), Int(UInt32.max))
    }
    
    func testParseSignedValue32() {
        let data = Data([0x01, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF])
        XCTAssertEqual(data.parseSignedValue32(offset: 0), 1)
        XCTAssertEqual(data.parseSignedValue32(offset: 4), -1)
    }
    
    func testHexString() {
        let data = Data([0x01, 0x02, 0xFF])
        XCTAssertEqual(data.hexString, "01 02 FF")
    }
    
    func testIntegerExtensions() {
        // Test Int to Data conversion
        let intValue = 42
        XCTAssertEqual(Array(intValue.data), Array(withUnsafeBytes(of: intValue) { Array($0) }))
        
        // Test Int to byte array conversion
        XCTAssertEqual(intValue.byteArray, [0x00, 0x2A])
    }
    
    func testUInt8Extensions() {
        let uint8Value: UInt8 = 42
        XCTAssertEqual(Array(uint8Value.data), [42])
        
        // Test byteArray conversion
        let uint16Value: UInt16 = 258 // 0x0102
        let bytes = UInt8.byteArray(from: uint16Value)
        XCTAssertEqual(bytes.prefix(2), [0x02, 0x01]) // Little-endian format
    }
    
    func testUInt16Extensions() {
        let uint16Value: UInt16 = 258 // 0x0102
        XCTAssertEqual(Array(uint16Value.data), Array(withUnsafeBytes(of: uint16Value) { Array($0) }))
    }
    
    func testUInt32Extensions() {
        let uint32Value: UInt32 = 0x12345678
        
        // Test Data conversion
        XCTAssertEqual(Array(uint32Value.data), Array(withUnsafeBytes(of: uint32Value) { Array($0) }))
        
        // Test byte array conversion
        XCTAssertEqual(uint32Value.byteArrayLittleEndian, [0x12, 0x34, 0x56, 0x78])
    }
} 