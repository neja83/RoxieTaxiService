//
//  ViewController.swift
//  RoxieTaxiService
//
//  Created by Eugene Krapivenko on 25.03.2022.
//

import UIKit

class ActiveContractList: UIViewController {
    
    // MARK: - private
    @IBOutlet weak var tableView: UITableView!
    private let cellID: String = "activeContractService"
    private var service: Service = TaxiService()
    private var list: [ActiveContract] = []

    // MARK: - override
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate   = self
        setupNavigationBar()
        
        updateList()
        
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
    
    private func updateList() {
        service.getList { [weak self] data, error in
            if let data = data as? [ActiveContract] {
                self?.list.append(contentsOf: data)
                self?.tableView.reloadData()
            }
            if let error = error {
                self?.showMessage(with: error.localizedDescription)
            }
        }
    }
        
    private func showMessage(with message: String) {
        print(message)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier ==  "detailIdentifier", let activeContract = sender as? ActiveContract {
            let dest =  segue.destination as! DetailActiveContract
            dest.activeContract = activeContract
        }
    }
}

extension ActiveContractList: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = list[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellID)
        }
        
        cell!.textLabel?.text = String("\(model.id)")
        
        return cell!
    }
    
}

extension ActiveContractList: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = list[indexPath.row]
        
        performSegue(withIdentifier: "detailIdentifier", sender: model)
        
    }
}

