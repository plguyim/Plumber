import UIKit

/// Provides UIKit integration for 'Plumber'.
///
/// These methods dequeue reusable cells from 'UITableView' and
/// 'UICollectionView' and configure them using the associated pipeline.
extension Plumber {
    
    public func reusableCell(
        from tableView: UITableView,
        at indexPath: IndexPath
    ) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: access.reuseIdentifier,
            for: indexPath
        )
        access.bind(to: cell)
        
        return cell
    }
    
    public func reusableCell(
        from collectionView: UICollectionView,
        at indexPath: IndexPath
    ) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: access.reuseIdentifier,
            for: indexPath
        )
        access.bind(to: cell)
        
        return cell
    }
    
}
