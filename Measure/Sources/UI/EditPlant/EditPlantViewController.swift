//
//  EditPlantViewController.swift
//  PlantNEW
//
//  Created by Sergey Tszyu on 23.11.2024.
//

import UIKit

class EditPlantViewController: BaseViewController {
    
    @IBOutlet private weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "EditPlantCell", bundle: nil), forCellReuseIdentifier: "EditPlantCell")
    }
    
    @IBAction func save() {
        
    }
}

extension EditPlantViewController: UITableViewDelegate {
    
}

extension EditPlantViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditPlantCell", for: indexPath) as! EditPlantCell
        return cell
    }
}
