//
//  MapComponentConfiguration.swift
//
//
//  Created by Agne  on 21/05/2024.
//

import UIKit
import CoreLocation

/*
 To cluster by cities:
 1. Set shouldClusterByCities to true.
 2. Assign cities to config.cities.
 3. Set defaultCityRadius in meters.
 */

public class MapComponentConfiguration {
    
    // MARK: - Declarations
    var initialLocation: Location
    var locations: [Location] = []
    var isZoomEnabled: Bool = true
    var shouldShowUserLocation: Bool = true
    var isAllowedToTapAnnotations: Bool = true
    var isAllowedToTapMap: Bool = true
    var defaultAnnotationImage: UIImage
    var selectedAnnotationImage: UIImage?
    var clusterImage: UIImage
    var radius: CLLocationDistance = MapConstants.defaultRadius
    var shouldClusterByCities: Bool = false
    var cities: [City] = []
    var defaultCityRadius: CLLocationDistance = MapConstants.defaultCityRadius
    var onLocationTapped: ((Location) -> Void)?
    var onMapTapped: (() -> Void)?
    
    // MARK: - Methods
    public init(initialLocation: Location,
                locations: [Location],
                isZoomEnabled: Bool = true,
                shouldShowUserLocation: Bool = true,
                isAllowedToTapAnnotations: Bool = true,
                isAllowedToTapMap: Bool = true,
                defaultAnnotationImage: UIImage,
                selectedAnnotationImage: UIImage,
                clusterImage: UIImage,
                radius: CLLocationDistance = MapConstants.defaultRadius,
                shouldClusterByCities: Bool = false,
                cities: [City] = [],
                defaultCityRadius: CLLocationDistance = MapConstants.defaultCityRadius,
                onLocationTapped: ((Location) -> Void)? = nil,
                onMapTapped: (() -> Void)? = nil) {
        
        self.initialLocation = initialLocation
        self.locations = locations
        self.isZoomEnabled = isZoomEnabled
        self.shouldShowUserLocation = shouldShowUserLocation
        self.isAllowedToTapAnnotations = isAllowedToTapAnnotations
        self.isAllowedToTapMap = isAllowedToTapMap
        self.defaultAnnotationImage = defaultAnnotationImage
        self.selectedAnnotationImage = selectedAnnotationImage
        self.clusterImage = clusterImage
        self.radius = radius
        self.shouldClusterByCities = shouldClusterByCities
        self.cities = cities
        self.defaultCityRadius = defaultCityRadius
        self.onLocationTapped = onLocationTapped
        self.onMapTapped = onMapTapped
    }
}
