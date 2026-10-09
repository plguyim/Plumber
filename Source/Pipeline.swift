import Foundation

/// Provides access to a pipeline while erasing target type.
///
/// The data type is preserved, while the concrete target type is hidden.
/// This allows 'Sender' and 'Registrar' to interact with a pipeline
/// without depending on its concrete target type.
internal protocol PipelineAccess<Data>: AnyObject {
    
    associatedtype Data
    
    var data: Data { get }
    
    var reuseIdentifier: String { get }
    
    func bind(to target: AnyObject)
        
    func trigger<Event: Hashable>(
        _ event: Event,
        parameters: Any?
    )
    
    func on<Event: Hashable>(
        _ event: Event,
        action: @escaping (Data, Any?) -> Void
    )
}


/// Stores the data and registered events for a target.
///
/// A pipeline associates a specific data type with its target type,
/// manages event handlers, and provides the mechanism for triggering
/// events with the associated data and parameters.
internal final class Pipeline<Data, Cell>
where Cell: PlumberConfigurable,
      Cell.Data == Data
{
    
    var data: Data
    var cellClass: Cell.Type
    var reuseIdentifier: String
    
    var actions: [AnyHashable: (Data, Any?) -> Void] = [:]
    
    init(data: Data, cellClass: Cell.Type) {
        self.data = data
        self.cellClass = cellClass
        self.reuseIdentifier = Cell.reuseIdentifier
    }    
}

extension Pipeline: PipelineAccess {
    
    func bind(to cell: AnyObject) {
        guard let cell = cell as? Cell else {
            assertionFailure("Invalid target type: \(type(of: cell))")
            return
        }
        
        cell.configure(
            sender: PlumberSender(access: self)
        )
    }
    
    func on<Event: Hashable>(
        _ event: Event,
        action: @escaping (Data, Any?) -> Void
    ) {
        actions[event] = action
    }
    
    func trigger<Event: Hashable>(
        _ event: Event,
        parameters: Any?
    ) {
        actions[event]?(data, parameters)
    }
}
