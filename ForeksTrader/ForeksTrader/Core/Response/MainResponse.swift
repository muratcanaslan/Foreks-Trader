//
//  MainResponse.swift
//  ForeksTrader
//
//  Created by Murat Can ASLAN on 7.01.2023.
//

import Foundation

struct MainResponse: Codable {
    let elements: [Element]?
    let stocks: [Stock]?
    
    enum CodingKeys: String, CodingKey {
        case stocks = "mypageDefaults"
        case elements = "mypage"
    }
}

struct Element: Codable {
    let name: String
    let key: String
}

struct Stock: Codable {
    let cod: String
    let gro: String
    let tke: String
    let def: String
}

