import Foundation

/// Defines how a target is configured with its data.
///
/// A configurable target provides its reuse identifier and receives
/// a 'PlumberSender' to configure itself and trigger events.
public protocol PlumberConfigurable: AnyObject {
    
    associatedtype Data
    
    static var reuseIdentifier: String { get }
    
    func configure(sender: PlumberSender<Data>)
}
