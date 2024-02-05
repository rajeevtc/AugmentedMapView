//
//  PlaceAnnotation.swift
//  AugmentedMapView
//
//  Created by Rajeev TC on 2024/02/04.
//

import Foundation
import MapKit

class PlaceAnnotation: NSObject, MKAnnotation {
  let coordinate: CLLocationCoordinate2D
  let title: String?

  init(location: CLLocationCoordinate2D, title: String) {
    self.coordinate = location
    self.title = title
    super.init()
  }
}
