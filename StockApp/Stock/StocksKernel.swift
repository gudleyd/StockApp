//
//  StocksAPI.swift
//  StockApp
//
//  Created by Иван Лебедев on 25/01/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import UIKit
import Foundation

class StocksKernel {
    
    static let shared = StocksKernel()
    let serverIp = "https://api.iextrading.com/1.0/stock"
    private var stocks: [Stock] = []
    
    init() {}
    
    func takeStocksList(completionHandler: @escaping () -> Void) {
        self.stocks = []
        let url = URL(string: serverIp + "/market/list/infocus")
        if (url == nil) {
            fatalError("Can't create an URL with string \(serverIp + "/market/list/infocus") 0x00000")
        }
        let dataTask = URLSession.shared.dataTask(with: url!) { data, response, error in
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data!)
                let json = jsonObject as! [Any]
                for stockObject in json {
                    let stockJson = stockObject as! [String: Any]
                    let companyName = stockJson["companyName"] as! String
                    let symbol = stockJson["symbol"] as! String
                    let lastPrice = stockJson["latestPrice"] as! Double
                    let change = stockJson["change"] as! Double
                    self.stocks.append(Stock(companyName: companyName, symbol: symbol, change: change, lastPrice: lastPrice))
                }
                DispatchQueue.main.async {
                    completionHandler()
                }
            } catch {
                print(error.localizedDescription, "0x00001")
            }
        }
        dataTask.resume()
    }
    
    func loadAdditionalInfo(forStock: Stock, completionHandler: @escaping (Stock) -> Void) {
        
        let copyStock = forStock
        
        let mainGroup = DispatchGroup()
        
        var imagePath: String? = nil
        
        let imagePathUrl = URL(string: serverIp + "/\(forStock.symbol)/logo")
        if (imagePathUrl == nil) {
            fatalError("Can't create an URL with string \(serverIp + "/\(forStock.symbol)/logo") 0x00001")
        }
        mainGroup.enter()
        let takeImagePath = URLSession.shared.dataTask(with: imagePathUrl!) { data, response, error in
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data!)
                let json = jsonObject as! [String: Any]
                imagePath = json["url"] as? String
                if (imagePath == nil) {
                    print("There is no Image for \(forStock.symbol)")
                } else {
                    mainGroup.enter()
                    let imageUrl = URL(string: imagePath ?? "no url")
                    let loadImage = URLSession.shared.dataTask(with: imageUrl!) { data, response, error in
                        var logoImage: UIImage? = nil
                        if (data == nil) {
                            logoImage = UIImage(named: "no_image")
                        } else {
                            logoImage = UIImage(data: data!)
                        }
                        copyStock.image = logoImage
                        mainGroup.leave()
                    }
                    loadImage.resume()
                }
                mainGroup.leave()
            } catch {
                print(error.localizedDescription, "0x00002")
            }
        }
        takeImagePath.resume()
        mainGroup.wait()
        
        let url = URL(string: serverIp + "/\(forStock.symbol)/company")
        if (url == nil) {
            fatalError("Can't create an URL with string \(serverIp + "/\(forStock.symbol)/company") 0x00003")
        }
        let dataTask = URLSession.shared.dataTask(with: url!) { data, response, error in
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data!)
                let json = jsonObject as! [String: Any]
                copyStock.CEO = json["CEO"] as! String
                copyStock.industry = json["sector"] as! String
                copyStock.webSiteUrl = json["website"] as! String
                DispatchQueue.main.async {
                    completionHandler(copyStock)
                }
            } catch {
                print(error.localizedDescription, "0x00004")
            }
        }
        dataTask.resume()
    }
    
    func stocksToShow(filter: String = "") -> [Stock] {
        /* Хотел сделать поиск, но там оказалось, но акции оказалось очень мало */
        if (filter == "") {
            return stocks
        }
        return []
    }
}
