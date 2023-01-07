//
//  MainViewModel.swift
//  ForeksTrader
//
//  Created by Murat Can ASLAN on 7.01.2023.
//

import Foundation

typealias OnSuccess = () -> Void
typealias OnError = (String) -> Void
typealias OnLoading = (Bool) -> Void

struct DataSource {
    var section: Section?
    var row: [List]
    
    struct Section {
        var section: Int
        var model: String
    }
}


final class MainViewModel {
    
    var data: [DataSource] = []
    
    var response: MainResponse? {
        didSet {
            onSuccess?()
        }
    }
    
    var onSuccess: OnSuccess?
    var onError: OnError?
    var onLoading: OnLoading?
    
    func getList() {
        
        self.onLoading?(true)
        
        NetworkManager.shared.getDefaultPage { [weak self] response, error in
            
            self?.onLoading?(false)
            
            if let response {
                self?.response = response
            } else if let error {
                self?.onError?(error.rawValue)
            }
        }
    }
}

