//
//  Stock.swift
//  StockApp
//
//  Created by Иван Лебедев on 25/01/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import UIKit
import Foundation

class Stock {
    
    var companyName: String = ""
    var symbol: String = ""
    var change: Double = 0.0
    var lastPrice: Double = 0.0
    var webSiteUrl: String = ""
    var image: UIImage? = nil
    var isOpened: Int = 0
    var CEO: String = ""
    var industry: String = ""
    var wasLoadedAdditional: Bool = false
    
    init() {}
    
    init(companyName: String, symbol: String, change: Double, lastPrice: Double) {
        self.companyName = companyName
        self.symbol = symbol
        self.change = change
        self.lastPrice = lastPrice
    }
}
