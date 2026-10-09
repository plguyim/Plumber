import UIKit
import Plumber
import SnapKit

class ViewController: UIViewController {
    
    weak var tableView: UITableView?
    var plumbers:[Plumber] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createUI()
        loadMockData()
    }
    
    func createUI() {
        let tableView = UITableView(frame: .zero)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsHorizontalScrollIndicator = false
        tableView.allowsMultipleSelection = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .black
        tableView.estimatedRowHeight = 100
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        self.tableView = tableView
        
        tableView.register(
            FlowerCell.self,
            forCellReuseIdentifier: FlowerCell.reuseIdentifier
        )
        
        tableView.register(
            AnimalCell.self,
            forCellReuseIdentifier: AnimalCell.reuseIdentifier
        )
    }
    
    func loadMockData() {
        let flowers = try! Flower.mock()
        let cats = try! Animal.mock()
        
        for (i, flower) in flowers.enumerated() {
            plumbers.append(
                Plumber(
                    data: flower,
                    cellClass: FlowerCell.self,
                    { [unowned self] registrar in
                        registrar.on(PlumberEvent.didSelect) { flower in
                            print("The row with \(flower.name) is selected.")
                            let presentedVC = PresentedViewController()
                            presentedVC.title = "It's belong to the Flower."
                            self.present(presentedVC, animated: true)
                        }
                        registrar.on(FlowerCell.Events.didTappedImage) { flower in
                            print("did tapped \(flower.localImageName)")
                        }
                    }
                )
            )
            plumbers.append(
                Plumber(
                    data: cats[i],
                    cellClass: AnimalCell.self,
                    { [unowned self] registrar in
                        registrar.on(PlumberEvent.didSelect) { cat in
                            print("The row with \(cat.name) is selected.")
                            let presentedVC = PresentedViewController()
                            presentedVC.title = "It's belong to the Animal."
                            self.present(presentedVC, animated: true)
                        }
                        registrar.on(AnimalCell.Events.didKittenGrowled) { cat in
                            print("The Kidden Growled.")
                        }
                    }
                )
            )
        }
    }
    
}

extension ViewController: UITableViewDataSource {
    
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
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        plumbers[indexPath.row].trigger(PlumberEvent.didSelect)
    }
    
}
