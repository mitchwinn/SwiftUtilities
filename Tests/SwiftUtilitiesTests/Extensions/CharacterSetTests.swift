import XCTest
@testable import SwiftUtilities

final class CharacterSetTests: XCTestCase {
    func testWhitespacesNewlinesAndNulls() {
        let testString = "Hello\0 World\n\tGoodbye"
        let components = testString.components(separatedBy: .whitespacesNewlinesAndNulls)
            .filter { !$0.isEmpty }
        
        // Test that whitespace, newlines, and nulls are used as separators
        XCTAssertEqual(components, ["Hello", "World", "Goodbye"])
        
        // Test string with consecutive whitespace/null characters
        let multipleSpaces = "Hello\0\0  \n\t\tWorld"
        let multipleComponents = multipleSpaces.components(separatedBy: .whitespacesNewlinesAndNulls)
            .filter { !$0.isEmpty }
        XCTAssertEqual(multipleComponents, ["Hello", "World"])
        
        // Test string with only whitespace/null characters
        let onlyWhitespace = " \0\n\t"
        let emptyComponents = onlyWhitespace.components(separatedBy: .whitespacesNewlinesAndNulls)
            .filter { !$0.isEmpty }
        XCTAssertEqual(emptyComponents, [])
        
        // Test empty string
        let emptyString = ""
        let emptyStringComponents = emptyString.components(separatedBy: .whitespacesNewlinesAndNulls)
        XCTAssertEqual(emptyStringComponents, [""])
    }
} 