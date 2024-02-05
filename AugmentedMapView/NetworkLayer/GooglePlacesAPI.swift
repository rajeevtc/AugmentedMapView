//
//  GooglePlacesAPI.swift
//  AugmentedMapView
//
//  Created by Rajeev TC on 2024/02/04.
//

import Foundation
import CoreLocation

enum GooglePlacesAPI {
    case fetchPointOfInterests(location: CLLocation, radius: Int)
}

extension GooglePlacesAPI: APITargetType {
    var baseUrl: String {
        "https://maps.googleapis.com/maps/api/place/"
    }
    
    var endPoint: String {
        switch self {
        case .fetchPointOfInterests(let location, let radius):
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            return "nearbysearch/json?location=\(latitude),\(longitude)&radius=\(radius)&sensor=true&types=establishment&key=\(PlacesDisplayModel.apiKey)"
        }
    }
    
    var headers: [String : String] {
        [:]
    }
    
    var httpMethod: HttpMethod {
        .GET
    }
}
