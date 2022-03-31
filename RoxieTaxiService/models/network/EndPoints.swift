//
//  EndPoints.swift
//  RoxieTaxiService
//
//  Created by Eugene Krapivenko on 29.03.2022.
//

import Foundation

/**
 Description API of server
 */
protocol EndPointType {
    var baseUrl : URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var httpTask: HTTPTask { get }
    var cachingRequest: Bool { get }
}

// MARK: - implementation
enum TaxiServiceApi {
    case getList
    case getImage(name: String)
}

extension TaxiServiceApi: EndPointType {
    var baseUrl: URL {
        guard let url = URL(string: "https://www.roxiemobile.ru/careers/test") else { fatalError() }
        return url
    }
    
    var path: String {
        switch(self) {
        case .getList: return "/orders.json"
        case .getImage(let byName): return "/images/\(byName)"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch(self) {
        case .getList: return .GET
        case .getImage: return .GET
        }
    }
    
    var httpTask: HTTPTask {
        switch(self){
        case .getList: return .request
        case .getImage: return .request
        }
    }
    
    var cachingRequest: Bool {
        switch(self){
        case .getList: return false
        case .getImage: return true
        }
    }
}
