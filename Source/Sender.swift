import Foundation

/// Provides a cell with access to its data and event actions.
///
/// A sender is passed to a configurable target during configuration.
/// It provides access to the accosicated data and allows the target
/// to trigger events through 'send'.
public struct PlumberSender<Data> {
    
    internal var access: (any PipelineAccess<Data>)
    
    internal init(access: some PipelineAccess<Data>) {
        self.access = access
    }
    
    public var data: Data {
        access.data
    }
    
    public func send<Event: Hashable>(
        _ event: Event,
        parameters: Any? = nil
    ) {
        access.trigger(event, parameters: parameters)
    }
}
