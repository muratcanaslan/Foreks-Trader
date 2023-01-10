//
//  DetailResponse.swift
//  ForeksTrader
//
//  Created by Murat Can ASLAN on 7.01.2023.
//

import Foundation

struct DetailResponse: Codable {
    let l: [L]?
    let z: String?
}

struct L: Codable {
    let tke: String?
    let clo: String?
    let pdd: String?
    let las: String?
    let ddi: String?
    let low: String?
    let hig: String?
    let buy: String?
    let sel: String?
    let pdc: String?
    let cei: String?
    let flo: String?
    let gco: String?
}
