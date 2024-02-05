//
//  NetworkManager.swift
//  AugmentedMapView
//
//  Created by Rajeev TC on 2024/02/04.
//

import Foundation
import Combine

struct NetworkManager<T: APITargetType> {

    func fetch<D: Decodable>(
        target: T,
        decoder: D.Type) -> AnyPublisher<D, Error> {
            let url = URL(string: target.baseUrl + target.endPoint)
            var request = URLRequest(url: url!)
            request.httpMethod = target.httpMethod.rawValue
            request.allHTTPHeaderFields = target.headers

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return URLSession.shared.dataTaskPublisher(for: request)
                .map { $0.data }
                .decode(type: D.self, decoder: decoder)
                .eraseToAnyPublisher()
        }
}
