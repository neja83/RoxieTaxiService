//
//  Router.swift
//  RoxieTaxiService
//
//  Created by Eugene Krapivenko on 29.03.2022.
//

import Foundation

class Router<EndPoint: EndPointType>: NetworkRouter {
    
    private var task: URLSessionTask?
    
    func request(_ router: EndPoint, completion: @escaping NetworkRouterCompletion) {
        let session = URLSession.shared
        
        do {
            let request = try self.buildRequest(from: router)
            
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                
                completion(data, response, error)
            })
                                
        } catch {
            completion(nil, nil, error)
        }
        
        task?.resume()
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
    private func buildRequest(from router: EndPoint) throws -> URLRequest {
        var request = URLRequest(url: router.baseUrl.appendingPathComponent(router.path),
                                cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                timeoutInterval: 10.0)
        
        request.httpMethod = router.httpMethod.rawValue
        
        switch(router.httpTask){
        case .request: request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        return request
    }
}
