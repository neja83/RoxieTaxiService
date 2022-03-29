//
//  NetworkManager.swift
//  RoxieTaxiService
//
//  Created by Eugene Krapivenko on 25.03.2022.
//

import Foundation
import UIKit

class ServiceNetworkManager {
    
    enum Result<String> {
        case success
        case failure(String)
    }

    enum NetworkResponse: String {
        case success
        case failed = "Network ruquest failed."
    }
    
    private let route = Router<TaxiServiceApi>()
    
    public func getList(_ completion: @escaping ([ActiveContract]?, String?) -> Void) {
        
        route.request(.getList) { [weak self] data, response, error in
            
            if error != nil {
                completion(nil, "Network error")
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self?.handleNetworkResponse(response)
                
                switch result {
                case .success:
                    guard let responseData = data else { completion(nil, "Not data"); return}
                    
                    do {
                        let apiResponse: [ActiveContract]  = try DataParser.convert(data: responseData)
                        completion(apiResponse, nil)
                    } catch {
                        completion(nil, "Can not parse server response")
                    }
                case .failure(let error):
                    completion(nil, error)
                case .none:
                    fatalError()
                }
            }
        }
    }
    
    public func getPhoto(by name: String, _ completion: @escaping (UIImage?, String?) -> Void) {
        
        route.request(.getImage(name: name)) { [weak self] data, response, error in
            
            if error != nil {
                completion(nil, "Network error")
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self?.handleNetworkResponse(response)
                
                switch result {
                case .success:
                    guard let responseData = data else { completion(nil, "Not data"); return}
                    
                    if let image = UIImage(data: responseData) {
                        completion(image, nil)
                    } else {
                        completion(nil, "UIImage create exeption")
                    }
                    
                case .failure(let error): completion(nil, error)
                case .none: fatalError()
                }
            }
        }
    }
    
    func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String> {
        switch response.statusCode {
        case 200...299: return .success
        case 401...600: return .failure(NetworkResponse.failed.rawValue)
        default:
            return .failure(NetworkResponse.failed.rawValue)
        }
    }
}
