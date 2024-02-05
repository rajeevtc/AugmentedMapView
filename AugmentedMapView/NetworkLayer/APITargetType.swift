//
//  APITargetType.swift
//  AugmentedMapView
//
//  Created by Rajeev TC on 2024/02/04.
//

import Foundation

protocol APITargetType {
    var baseUrl: String { get }
    var endPoint: String { get }
    var headers: [String: String] { get }
    var httpMethod: HttpMethod { get }
}

enum HttpMethod: String {
    case GET
    case POST
}
