import Foundation

/// A type-erased wrapper around a pipeline.
///
/// Plumber allows piplines with different data and target types to be
/// stored together in single array. View Controllers can use an array
/// of plumbers to define the order of targets, configure cells, and
/// register related events.
public class Plumber {
    
    internal var access: any PipelineAccess
    
    var data: Any {
        access.data
    }
    
    public init<Data, Cell>(
        data: Data,
        cellClass: Cell.Type,
        _ closure: (_ registrar: PlumberRegistrar<Data>) -> Void
    ) where Cell: AnyObject & PlumberConfigurable,
            Cell.Data == Data
    {
        let pipeline = Pipeline(data: data, cellClass: cellClass)
        closure(PlumberRegistrar(access: pipeline))
        self.access = pipeline
    }
        
    public func trigger<Event: Hashable>(_ event: Event, parameters: Any? = nil) {
        access.trigger(event, parameters: parameters)
    }
    
}
