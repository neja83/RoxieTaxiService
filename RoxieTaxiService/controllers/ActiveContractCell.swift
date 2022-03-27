//
//  ActiveContractCell.swift
//  RoxieTaxiService
//
//  Created by Eugene Krapivenko on 27.03.2022.
//

import UIKit

class ActiveContractCell: UITableViewCell {
    
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var currency: UILabel!
    
    @IBOutlet weak var fromCity: UILabel!
    @IBOutlet weak var fromAddress: UILabel!
    
    @IBOutlet weak var toAddress: UILabel!
    @IBOutlet weak var toCity: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
