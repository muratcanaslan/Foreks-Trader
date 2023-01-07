//
//  MainResponse.swift
//  ForeksTrader
//
//  Created by Murat Can ASLAN on 7.01.2023.
//

import Foundation

struct MainResponse {
    let mypageDefaults: [Element]?
    let mypage: [List]?
    
    enum CodingKeys: String, CodingKey {
        case element = "mypageDefaults"
        case list = "mypage"
    }
}

struct Element {
    let name: String?
    let key: String?
}

struct List {
    let cod: String?
    let gro: String?
    let tke: String?
    let def: String?
}
