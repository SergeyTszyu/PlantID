//
//  ScannerResultIdentify.swift
//  PlantNEW
//
//  Created by Sergey Tszyu on 08.11.2024.
//

import UIKit
import RealmSwift

class ScannerResultIdentify: BaseViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var addToGardenButton: UIButton!
    
    var result: PlantIdentificationResponse!
    var resultHealty: PlantResponse!
    var image: UIImage!
    var scannerType: ScannerType = .identify
    
    var plantToSaving: PlantIdentificationResponse!

    override func viewDidLoad() {
        super.viewDidLoad()
                
        let backButton = UIBarButtonItem(image: UIImage(named: "chevron-left")!, style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
//        title = result.suggestions.first!.plantName

        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "ScannerResultFooterCell", bundle: nil), forCellReuseIdentifier: "ScannerResultFooterCell")
        tableView.register(UINib(nibName: "ScannerResultHeaderCell", bundle: nil), forCellReuseIdentifier: "ScannerResultHeaderCell")
        tableView.register(UINib(nibName: "ScannerResultHealthHeaderCell", bundle: nil), forCellReuseIdentifier: "ScannerResultHealthHeaderCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        if let tabBarController = self.tabBarController {
            tabBarController.tabBar.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let tabBarController = self.tabBarController {
            tabBarController.tabBar.isHidden = false
        }
    }
    
    @IBAction func addToGarden(_ sender: UIButton) {
        if let existingResponse = mainRealm.object(ofType: PlantIdentificationResponse.self, forPrimaryKey: result.id) {
            try? mainRealm.write {
                existingResponse.isAddedToGarden = true
            }
            tabBarController?.selectedIndex = 0
            return
        }
        saveToDatabase(result)
        navigationController?.popToRootViewController(animated: true)
        tabBarController?.selectedIndex = 0
    }
    
    func saveToDatabase(_ response: PlantIdentificationResponse) {
        response.isAddedToGarden = true
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        response.localImageData = imageData
        realmWrite {
            mainRealm.add(response, update: .modified)
        }
    }
    
    @objc func backButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }

}

extension ScannerResultIdentify: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if scannerType == .identify {
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ScannerResultHeaderCell", for: indexPath) as! ScannerResultHeaderCell
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ScannerResultFooterCell", for: indexPath) as! ScannerResultFooterCell
                cell.fill("Main Information:", bottomText: "Strelitzia is a genus of five species of perennial flowering plants native to South Africa. Commonly known as the bird of paradise due to its exotic flowers resembling a bird in flight, Strelitzia belongs to the family Strelitziaceae. It is widely admired for its stunning appearance, making it a popular choice for both indoor and outdoor settings.")
                return cell
            default: return UITableViewCell()
            }
        } else {
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ScannerResultHealthHeaderCell", for: indexPath) as! ScannerResultHealthHeaderCell
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ScannerResultHealthHeaderCell", for: indexPath) as! ScannerResultHealthHeaderCell
                return cell
            default:
                return UITableViewCell()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if scannerType == .identify {
            return 2
        } else {
            return 1
        }
    }
}
