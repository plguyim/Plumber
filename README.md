# Plumber

A lightweight UIKit framework for managing heterogeneous data, reusable cells, and events.

Plumber connects data with its corresponding target type and provides a unified way to configure reusable cells and handle events in UITableView and CollectionView.

## Features

- Heterogeneous lists - Manage different data and target types in a single [Plumber] array.
- Type-safe configuration - Associate each data type with its corresponding configurable target.
- Event regsitration - Register event handlers with out scattering cell-specific callback logic throughout view controllers.
- Flexible ordering - Control the order of list items by arranging Plumber instances.
- UIKit integration - Dequeue and configure reusable table view and collection view cells through dedicated extensions.
- Separation of concerns  - Keep data configuration, event registration, and event triggering separate.

## Why Plumber?

When a list contains multiple cell types, a view controller often needs to determine which model belongs to each index path, dequeue the appropriate cell, configure it, and handle cell-specific events.

As the number of cell types grows, this can lead to repetitive type checks, casting, and branching logic.

Plumber encapsulates the relationship between data and its target type. The view controller can manage heterogeneous items through a single array, while each Plumber instance handles the configuration and event registration associated with its item.

## Usage

### 1. Make a Cell Configurable and Register it

Conform your cell to PlumberConfigurable and define its reuse identifer.

``` swift
    class UserCell: UITableViewCell, PlumberConfigurable {
        
        enum Event {
            case didTappedImageView
        }

        static var reuseIdentifier: String {
            "UserCell"
        }

        func configure(sender: PlumberSender<User>) {
            let user = sender.data

            // Configure the cell using the user data.
            
        }
    }
```

The sender provides access to the asscociated data and allows the cell to trigger registered events.


Register the cell in your view controller.

``` swift
    tableView.register(
        UserCell.self,
        forCellReuseIdentifier: UserCell.reuseIdentifier
    )
    
```

Plumber uses the cell's reuse identifier to dequeue and configure the appropriate reuseable cell.


### 2. Create Plumber instances and Register events

Asscociate each data item with its target type.

``` swift
    let userPlumber = Plumber(data: user)
    userPlumber.bind(UserCell.self)
    
    userPlumber.on(PlumberEvent.didSelect) { [weak self] plumber in
        let user = plumber.data
        // Handle the events here.
        
    }
    userPlumber.on(UserCell.Events.didSelectAvatar) { [weak self] plumber in
        // Change the bound cell type.
        plumber.bind(OtherUserCell.self)
        self?.tableView?.reloadData()
    }
    
    let orderPlumber = Plumber(data: order)
    orderPlumber.bind(OrderCell.self)
    
    orderPlumber.on(OrderCell.Events.didTappedPrimaryButton) { [weak self] plumber in
        let order = plumber.data
        // Handle the event here.

    }
    
```
Each Plumber instance represents on data-and-target assocation.

Plumber provides built-in list events such as selection and deselection. Custom events can use any Hashable value, so application-specific events do not need to be added to the built-in event definitions.

### 3. Define the list

Store Plumber instances in an array to determine the order of the items.

``` swift
    var plumbers: [any AnyPlumber] = [
        userPlumber,
        orderPlumber
    ]

```

The array can contain items backed by different data and target types without requiring the view controller to manage separate arrays for each type.

### 4. integrate with UITableView

Use the UIKit extension to dequeue and configure the cell associated with an item.

``` swift
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        plumbers.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        plumbers[indexPath.row].reusableCell(
            from: tableView,
            at: indexPath
        )
    }

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        plumbers[indexPath.row].trigger(PlumberEvent.didSelect)
    }

```

The view controller does not need to inspect the concrete data or cell type to determine which cell to return.

The same approach can be used with UICollectionView.

## Requirements

- iOS version:[Specify minimum supported version]
- Swift version: [Specify supported version]
- UIKit

## Installation

Plumber is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Plumber'
```

Then run:

```ruby
pod install
```

## License

Plumber is available under the MIT license. See the LICENSE file for more info.
