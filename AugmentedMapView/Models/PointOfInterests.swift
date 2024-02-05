//
//  PointOfInterests.swift
//  AugmentedMapView
//
//  Created by Rajeev TC on 2024/02/04.
//

import Foundation

struct PointOfInterests: Decodable {
    let results: [PoiData]
}

struct PoiData: Decodable {
    let geometry: PoiGeometry
    let icon: URL
    let iconBackgroundColor: String
    let name: String
    let address: String?
}

struct PoiGeometry: Decodable {
    let location: PoiLocation
}

struct PoiLocation: Decodable {
    let lat: Double
    let lng: Double
}

