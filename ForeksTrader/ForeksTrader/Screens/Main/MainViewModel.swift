//
//  MainViewModel.swift
//  ForeksTrader
//
//  Created by Murat Can ASLAN on 7.01.2023.
//

import Foundation

typealias OnSuccess = () -> Void
typealias OnError = (String) -> Void
typealias OnTimer = () -> Void

final class MainViewModel {
    
    var stocks = [Stock]()
    var elements = [Element]()
    
    var cellVMs = [StockCellViewModel]()
    
    var oldValues: [L] = []
    
    private var param: String?
    var initial: Bool = true
    var onSuccess: OnSuccess?
    var onError: OnError?
    var onTimer: OnTimer?
    var leftTitle = "las"
    private let rightTitle = "ddi"
        
    func getList() {
        NetworkManager.shared.getDefaultPage { [weak self] response, error in
            if let stocks = response?.stocks {
                self?.stocks = stocks
                self?.elements = response?.elements ?? []
                self?.setStcsParameters(with: stocks)
                self?.onTimer?()
            } else if let error {
                print(error.rawValue)
                self?.onError?(error.rawValue)
            }
        }
    }
    
    func getDetails(with stock: [Stock]) {
        guard let param else { return }
        
        cellVMs = []
        
        let detailListRequestParameter = "\(leftTitle),\(rightTitle)"
        NetworkManager.shared.getDetailList(fields: detailListRequestParameter, stcs: param) { [weak self] response, error in
            if let l = response?.l {
                self?.setDetails(with: stock, l: l)
                
                self?.oldValues = l
                
                self?.onSuccess?()
            } else if let error {
                print(error.rawValue)
                self?.onError?(error.rawValue)
            }
        }
    }
    
    private func setDetails(with stock: [Stock], l: [L]) {
        if initial {
            l.forEach { item in
                guard let stock = stock.first(where: { $0.tke == item.tke}) else { return }
                self.cellVMs.append(.init(stock: stock, newValue: item, difference: "%0", price: item.las))
            }
        } else {
            l.forEach { item in
                guard let stock = stock.first(where: { $0.tke == item.tke}) else { return }
                let oldValue = self.oldValues.first(where: { $0.tke == item.tke})
                let oldLasValue = formatValues(value: oldValue?.las)
                let newLasValue = formatValues(value: item.las)
                let difference = ((newLasValue - oldLasValue)/oldLasValue)*100
                let price = price(item: item)
                
                var isUp: Bool?
                if difference < 0 {
                    isUp = false
                } else if difference > 0 {
                    isUp = true
                } else {
                    isUp = nil
                }
                
                let shouldHighlighted: Bool = oldValue?.clo != item.clo
                self.cellVMs.append(.init(stock: stock, newValue: item, shouldHighlighted: shouldHighlighted, isUp: isUp, difference: "%\(difference.stringValue)", price: price))
            }
        }
        
    }
    
    private func price(item: L) -> String? {
        let price: String?
        if leftTitle == "las" {
            price = item.las
        }
        else if leftTitle == "pdd" {
            price = item.pdd
        }
        else if leftTitle == "ddi" {
            price = item.ddi
        }
        else if leftTitle == "low" {
            price = item.low
        }
        else if leftTitle == "hig" {
            price = item.hig
        }
        else if leftTitle == "buy" {
            price = item.buy
        }
        else if leftTitle == "sel" {
            price = item.sel
        }
        else if leftTitle == "cei" {
            price = item.cei
        }
        else if leftTitle == "flo" {
            price = item.flo
        }
        else if leftTitle == "gco" {
            price = item.gco
        } else {
            price = item.las
        }
        return price
    }
    private func formatValues(value: String?) -> Float {
        guard let value else { return 0.0 }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = ","
        formatter.groupingSeparator = "."
        formatter.allowsFloats = true
        guard let number = formatter.number(from: value)?.floatValue else { return 0.0}
        return number
    }
    
    private func setStcsParameters(with stcs: [Stock]) {
        let stcs: [String] = stcs.map({ $0.tke })
        let param: String = stcs.joined(separator: "~")
        self.param = param
    }
}


// MARK: - Casting
private extension String {
    var floatValue: Float { Float(self) ?? 0.0 }
}

private extension Float {
    var stringValue: String { .init(format: "%1.2f", self) }
}
