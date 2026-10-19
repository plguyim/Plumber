import UIKit

/// Deffines a type-erased interface for plumbers with different data types.
///
/// This protocol allows plumbers with different data types to be used
/// through a shared interface without exposing their underlying data types.
public protocol AnyPlumber {
    
    func trigger(
        _ event: some Hashable
    )
    
    func trigger(
        _ event: some Hashable,
        parameters: Any?
    )
    
    func reusableCell(
        from tableView: UITableView,
        at indexPath: IndexPath
    ) -> UITableViewCell
    
    func reusableCell(
        from collectionView: UICollectionView,
        at indexPath: IndexPath
    ) -> UICollectionViewCell
    
}

/// Represents a plumber that manages cell binding and event handling.
///
/// A plumber associates data with a cell type and provides access to
/// the binding and event pipeline. Use 'bind' to associate a cell type
/// with the plumber. The binding can be changed in response to events,
/// allowing the plumber to use different cell types as needed. Plumbers
/// with different data types can be stored through the type-erased
/// 'AnyPlumber' interface.
public class Plumber<Data> {
    
    internal lazy var pipeline = Pipeline(plumber: self)
    internal var binding: (any BindingAccess)?
    
    public var data: Data
    
    public init(data: Data) {
        self.data = data
    }
    
    /// Binds a cell type to the plumber and allows the binding
    /// to be changed in response to events.
    public func bind<Cell>(
        _ cellClass: Cell.Type
    )
    where Cell: AnyObject & PlumberConfigurable,
          Cell.Data == Data
    {
        binding = Binding(pipeline: pipeline, cellClass: cellClass)
    }
    
    public func on<Event: Hashable>(
        _ event: Event,
        _ action: @escaping (_ plumber: Plumber<Data>) -> Void
    ) {
        pipeline.on(event) { plumber, _ in
            action(plumber)
        }
    }
    
    public func on<Event: Hashable>(
        _ event: Event,
        _ action: @escaping (_ plumber: Plumber<Data>, _ parameters: Any?) -> Void
    ) {
        pipeline.on(event, action: action)
    }
        
}

extension Plumber: AnyPlumber {
    
    public func trigger(
        _ event: some Hashable
    ) {
        trigger(event, parameters: nil)
    }
    
    public func trigger(_ event: some Hashable, parameters: Any?) {
        pipeline.trigger(event, parameters: parameters)
    }
    
    public func reusableCell(
        from tableView: UITableView,
        at indexPath: IndexPath
    ) -> UITableViewCell
    {
        guard let binding = binding else {
            assertionFailure("Call bind(_:) on Plumber before requesting a cell.")
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: binding.reuseIdentifier,
            for: indexPath
        )
        binding.bind(cell)
        
        return cell
    }
    
    public func reusableCell(
        from collectionView: UICollectionView,
        at indexPath: IndexPath
    ) -> UICollectionViewCell
    {
        guard let binding = binding else {
            assertionFailure("Call bind(_:) on Plumber before requesting a cell.")
            return UICollectionViewCell()
        }
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: binding.reuseIdentifier,
            for: indexPath
        )
        binding.bind(cell)
        
        return cell
    }
    
}
