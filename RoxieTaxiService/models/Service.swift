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
    var name: String { get }
    func getList(completion: @escaping ([Contract]?, String?) -> Void)
    func getPhoto(by name: String, completion: @escaping (UIImage?, String?) -> Void )
}

// MARK: - implementation
final class TaxiService: Service {
    
    static let share: TaxiService = TaxiService()
    
    var name: String = "Активные заказы"
    
    typealias action = ([Contract]?, Error?) -> Void
    
    private var network = ServiceNetworkManager()
    
    private init(){ }
    
    func getList(completion : @escaping ([Contract]?, String?) -> Void) {
        
        DispatchQueue.global().async {
            self.network.getList { data, error in
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
    
    func getPhoto(by name: String, completion: @escaping (UIImage?, String?) -> Void ) {
        
        DispatchQueue.global().async {
            self.network.getPhoto(by: name) { image, error in
                DispatchQueue.main.async {
                    
                    if let image = image {
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
