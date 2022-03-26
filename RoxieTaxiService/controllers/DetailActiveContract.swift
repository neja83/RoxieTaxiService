//
//  DetailActiveContract.swift
//  RoxieTaxiService
//
//  Created by Eugene Krapivenko on 27.03.2022.
//

import UIKit

class DetailActiveContract: UIViewController {

    @IBOutlet weak var detailLabel: UILabel!
    var activeContract: ActiveContract!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        detailLabel.text = activeContract.vehicle.driverName
    }
    
}
