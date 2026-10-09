import Foundation

/// Provides an interface for registering event handlers.
///
/// The registrar exposes event registration without exposing the
/// underlying pipeline or its storage.
public struct PlumberRegistrar<Data> {
    
    internal var access: any PipelineAccess<Data>
    
    public var data:Data {
        access.data
    }
    
    internal init(access: some PipelineAccess<Data>) {
        self.access = access
    }
    
    public func on<Event: Hashable>(
        _ event: Event,
        _ action: @escaping (Data) -> Void
    ) {
        access.on(event) { data, _ in
            action(data)
        }
    }
    
    public func on<Event: Hashable>(
        _ event: Event,
        _ action: @escaping (Data, Any?) -> Void
    ) {
        access.on(event, action: action)
    }
    
}
