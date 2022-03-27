//
//  Service.swift
//  RoxieTaxiService
//
//  Created by Eugene Krapivenko on 25.03.2022.
//

import Foundation
import UIKit

// активные заказы в службе такси

// MARK: - protocols
protocol Service {
    func getList(completion: @escaping ([Contract]?, Error?) -> Void)
    func getPhoto(by name: String, completion: @escaping (UIImage?, Error?) -> Void )
}

// MARK: - implementation
final class TaxiService: Service {
    
    typealias action = ([Contract]?, Error?) -> Void
    
    private var network: NetworkManager = ServiceNetworkManager()
    
    func getList(completion : @escaping action) {
        
        DispatchQueue.global().async {
            self.network.request { data, error in
                DispatchQueue.main.async {
                    if data != nil {
                        completion(data, nil)
                    }
                    if error != nil {
                        completion(nil, error)
                    }
                }
            }
        }
    }
    
    func getPhoto(by name: String, completion: @escaping (UIImage?, Error?) -> Void ) {
        
        DispatchQueue.global().async {
            self.network.photoRequest(name: name) { image, error in
                DispatchQueue.main.async {
                    if image != nil {
                        completion(image, nil)
                    }
                    if error != nil {
                        completion(nil, error)
                    }
                }
            }
        }
    }
}
