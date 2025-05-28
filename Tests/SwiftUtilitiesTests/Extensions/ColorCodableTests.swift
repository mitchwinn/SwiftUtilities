import XCTest
import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif
@testable import SwiftUtilities

final class ColorCodableTests: XCTestCase {
    
    // MARK: - Test Data
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    // MARK: - Basic Encoding/Decoding Tests
    
    func testBasicColorEncoding() throws {
        let color = Color.red
        let data = try encoder.encode(color)
        
        XCTAssertNotNil(data)
        XCTAssertFalse(data.isEmpty)
    }
    
    func testBasicColorDecoding() throws {
        let originalColor = Color.blue
        let data = try encoder.encode(originalColor)
        let decodedColor = try decoder.decode(Color.self, from: data)
        
        // Colors should be functionally equivalent
        XCTAssertNotNil(decodedColor)
    }
    
    func testRedColorRoundTrip() throws {
        let originalColor = Color.red
        let data = try encoder.encode(originalColor)
        let decodedColor = try decoder.decode(Color.self, from: data)
        
        // Verify the colors have the same components
        try assertColorsEqual(originalColor, decodedColor, accuracy: 0.01)
    }
    
    func testBlueColorRoundTrip() throws {
        let originalColor = Color.blue
        let data = try encoder.encode(originalColor)
        let decodedColor = try decoder.decode(Color.self, from: data)
        
        try assertColorsEqual(originalColor, decodedColor, accuracy: 0.01)
    }
    
    func testGreenColorRoundTrip() throws {
        let originalColor = Color.green
        let data = try encoder.encode(originalColor)
        let decodedColor = try decoder.decode(Color.self, from: data)
        
        try assertColorsEqual(originalColor, decodedColor, accuracy: 0.01)
    }
    
    func testCustomColorRoundTrip() throws {
        let originalColor = Color(.sRGB, red: 0.5, green: 0.7, blue: 0.3, opacity: 0.8)
        let data = try encoder.encode(originalColor)
        let decodedColor = try decoder.decode(Color.self, from: data)
        
        try assertColorsEqual(originalColor, decodedColor, accuracy: 0.01)
    }
    
    // MARK: - Alpha/Opacity Tests
    
    func testTransparentColor() throws {
        let originalColor = Color.clear
        let data = try encoder.encode(originalColor)
        let decodedColor = try decoder.decode(Color.self, from: data)
        
        try assertColorsEqual(originalColor, decodedColor, accuracy: 0.01)
    }
    
    func testSemiTransparentColor() throws {
        let originalColor = Color.red.opacity(0.5)
        let data = try encoder.encode(originalColor)
        let decodedColor = try decoder.decode(Color.self, from: data)
        
        try assertColorsEqual(originalColor, decodedColor, accuracy: 0.01)
    }
    
    func testVariousOpacityLevels() throws {
        let opacityLevels: [Double] = [0.0, 0.25, 0.5, 0.75, 1.0]
        
        for opacity in opacityLevels {
            let originalColor = Color.purple.opacity(opacity)
            let data = try encoder.encode(originalColor)
            let decodedColor = try decoder.decode(Color.self, from: data)
            
            try assertColorsEqual(originalColor, decodedColor, accuracy: 0.01)
        }
    }
    
    // MARK: - Edge Cases
    
    func testBlackColor() throws {
        let originalColor = Color.black
        let data = try encoder.encode(originalColor)
        let decodedColor = try decoder.decode(Color.self, from: data)
        
        try assertColorsEqual(originalColor, decodedColor, accuracy: 0.01)
    }
    
    func testWhiteColor() throws {
        let originalColor = Color.white
        let data = try encoder.encode(originalColor)
        let decodedColor = try decoder.decode(Color.self, from: data)
        
        try assertColorsEqual(originalColor, decodedColor, accuracy: 0.01)
    }
    
    func testExtremeColorValues() throws {
        // Test color with all maximum values
        let maxColor = Color(.sRGB, red: 1.0, green: 1.0, blue: 1.0, opacity: 1.0)
        let maxData = try encoder.encode(maxColor)
        let decodedMaxColor = try decoder.decode(Color.self, from: maxData)
        try assertColorsEqual(maxColor, decodedMaxColor, accuracy: 0.01)
        
        // Test color with all minimum values
        let minColor = Color(.sRGB, red: 0.0, green: 0.0, blue: 0.0, opacity: 0.0)
        let minData = try encoder.encode(minColor)
        let decodedMinColor = try decoder.decode(Color.self, from: minData)
        try assertColorsEqual(minColor, decodedMinColor, accuracy: 0.01)
    }
    
    // MARK: - Array of Colors
    
    func testColorArray() throws {
        let colors: [Color] = [
            .red,
            .green,
            .blue,
            .yellow.opacity(0.5),
            Color(.sRGB, red: 0.2, green: 0.4, blue: 0.8, opacity: 0.9)
        ]
        
        let data = try encoder.encode(colors)
        let decodedColors = try decoder.decode([Color].self, from: data)
        
        XCTAssertEqual(colors.count, decodedColors.count)
        
        for (original, decoded) in zip(colors, decodedColors) {
            try assertColorsEqual(original, decoded, accuracy: 0.01)
        }
    }
    
    // MARK: - JSON Structure Tests
    
    func testJSONStructure() throws {
        let color = Color(.sRGB, red: 0.5, green: 0.7, blue: 0.3, opacity: 0.8)
        let data = try encoder.encode(color)
        
        // Parse as JSON to verify structure
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        XCTAssertNotNil(json)
        
        XCTAssertNotNil(json?["red"] as? Double)
        XCTAssertNotNil(json?["green"] as? Double)
        XCTAssertNotNil(json?["blue"] as? Double)
        XCTAssertNotNil(json?["alpha"] as? Double)
        
        // Verify approximate values with proper optional handling
        if let redValue = json?["red"] as? Double {
            XCTAssertEqual(redValue, 0.5, accuracy: 0.01)
        } else {
            XCTFail("Red value not found in JSON")
        }
        
        if let greenValue = json?["green"] as? Double {
            XCTAssertEqual(greenValue, 0.7, accuracy: 0.01)
        } else {
            XCTFail("Green value not found in JSON")
        }
        
        if let blueValue = json?["blue"] as? Double {
            XCTAssertEqual(blueValue, 0.3, accuracy: 0.01)
        } else {
            XCTFail("Blue value not found in JSON")
        }
        
        if let alphaValue = json?["alpha"] as? Double {
            XCTAssertEqual(alphaValue, 0.8, accuracy: 0.01)
        } else {
            XCTFail("Alpha value not found in JSON")
        }
    }
    
    // MARK: - Helper Methods
    
    private func assertColorsEqual(_ color1: Color, _ color2: Color, accuracy: Double) throws {
        let components1 = try getColorComponents(color1)
        let components2 = try getColorComponents(color2)
        
        XCTAssertEqual(components1.red, components2.red, accuracy: accuracy, "Red components don't match")
        XCTAssertEqual(components1.green, components2.green, accuracy: accuracy, "Green components don't match")
        XCTAssertEqual(components1.blue, components2.blue, accuracy: accuracy, "Blue components don't match")
        XCTAssertEqual(components1.alpha, components2.alpha, accuracy: accuracy, "Alpha components don't match")
    }
    
    private func getColorComponents(_ color: Color) throws -> (red: Double, green: Double, blue: Double, alpha: Double) {
        #if canImport(UIKit)
        let uiColor = UIColor(color)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (Double(red), Double(green), Double(blue), Double(alpha))
        #elseif canImport(AppKit)
        let nsColor = NSColor(color)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        if let srgbColor = nsColor.usingColorSpace(.sRGB) {
            srgbColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        } else {
            nsColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        }
        return (Double(red), Double(green), Double(blue), Double(alpha))
        #endif
    }
} 