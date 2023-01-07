//
//  MainViewController.swift
//  ForeksTrader
//
//  Created by Murat Can ASLAN on 7.01.2023.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .cyan
        
        NetworkManager.shared.getDefaultPage { response, error in
            if let response {
                print(response)
            } else if let error {
                print(error)
            }
        }
    }
}
