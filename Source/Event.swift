import Foundation

/// Defines the built-in events provided by Plumber.
///
/// Custom events do not need to be declared here. Any 'Hashable' value
/// can be used as an event identifier.
public struct PlumberEvent: Hashable {
    public var name: String
    
    public static let didSelect = PlumberEvent(name: "common.didSelect")
    public static let didDeselect = PlumberEvent(name: "common.didDeselect")
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.name == rhs.name
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
