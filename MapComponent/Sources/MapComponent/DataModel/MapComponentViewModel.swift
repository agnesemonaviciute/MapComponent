//
//  MapComponentViewModel.swift.swift
//
//
//  Created by Agne  on 21/05/2024.
//

import Foundation
import CoreLocation
import MapKit

protocol MapComponentDataModelInterface {
    var selectedLocation: Location? { get }
    func setSelectedLocation(_ location: Location?)
    func isLocationSelected(_ location: Location?) -> Bool
    func maxDistanceBetweenAnnotations(_ annotations: [MKAnnotation]) -> CLLocationDistance
}


public class MapComponentDataModel: MapComponentDataModelInterface {
    
    // MARK: - Declarations
    var selectedLocation: Location?
    private let defaultMaxDistance: CLLocationDistance = 0.0
    
    // MARK: - Methods
    func setSelectedLocation(_ location: Location?) {
        guard location != selectedLocation else {
            return
        }
        selectedLocation = location
    }
    
    func isLocationSelected(_ location: Location?) -> Bool {
        if let selectedLocation = selectedLocation,
           selectedLocation == location {
            return true
        }
        return false
    }
    
    func maxDistanceBetweenAnnotations(_ annotations: [MKAnnotation]) -> CLLocationDistance {
        var maxDistance: CLLocationDistance = defaultMaxDistance
        for index in 0...annotations.count - 2 {
            let firstLocation = CLLocation(latitude: annotations[index].coordinate.latitude,
                                           longitude: annotations[index].coordinate.longitude)
            let secondLocation = CLLocation(latitude: annotations[index + 1].coordinate.latitude,
                                            longitude: annotations[index + 1].coordinate.longitude)
            let distance = firstLocation.distance(from: secondLocation)
            if maxDistance < distance {
                maxDistance = distance
            }
        }
        return maxDistance
    }
}
