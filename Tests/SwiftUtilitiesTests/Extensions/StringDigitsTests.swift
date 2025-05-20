import XCTest
@testable import SwiftUtilities

final class StringDigitsTests: XCTestCase {
    func testStringDigitsExtraction() {
        // Test basic digit extraction
        XCTAssertEqual("abc123def456".digits, [1, 2, 3, 4, 5, 6])
        
        // Test empty string
        XCTAssertEqual("".digits, [])
        
        // Test string with no digits
        XCTAssertEqual("abcdef".digits, [])
        
        // Test string with only digits
        XCTAssertEqual("12345".digits, [1, 2, 3, 4, 5])
        
        // Test string with special characters
        XCTAssertEqual("!@#1$%^2&*()3".digits, [1, 2, 3])
    }
    
    func testNumericDigitsExtraction() {
        // Test integer
        XCTAssertEqual(12345.digits, [1, 2, 3, 4, 5])
        
        // Test zero
        XCTAssertEqual(0.digits, [0])
        
        // Test negative number
        XCTAssertEqual((-12345).digits, [1, 2, 3, 4, 5])
    }
    
    func testLosslessStringConvertible() {
        let number = 42
        XCTAssertEqual(number.string, "42")
        
        let double = 3.14
        XCTAssertEqual(double.string, "3.14")
    }
} 