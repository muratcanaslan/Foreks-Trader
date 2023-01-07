//
//  NetworkManager.swift
//  ForeksTrader
//
//  Created by Murat Can ASLAN on 7.01.2023.
//

import Foundation

protocol ForeksNetworkable {
    var path: String { get }
    
}

enum NetworkError: String, Error {
    case connectionError = "Unable to complete your request. Please check your internet connection"
    case responseError = "Invalid response from the server. Please try again."
    case decodeError = "The data received from the server was invalid. Please try again."
    
}

enum ForeksTarget: ForeksNetworkable {
    var path: String {
        switch self {
        case .main:
            return "ForeksMobileInterviewSettings"
        case .detail:
            return "ForeksMobileInterview"
        }
    }
    
    case main
    case detail
}

final class NetworkManager {
    
    private let baseURLString = "https://sui7963dq6.execute-api.eu-central-1.amazonaws.com/default/"
    
    static let shared = NetworkManager()
    
    private init() { }
    
    func getDefaultPage(completion: @escaping (MainResponse?, NetworkError?) -> Void) {
        guard let url = URL(string: baseURLString + ForeksTarget.main.path) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(nil, .connectionError)
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(nil, .responseError)
                return
            }
            
            guard let data = data else {
                completion(nil, .decodeError)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(MainResponse.self, from: data)
                completion(response, nil)
            } catch {
                completion(nil, .decodeError)
            }
        }
        task.resume()
    }
    /*
     https://sui7963dq6.execute-api.eu-central-1.amazonaws.com/default/ForeksMobileInterview?fields=pdd,las&stcs=GARAN.E.BIST~XU100.I.BIST
     */
}
