//
//  MushroomIDViewController.swift

import UIKit

class MushroomIDViewController: BaseViewController {
    
    private lazy var mushroomIDTableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(UINib(nibName: "MushroomIDCell", bundle: nil), forCellReuseIdentifier: "MushroomIDCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var scanButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "MyGarden-Add"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self,
                         action: #selector(addButtonTapped),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var emptyTopLabel: UILabel = {
        let label = UILabel()
        label.text = "Scan your first mushroom"
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubviews([mushroomIDTableView,
                          scanButton,
                          emptyTopLabel])
        setupConstraints()
    }
    
    @objc func addButtonTapped() {
        let preScannerViewController = ScannerFirstViewController()
        let nav = UINavigationController(rootViewController: preScannerViewController)
        nav.modalPresentationStyle = .overFullScreen
        nav.modalTransitionStyle = .crossDissolve
        self.present(nav, animated: true)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            mushroomIDTableView.topAnchor.constraint(equalTo: view.topAnchor),
            mushroomIDTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mushroomIDTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mushroomIDTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            scanButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25),
            scanButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            scanButton.heightAnchor.constraint(equalToConstant: 50),
            scanButton.widthAnchor.constraint(equalToConstant: 50),
            
            emptyTopLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyTopLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

}

extension MushroomIDViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

// MARK: - UITableViewDataSource

extension MushroomIDViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myGardenCell = tableView.dequeueReusableCell(withIdentifier: "MushroomIDCell", for: indexPath) as! MushroomIDCell
        
        return myGardenCell
    }
}
