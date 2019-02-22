//
//  ViewController.swift
//  StockApp
//
//  Created by Иван Лебедев on 25/01/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var stocksToShow: [Stock] = []
    let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    let activityIndicatorForBar = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    var barActivityIndicator: UIBarButtonItem? = nil
    
    var isLoading: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        
        self.navigationItem.setRightBarButton(UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(updateStocks)), animated: false)
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
        self.title = "Stocks"
        
        loadStocks()
    }
    
    func loadStocks() {
        if (isLoading) {
            return
        }
        if (Reachability.shared.isConnectedToNetwork()) {
            isLoading = true
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            self.tableView.alpha = 0
            StocksKernel.shared.takeStocksList(completionHandler: {
                self.stocksToShow = StocksKernel.shared.stocksToShow()
                self.tableView.reloadData()
                self.tableView.alpha = 1
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.isLoading = false
            })
        } else {
            let alert = UIAlertController(title: "No Internet Connection", message: "Check your internet connection and repeat an action", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in}))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func updateStocks() {
        loadStocks()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.stocksToShow.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + stocksToShow[section].isOpened
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let cell = Bundle.main.loadNibNamed("StockTableViewCell", owner: self, options: nil)?.first as! StockTableViewCell
            cell.load(from: stocksToShow[indexPath.section])
            return cell
        } else {
            let cell = Bundle.main.loadNibNamed("AdditionalTableViewCell", owner: self, options: nil)?.first as! AdditionalTableViewCell
            cell.load(from: stocksToShow[indexPath.section])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 0) {
            return 60
        }
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (stocksToShow[indexPath.section].wasLoadedAdditional) {
            stocksToShow[indexPath.section].isOpened = 1 - stocksToShow[indexPath.section].isOpened
            let section = IndexSet(integer: indexPath.section)
            self.tableView.reloadSections(section, with: .none)
        } else {
            if (Reachability.shared.isConnectedToNetwork()) {
                self.barActivityIndicator = UIBarButtonItem(customView: activityIndicatorForBar)
                self.navigationItem.setRightBarButton(barActivityIndicator, animated: false)
                activityIndicatorForBar.startAnimating()
                StocksKernel.shared.loadAdditionalInfo(forStock: self.stocksToShow[indexPath.section], completionHandler: { stock in
                    self.stocksToShow[indexPath.section] = stock
                    self.stocksToShow[indexPath.section].wasLoadedAdditional = true
                    self.stocksToShow[indexPath.section].isOpened = 1 - self.stocksToShow[indexPath.section].isOpened
                    let section = IndexSet(integer: indexPath.section)
                    self.tableView.reloadSections(section, with: .none)
                    self.navigationItem.setRightBarButton(UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(self.updateStocks)), animated: false)
                })
            } else {
                let section = IndexSet(integer: indexPath.section)
                self.tableView.reloadSections(section, with: .none)
                let alert = UIAlertController(title: "No Internet Connection", message: "Check your internet connection and repeat an action", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in}))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
 
}

