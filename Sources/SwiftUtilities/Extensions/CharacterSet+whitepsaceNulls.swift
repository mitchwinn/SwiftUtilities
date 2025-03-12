import Foundation

extension CharacterSet {
    static let whitespacesNewlinesAndNulls = CharacterSet.whitespacesAndNewlines.union(CharacterSet(["\0"]))
}
