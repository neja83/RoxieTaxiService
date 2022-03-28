//
//  NetworkManager.swift
//  RoxieTaxiService
//
//  Created by Eugene Krapivenko on 25.03.2022.
//

import Foundation
import UIKit

// MARK: - protocol
protocol NetworkManager {
    var baseUrl: URL { get }
    func request(completion: @escaping ([Contract]?, Error?) -> Void )
    func photoRequest(name: String, completion: @escaping (UIImage?, Error?) -> Void)
}

// MARK: - implementation
final class ServiceNetworkManager: NetworkManager {
    
    // MARK: - Types
    typealias action = ([Contract]?, Error?) -> Void
    typealias action2 = (UIImage?, Error?) -> Void
    
    // MARK: - private
    private let session = URLSession.shared
    
    var baseUrl: URL {
        guard let url = URL(string: "https://www.roxiemobile.ru/careers/test/orders.json") else {
            fatalError()
        }
        return url
    }
    
    func request(completion: @escaping action) {
        let session = URLSession.shared
        
        let task = session.dataTask(with: baseUrl) { data, response, error in
            if let error = error {
                completion(nil, NetworkManagerErorrs.RequestExeption(message: error.localizedDescription))
            }
            
            if let data = data {
                do {
                    let result: [ActiveContract]  = try DataParser.convert(data: data)
                    completion(result, nil)
                } catch(let error) {
                    completion(nil, NetworkManagerErorrs.DataExeption(message: error.localizedDescription))
                }
            }
            
        }
        task.resume()
    }
    
    func photoRequest(name: String, completion: @escaping action2) {
        guard let url = URL(string: "https://www.roxiemobile.ru/careers/test/images/\(name)") else { fatalError() }
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, NetworkManagerErorrs.RequestExeption(message: error.localizedDescription))
            }
            
            if let data = data, let image = UIImage(data: data) {
                completion(image, nil)
            } else {
                completion(nil, NetworkManagerErorrs.DataExeption(message: "UIImage create exeption"))
            }
        }
        
        task.resume()
    }
    
}

enum NetworkManagerErorrs: Error {
    case RequestExeption(message: String)
    case DataExeption(message: String)
}
