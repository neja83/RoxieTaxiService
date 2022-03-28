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
    private var service: Service = TaxiService.share
    private var list: [ActiveContract] = []

    // MARK: - override
    override func viewDidLoad() {
        super.viewDidLoad()
        title = service.name
        tableView.dataSource = self
        tableView.delegate   = self
        setupNavigationBar()
        
        updateList()
    }
    
    // MARK: - methods
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
    
    private func updateList() {
        service.getList { [weak self] data, error in
            if let data = data as? [ActiveContract] {
                self?.list.append(contentsOf: self?.sortByDate(data: data) ?? [] )
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
    
    /**
     - Returns: sorted list by orderTime
     */
    private func sortByDate(data: [ActiveContract]) -> [ActiveContract] {
        data.sorted {
            let formatterDate = ISO8601DateFormatter()
            return formatterDate.date(from: $0.orderTime)! < formatterDate.date(from: $1.orderTime)!
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! ActiveContractCell
      
        cell.amount.text = "\(model.price.amount/100),\(model.price.amount%100)"
        cell.currency.text = model.price.currency
        cell.fromCity.text = model.startAddress.city
        cell.fromAddress.text = model.startAddress.address
        cell.toCity.text = model.endAddress.city
        cell.toAddress.text = model.endAddress.address
        
        return cell
    }
    
}

extension ActiveContractList: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = list[indexPath.row]
        
        performSegue(withIdentifier: "detailIdentifier", sender: model)
        
    }
}

