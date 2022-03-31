//
//  Router.swift
//  RoxieTaxiService
//
//  Created by Eugene Krapivenko on 29.03.2022.
//

import Foundation
import UIKit

class Router<EndPoint: EndPointType>: NetworkRouter {
    
    private var task: URLSessionTask?
    private let cache = URLCache.shared
    private var lifeStack: [(key: String, value: Date)] = []
    private let lifeTime: Int = 10
    
    func request(_ router: EndPoint, completion: @escaping NetworkRouterCompletion) {
        let session = URLSession.shared
        
        do {
            let request = try self.buildRequest(from: router)
            
            if router.cachingRequest, isCached(for: request), let data = cache.cachedResponse(for: request)?.data  {
                completion(data, HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil), nil)
            } else {
                task = session.dataTask(with: request, completionHandler: { [weak self] data, response, error in
                    if router.cachingRequest, let data = data, let response = response {
                        self?.cache.storeCachedResponse(CachedURLResponse(response: response, data: data), for: request)
                        self?.putInLifeStack(with: response.url!.absoluteString)
                    }
                    completion(data, response, error)
                })
            }
                                
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

private extension Router {
    
    private func putInLifeStack(with key: String) {
        lifeStack.append((key, Date().adding(minutes: lifeTime)))
    }
    
    private func isCached(for request: URLRequest) -> Bool {
        
        let key = request.url!.absoluteString
        
        if let index = lifeStack.firstIndex(where: { $0.key == key }) {
            if lifeStack[index].value > Date () {
                return true
            } else {
                lifeStack.remove(at: index)
                cache.removeCachedResponse(for: request)
                return false
            }
        } else {
            return false
        }
    }
}
