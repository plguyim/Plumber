import Foundation


/// Stores the data and registered events for a target.
///
/// A pipeline associates a specific data type with its target type,
/// manages event handlers, and provides the mechanism for triggering
/// events with the associated data and parameters.
internal final class Pipeline<Data> {    
    
    var data: Data {
        plumber.data
    }
    
    unowned var plumber: Plumber<Data>
    
    var actions: [AnyHashable: (Plumber<Data>, Any?) -> Void] = [:]
    
    init(plumber: Plumber<Data>) {
        self.plumber = plumber
    }
    
    func on<Event: Hashable>(
        _ event: Event,
        action: @escaping (_ plumber: Plumber<Data>, _ parameters: Any?) -> Void
    ) {
        actions[event] = action
    }
    
    func trigger<Event: Hashable>(
        _ event: Event,
        parameters: Any?
    ) {
        actions[event]?(plumber, parameters)
    }
    
}

