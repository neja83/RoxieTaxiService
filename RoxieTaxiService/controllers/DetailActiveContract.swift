//
//  DetailActiveContract.swift
//  RoxieTaxiService
//
//  Created by Eugene Krapivenko on 27.03.2022.
//

import UIKit

class DetailActiveContract: UIViewController {

    @IBOutlet weak var photo: UIImageView!
    
    @IBOutlet weak var modelName: UILabel!
    @IBOutlet weak var regNumber: UILabel!
    @IBOutlet weak var driverName: UILabel!
    
    @IBOutlet weak var orderTime: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var currency: UILabel!
    
    
    @IBOutlet weak var fromCity: UILabel!
    @IBOutlet weak var fromAddress: UILabel!
    
    @IBOutlet weak var toCity: UILabel!
    @IBOutlet weak var toAddress: UILabel!
    
    private var service: Service = TaxiService.share
    
    var activeContract: ActiveContract!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photo.layer.cornerRadius = 8
        
        setupView()
    }
    
    private func setupView() {
        modelName.text = activeContract.vehicle.modelName
        regNumber.text = activeContract.vehicle.regNumber
        driverName.text = activeContract.vehicle.driverName
        
        orderTime.text = DateParser.change(srt: activeContract.orderTime, inFormat: .dayMonthYearTime)
        amount.text = "\(activeContract.price.amount/100),\(activeContract.price.amount%100)"
        currency.text = Currency.convert(from: activeContract.price.currency)
        
        fromCity.text = activeContract.startAddress.city
        fromAddress.text = activeContract.startAddress.address
        
        toCity.text = activeContract.endAddress.city
        toAddress.text = activeContract.endAddress.address
        
        service.getPhoto(by: activeContract.vehicle.photo) { [weak self] image, error in
            if error == nil {
                self?.photo.image = image
            }
        }
    }
}
