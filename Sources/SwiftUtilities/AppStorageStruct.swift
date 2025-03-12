import SwiftUI

@propertyWrapper
struct AppStorageStruct<T: Codable> {
    private let key: String
    private let defaultValue: T
    private let storage: UserDefaults

    init(wrappedValue defaultValue: T, _ key: String, store: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.storage = store
    }

    var wrappedValue: T {
        get {
            if let data = storage.data(forKey: key) {
                let decoder = JSONDecoder()
                return (try? decoder.decode(T.self, from: data)) ?? defaultValue
            }
            return defaultValue
        }
        set {
            let encoder = JSONEncoder()
            if let data = try? encoder.encode(newValue) {
                storage.set(data, forKey: key)
            }
        }
    }
}
