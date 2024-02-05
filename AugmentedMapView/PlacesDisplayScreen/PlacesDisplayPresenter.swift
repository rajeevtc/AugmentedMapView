//
//  PlacesDisplayPresenter.swift
//  AugmentedMapView
//
//  Created by Rajeev TC on 2024/02/04.
//

import Foundation
import CoreLocation

protocol PlacesDisplayPresenterInput {
    var places: [Place] { get }
    var startedLoadingPOIs: Bool { get set }
    func loadNearbyPoiList(location: CLLocation, radius: Int)
}

protocol PlacesDisplayPresenterOutput {
    func showPoiListOnMap(annotation: PlaceAnnotation)
    func handleError(error: PlacesApiError)
}

class PlacesDisplayPresenter: PlacesDisplayPresenterInput {
    private let view: PlacesDisplayPresenterOutput
    private let model: PlacesDisplayModelInput

    var places = [Place]()
    var startedLoadingPOIs = false

    init(view: PlacesDisplayPresenterOutput, model: PlacesDisplayModelInput) {
        self.view = view
        self.model = model
    }

    func loadNearbyPoiList(location: CLLocation, radius: Int) {
        startedLoadingPOIs = true
        Task {
            do {
                let places = try await model.loadPOIS(location: location, radius: radius)
                await loadAnnotations(places: places)
            } catch let error as PlacesApiError {
                view.handleError(error: error)
            }
        }
    }

    @MainActor
    func loadAnnotations(places: PointOfInterests) {
        places.results.forEach { place in
            let latitude = place.geometry.location.lat
            let longitude = place.geometry.location.lng

            let location = CLLocation(latitude: latitude, longitude: longitude)
            if let place = Place(location: location, name: place.name, address: place.address ?? "") {
                self.places.append(place)
                let annotation = PlaceAnnotation(location: place.location.coordinate, title: place.placeName)
                view.showPoiListOnMap(annotation: annotation)
            }
        }
    }
}
