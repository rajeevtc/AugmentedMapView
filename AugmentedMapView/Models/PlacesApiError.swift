//
//  PlacesApiError.swift
//  AugmentedMapView
//
//  Created by Rajeev TC on 2024/02/05.
//

import Foundation

enum PlacesApiError: Error {
    case placesError(ErrorTypes)
    case unknown(Int)

    init(error: Error) {
        let errorCode = (error as NSError).code
        if let error = ErrorTypes(rawValue: errorCode) {
            self = .placesError(error)
        } else {
            self =  .unknown(errorCode)
        }
    }

    enum ErrorTypes: Int {
        case parsingError = 555
        case apiFailure = 500
        case notFound = 404
    }
}
