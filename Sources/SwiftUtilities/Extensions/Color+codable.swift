import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

extension Color: Codable {
    private struct ColorComponents: Codable {
        let red: Double
        let green: Double
        let blue: Double
        let alpha: Double
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let components = try container.decode(ColorComponents.self)
        self.init(.sRGB, red: components.red, green: components.green, blue: components.blue, opacity: components.alpha)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        #if canImport(UIKit)
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        #elseif canImport(AppKit)
        let nsColor = NSColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        // Convert to sRGB color space first to ensure consistent behavior
        if let srgbColor = nsColor.usingColorSpace(.sRGB) {
            srgbColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        } else {
            // Fallback if conversion fails
            nsColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        }
        #endif
        
        let components = ColorComponents(
            red: Double(red),
            green: Double(green),
            blue: Double(blue),
            alpha: Double(alpha)
        )
        
        try container.encode(components)
    }
}