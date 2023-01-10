//
//  ListCell.swift
//  ForeksTrader
//
//  Created by Murat Can ASLAN on 7.01.2023.
//

import UIKit

final class StockCell: UITableViewCell {
    
    static let reuseIdentifier = "StockCell"
    
    @IBOutlet private weak var percentage: UILabel!
    @IBOutlet private weak var price: UILabel!
    @IBOutlet private weak var lastUpdateDate: UILabel!
    @IBOutlet private weak var stockName: UILabel!
    @IBOutlet private weak var statusView: UIView!
    @IBOutlet private weak var statusIcon: UIImageView!
    
    weak var model: StockCellViewModel?
            
    override func awakeFromNib() {
        super.awakeFromNib()
        
        statusView.layer.cornerRadius = 4
        statusView.backgroundColor = .lightGray
        statusIcon.image = nil
    }
    
    func configure(with model: StockCellViewModel) {
        self.model = model
        stockName.text = model.stock?.cod
        percentage.text = model.difference
        price.text = model.price
        lastUpdateDate.text = model.newValue?.clo
        setLeftView()
        highlight()
        
    }
    
    private func highlight() {
        if model?.shouldHighlighted ?? false {
            backgroundColor = .lightGray.withAlphaComponent(0.5)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.backgroundColor = .dark().withAlphaComponent(0.9)

            }
        } else {
            self.backgroundColor = .dark().withAlphaComponent(0.9)
        }
    }
    
    private func setLeftView() {
        if let isUp = model?.isUp {
            DispatchQueue.main.async {
                self.statusIcon.image = isUp ? UIImage(named: "iconUp") : UIImage(named: "iconDown")
                self.statusView.backgroundColor = isUp ? .green : .red
            }
        } else {
            DispatchQueue.main.async {
                self.statusIcon.image = nil
                self.statusView.backgroundColor = .lightGray
            }
        }
    }
}

extension StockCell {
    static func createXib() -> UINib {
        return .init(nibName: StockCell.reuseIdentifier, bundle: nil)
    }
}

class StockCellViewModel {
    var stock: Stock?
    var newValue: L?
    var shouldHighlighted: Bool?
    var price: String?
    var isUp: Bool?
    var difference: String?
    
    init(stock: Stock?,
         newValue: L?,
         shouldHighlighted: Bool? = nil,
         isUp: Bool? = nil,
         difference: String? = nil,
         price: String?
    ) {
        self.stock = stock
        self.isUp = isUp
        self.newValue = newValue
        self.shouldHighlighted = shouldHighlighted
        self.difference = difference
        self.price = price
    }
}
