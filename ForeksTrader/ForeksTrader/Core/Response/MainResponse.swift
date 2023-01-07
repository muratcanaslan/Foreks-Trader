//
//  MainResponse.swift
//  ForeksTrader
//
//  Created by Murat Can ASLAN on 7.01.2023.
//

import Foundation

struct MainResponse: Codable {
    let elements: [Element]?
    let list: [List]?
    
    enum CodingKeys: String, CodingKey {
        case list = "mypageDefaults"
        case elements = "mypage"
    }
}

struct Element: Codable {
    let name: String?
    let key: String?
}

struct List: Codable {
    let cod: String?
    let gro: String?
    let tke: String?
    let def: String?
}
