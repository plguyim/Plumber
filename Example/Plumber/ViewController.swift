import UIKit
import Plumber
import SnapKit

class ViewController: UIViewController {
    
    weak var tableView: UITableView?
    var plumbers:[any AnyPlumber] = []
    
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
        
        tableView.register(
            AnimalCellTrailingAvatar.self,
            forCellReuseIdentifier: AnimalCellTrailingAvatar.reuseIdentifier
        )
    }
    
    func loadMockData() {
        let flowers = try! Flower.mock()
        let cats = try! Animal.mock()
        
        for i in 0..<5 {
            // add a flower plumber
            let flowerPlumber = Plumber(data: flowers[i])
            flowerPlumber.bind(FlowerCell.self)
            
            flowerPlumber.on(PlumberEvent.didSelect) { [unowned self] plumber in
                print("Selected flower: \(plumber.data.name)")
                
                let presentedVC = PresentedViewController()
                presentedVC.title = "Flower"
                self.present(presentedVC, animated: true)
            }
            flowerPlumber.on(FlowerCell.Events.didTappedImage) { plumber in
                print("did tapped \(plumber.data.localImageName)")
            }
            
            plumbers.append(flowerPlumber)
            
            // add a animal plumber
            let animalPlumber = Plumber(data: cats[i])
            animalPlumber.bind(AnimalCell.self)
            
            animalPlumber.on(PlumberEvent.didSelect) { [unowned self] plumber in
                print("Selected animal: \(plumber.data.name)")
                
                let presentedVC = PresentedViewController()
                presentedVC.title = "Animal"
                self.present(presentedVC, animated: true)
            }
            
            animalPlumber.on(AnimalCell.Events.didSelectAnimal) {[unowned self] plumber in
                // Change the bound cell type.
                plumber.bind(AnimalCellTrailingAvatar.self)
                
                self.tableView?.reloadData()
            }
            
            animalPlumber.on(AnimalCellTrailingAvatar.Events.didSelectAnimal) { [unowned self] plumber in
                // Change the bound cell type.
                plumber.bind(AnimalCell.self)
                
                self.tableView?.reloadData()
            }
            
            plumbers.append(animalPlumber)
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
