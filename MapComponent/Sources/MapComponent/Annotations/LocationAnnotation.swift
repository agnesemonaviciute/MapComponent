//
//  LocationAnnotation.swift
//
//
//  Created by Agne  on 21/05/2024.
//

import UIKit
import MapKit

class LocationAnnotation: NSObject, Identifiable, MKAnnotation {
    
    // MARK: - Constants
    static var identifier = "StationAnnotation"
    
    // MARK: - Declarations
    var coordinate: CLLocationCoordinate2D
    var location: Location
    
    // MARK: - Methods -
    init(location: Location) {
        self.location = location
        coordinate = CLLocationCoordinate2D(
            latitude: CLLocationDegrees(location.coordinates.latitude),
            longitude: CLLocationDegrees(location.coordinates.longitude)
        )
    }
}
