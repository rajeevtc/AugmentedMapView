//
//  PlacesLoader.swift
//  AugmentedMapView
//
//  Created by Rajeev TC on 2024/02/04.
//

import Foundation
import CoreLocation
import Combine

protocol PlacesDisplayModelInput {
    func loadPOIS(location: CLLocation, radius: Int) async throws -> PointOfInterests
}

class PlacesDisplayModel: PlacesDisplayModelInput {
    static let apiKey = "AIzaSyCP2wxAZPIDXz668OBi7MHYDUnVh-nsqVk"
    private var cancellables = Set<AnyCancellable>()

    func loadPOIS(location: CLLocation, radius: Int = 30) async throws -> PointOfInterests {
        try await withCheckedThrowingContinuation { continuation in
            let manager = NetworkManager<GooglePlacesAPI>()
            manager.fetch(target: .fetchPointOfInterests(location: location, radius: radius), decoder: PointOfInterests.self)
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        let error = PlacesApiError(error: error)
                        continuation.resume(throwing: error)
                    case .finished:
                        print("Finished")
                    }
                } receiveValue: { places in
                    continuation.resume(returning: places)
                }.store(in: &cancellables)
        }
    }
}
