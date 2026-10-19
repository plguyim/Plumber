import Foundation

/// Provides a cell with access to its data and event actions.
///
/// A sender is passed to a configurable target during configuration.
/// It provides access to the accosicated data and allows the target
/// to trigger events through 'send'.
public struct PlumberSender<Data> {
    
    internal var pipeline: Pipeline<Data>
    
    internal init(pipeline: Pipeline<Data>) {
        self.pipeline = pipeline
    }
    
    public var data: Data {
        pipeline.data
    }
    
    public func send<Event: Hashable>(
        _ event: Event,
        parameters: Any? = nil
    ) {
        pipeline.trigger(event, parameters: parameters)
    }
}
