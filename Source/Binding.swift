import Foundation

/// Provides access to a binding while hiding its concrete target type.
internal protocol BindingAccess: AnyObject {
        
    var reuseIdentifier: String { get }
    
    func bind(_ cell: AnyObject)
}

/// Accociates data with a cell type and configures the cell.
internal final class Binding<Data, Cell>
where Cell: AnyObject & PlumberConfigurable,
      Cell.Data == Data
{
    var pipeline: Pipeline<Data>
    var reuseIdentifier: String {
        Cell.reuseIdentifier
    }
    
    init(
        pipeline: Pipeline<Data>,
        cellClass: Cell.Type
    ) {
        self.pipeline = pipeline
    }
    
}

extension Binding: BindingAccess {
    
    func bind(_ cell: AnyObject) {
        guard let cell = cell as? Cell else {
            assertionFailure("Invalid cell type: \(type(of: cell))")
            return
        }
        
        cell.configure(
            sender: PlumberSender(pipeline: pipeline)
        )
    }
}
