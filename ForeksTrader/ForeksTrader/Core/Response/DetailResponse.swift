//
//  DetailResponse.swift
//  ForeksTrader
//
//  Created by Murat Can ASLAN on 7.01.2023.
//

import Foundation

struct DetailResponse {
    let l: [L]?
    let z: String?
}

struct L {
    let tke: String?
    let clo: String?
    let pdd: String?
    let las: String?
}
