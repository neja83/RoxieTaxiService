//
//  Models.swift
//  RoxieTaxiService
//
//  Created by Eugene Krapivenko on 29.03.2022.
//

import Foundation

/**
 Request methods for HTTPTask
 */
enum HTTPMethod: String {
    case POST = "POST"
    case GET  = "GET"
}

/**
 Task for EndPoint
 */
enum HTTPTask {
    case request
}

/**
 Completion for Requests
 */
public typealias NetworkRouterCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?)->()

/**
 Router for requests
 */
protocol NetworkRouter {
    
    associatedtype EndPoint: EndPointType
    
    func request(_ router: EndPoint, completion: @escaping NetworkRouterCompletion)
    func cancel()
}
