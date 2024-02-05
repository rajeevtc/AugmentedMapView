//
//  Places.swift
//  AugmentedMapView
//
//  Created by Rajeev TC on 2024/02/04.
//

import Foundation
import CoreLocation
import HDAugmentedReality

class Place: ARAnnotation {
    let placeName: String
    var address: String

    var infoText: String {
        let info = "Address: \(placeName)"
        return info
    }

    init?(location: CLLocation, name: String, address: String) {
        self.placeName = name
        self.address = address
        super.init(identifier: placeName, title: name, location: location)
    }

    override var description: String {
        return placeName
    }
}
