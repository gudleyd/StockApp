//
//  StockTableViewCell.swift
//  StockApp
//
//  Created by Иван Лебедев on 25/01/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import UIKit

let COLOR_POSITIVE_CHANGE = UIColor(red: 139/255, green: 195/255, blue: 74/255, alpha: 1.0)
let COLOR_NEGATIVE_CHANGE = UIColor(red: 211/255, green: 47/255, blue: 47/255, alpha: 1.0)

class StockTableViewCell: UITableViewCell {

    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var changeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func load(from: Stock) {
        self.symbolLabel.text = from.symbol
        self.companyNameLabel.text = from.companyName
        self.priceLabel.text = String(from.lastPrice) + " $"
        self.changeLabel.text = (from.change >= 0 ? "+" : "") + String(from.change) + " $"
        if (from.change >= 0) {
            changeLabel.backgroundColor = COLOR_POSITIVE_CHANGE
        } else {
            changeLabel.backgroundColor = COLOR_NEGATIVE_CHANGE
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
