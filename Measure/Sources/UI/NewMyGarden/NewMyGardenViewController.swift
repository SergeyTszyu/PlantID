import UIKit
import RealmSwift

fileprivate enum GardenContentType: Int {
    case myGarden
    case history
}

final class NewMyGardenViewController: BaseViewController {
    
    private var tabsControl: TabsControl!
    
    private var emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "MyGarden-Empty")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var addPlantShadow: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AddPlantShadow")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var emptyTopLabel: UILabel = {
        let label = UILabel()
        label.text = "Your garden is empty"
        label.font = Fonts.bold.addFont(24)
        label.textColor = UIColor(hexString: "#1D3C2B")
        label.textAlignment = .left
        label.numberOfLines = 1
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emptyBottomLabel: UILabel = {
        let label = UILabel()
        label.text = "Add your first plant to growing \nyour garden"
        label.font = Fonts.medium.addFont(16)
        label.textColor = UIColor(hexString: "#A6ADB3")
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var myGardenTableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(UINib(nibName: "MyGardenCell", bundle: nil), forCellReuseIdentifier: "MyGardenCell")
        tableView.register(UINib(nibName: "HistoryCell", bundle: nil), forCellReuseIdentifier: HistoryCell.identifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private(set) lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "MyGarden-Add"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - 
    
    private var plantResponses: Results<PlantIdentificationResponse>?
    private var historyData: Results<ScanHistoryRealm>?
    private var notificationToken: NotificationToken?
    private var scannerType: ScannerType = .identify
    private var contentType: GardenContentType = .myGarden {
        didSet {
            myGardenTableView.reloadData()
        }
    }
    
    fileprivate var isEmpty = true {
        didSet {
            myGardenTableView.reloadData()
            updateEmptyStateVisibility()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        fetchPlantIdentificationResponses()
    }
    
    private func configure() {
        
        let tabTitles = ["My plants", "History"]
        tabsControl = TabsControl(titles: tabTitles)
        tabsControl.delegate = self
        tabsControl.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubviews([myGardenTableView, tabsControl, addPlantShadow, addButton,
                          emptyImageView, emptyTopLabel, emptyBottomLabel])
        setupConstraints()
        fetchData()
        
        tabsControl.setSelectedTabIndex(0)
    }
    
    func fetchData() {
        let realm = try! Realm()
        historyData = realm.objects(ScanHistoryRealm.self).sorted(byKeyPath: "scanDate", ascending: false)
        myGardenTableView.reloadData()
        updateEmptyStateVisibility()
    }
    
    private func fetchPlantIdentificationResponses() {
        plantResponses = mainRealm.objects(PlantIdentificationResponse.self).filter("isAddedToGarden == true")
            .sorted(byKeyPath: "scanDate", ascending: false)
        isEmpty = plantResponses?.isEmpty ?? true
        myGardenTableView.reloadData()
    }
    
    func updateEmptyStateVisibility() {
        let shouldShowEmptyState = false
        
        emptyImageView.isHidden = !shouldShowEmptyState
        emptyTopLabel.isHidden = !shouldShowEmptyState
        emptyBottomLabel.isHidden = !shouldShowEmptyState
        myGardenTableView.isHidden = shouldShowEmptyState
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tabsControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tabsControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tabsControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tabsControl.heightAnchor.constraint(equalToConstant: 48),
            
            myGardenTableView.topAnchor.constraint(equalTo: tabsControl.bottomAnchor),
            myGardenTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            myGardenTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            myGardenTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyImageView.topAnchor.constraint(equalTo: tabsControl.bottomAnchor, constant: 108),
            emptyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            emptyTopLabel.topAnchor.constraint(equalTo: emptyImageView.bottomAnchor, constant: 32),
            emptyTopLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            emptyBottomLabel.topAnchor.constraint(equalTo: emptyTopLabel.bottomAnchor, constant: 16),
            emptyBottomLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            addPlantShadow.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addPlantShadow.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            addPlantShadow.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            addPlantShadow.heightAnchor.constraint(equalToConstant: 156),
            
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            addButton.heightAnchor.constraint(equalToConstant: 50),
            addButton.widthAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    @objc func addButtonTapped() {
        let preScannerViewController = ScannerFirstViewController()
        preScannerViewController.delegate = self
        let nav = UINavigationController(rootViewController: preScannerViewController)
        nav.modalPresentationStyle = .overFullScreen
        nav.modalTransitionStyle = .crossDissolve
        self.present(nav, animated: true)
//        let vc = OpenPlantViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UITableViewDelegate

extension NewMyGardenViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let obj = plantResponses?[indexPath.row] {
//            let vc = ScannerResultViewController()
//            vc.result = obj
//            vc.scannerType = .identify
//            vc.image = UIImage(data: obj.localImageData!)
//            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

// MARK: - UITableViewDataSource

extension NewMyGardenViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentType == .myGarden ? plantResponses?.count ?? 0 : historyData?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if contentType == .myGarden {
            let myGardenCell = tableView.dequeueReusableCell(withIdentifier: "MyGardenCell", for: indexPath) as! MyGardenCell
            myGardenCell.configure()
            if let obj = plantResponses?[indexPath.row] {
                myGardenCell.fill(obj)
            }
            return myGardenCell
        } else {
            let historyCell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.identifier, for: indexPath) as! HistoryCell
            if let historyItem = historyData?[indexPath.row] {
                historyCell.fill(historyItem)
            }
            return historyCell
        }
    }
}

extension NewMyGardenViewController: ScannerFirstViewControllerDelegate {
    
    func scannerFirstViewController(_ controller: ScannerFirstViewController, scannerType type: Int) {
        let type = ScannerType(rawValue: type)!
        scannerType = type
    }
    
    func scannerFirstViewControllerDismiss(_ controller: ScannerFirstViewController) {
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.selectedIndex = 0
    }
}

// MARK: -

extension NewMyGardenViewController: TabsControlDelegate {
    
    func tabsControl(_ tabsControl: TabsControl, didSelectTabAtIndex index: Int) {
        let type = GardenContentType(rawValue: index)!
        self.contentType = type
    }
}
