//
//  AdditionalTableViewCell.swift
//  StockApp
//
//  Created by Иван Лебедев on 25/01/2019.
//  Copyright © 2019 Иван Лебедев. All rights reserved.
//

import UIKit

class AdditionalTableViewCell: UITableViewCell {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var urlButton: UIButton!
    @IBOutlet weak var industryLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var CEOLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    @IBAction func urlButtonTapped(_ sender: UIButton) {
        guard let url = URL(string: urlButton.titleLabel?.text ?? "default.com") else {
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    func load(from: Stock) {
        if (from.image != nil) {
            logoImageView.image = from.image
        } else {
            logoImageView.image = UIImage(named: "no_image")
        }
        CEOLabel.text = from.CEO
        industryLabel.text = from.industry
        urlButton.setTitle(from.webSiteUrl, for: .normal)
    }
    
}
