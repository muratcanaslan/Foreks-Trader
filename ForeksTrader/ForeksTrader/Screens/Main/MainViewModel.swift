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
    
    var cellVMs = [StockCellViewModel]()
    
    var oldValues: [L] = []
    
    private var param: String?
    var initial: Bool = true
    var onSuccess: OnSuccess?
    var onError: OnError?
    var onTimer: OnTimer?
    
    func getList() {
        NetworkManager.shared.getDefaultPage { [weak self] response, error in
            if let stocks = response?.stocks {
                self?.stocks = stocks
                self?.setStcsParameters(with: stocks)
                self?.onTimer?()
            } else if let error {
                self?.onError?(error.rawValue)
            }
        }
    }
    
    func getDetails(with stock: [Stock]) {
        guard let param else { return }
        
        cellVMs = []
        
        NetworkManager.shared.getDetailList(fields: "ddi,las", stcs: param) { [weak self] response, error in
            if let l = response?.l {
                self?.setDetails(with: stock, l: l)
                
                self?.oldValues = l
                
                self?.onSuccess?()
            } else if let error {
                self?.onError?(error.rawValue)
            }
        }
    }
    
    private func setDetails(with stock: [Stock], l: [L]) {
        if initial {
            l.forEach { item in
                guard let stock = stock.first(where: { $0.tke == item.tke}) else { return }
                self.cellVMs.append(.init(stock: stock, newValue: item, isUp: nil))
            }
        } else {
            l.forEach { item in
                guard let stock = stock.first(where: { $0.tke == item.tke}) else { return }
                let oldValue = self.oldValues.first(where: { $0.tke == item.tke})
                let oldLasValue = formatValues(value: oldValue?.las)
                let newLasValue = formatValues(value: item.las)
                let difference = newLasValue - oldLasValue
                var isUp: Bool?
                if difference < 0 {
                    isUp = false
                } else if difference > 0 {
                    isUp = true
                } else {
                    isUp = nil
                }
                let shouldHighlighted: Bool = oldValue?.clo != item.clo
                self.cellVMs.append(.init(stock: stock, newValue: item, shouldHighlighted: shouldHighlighted, isUp: isUp))
            }
        }
        
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
extension String {
    var floatValue: Float { Float(self) ?? 0.0 }
}

extension String {
    static let numberFormatter = NumberFormatter()
    var doubleValue: Double {
        String.numberFormatter.decimalSeparator = "."
        if let result =  String.numberFormatter.number(from: self) {
            return result.doubleValue
        } else {
            String.numberFormatter.decimalSeparator = ","
            if let result = String.numberFormatter.number(from: self) {
                return result.doubleValue
            }
        }
        return 0
    }
}
