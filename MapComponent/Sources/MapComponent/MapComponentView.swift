//
//  MapComponentView.swift
//
//
//  Created by Agne  on 22/05/2024.
//

import UIKit
import MapKit

public class MapComponentView: UIView, MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate {
    
    // MARK: - Declarations
    private var mapView: MKMapView!
    private let locationManager = CLLocationManager()
    private var userLocation: CLLocation?
    private var config: MapComponentConfiguration!
    private var dataModel: MapComponentDataModelInterface = MapComponentDataModel()
    
    // MARK: - Methods
    public func configure(with config: MapComponentConfiguration) {
        self.config = config
        
        setupMapView()
        addAnnotations()
        
        if config.shouldShowUserLocation {
            checkLocationServices()
        }
        mapView.isZoomEnabled = config.isZoomEnabled
    }
    
    private func setupMapView() {
        mapView = MKMapView(frame: self.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
        mapView.register(LocationAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(LocationClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        self.addSubview(mapView)
        
        if config.isAllowedToTapMap {
            setupTapOnMap()
        }
    }
    
    // MARK: - MKMapViewDelegate
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let locationAnnotation = annotation as? LocationAnnotation {
            return annotationView(forAnnotation: locationAnnotation)
        } else if let clusterAnnotation = annotation as? MKClusterAnnotation {
            return annotationView(forClusterAnnotation: clusterAnnotation)
        } else {
            return nil
        }
    }
    
    func resetPins() {
        dataModel.setSelectedLocation(nil)
        addAnnotations()
    }
    
    private func annotationView(forAnnotation locationAnnotation: LocationAnnotation) -> MKAnnotationView? {
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier) else {
            return LocationAnnotationView()
        }
        annotationView.annotation = locationAnnotation
        configureImage(ofAnnotationView: annotationView)
        
        if config.isAllowedToTapAnnotations {
            let annotationTap = UITapGestureRecognizer(target: self, action: #selector(tappedAnnotation))
            annotationView.addGestureRecognizer(annotationTap)
        }
        return annotationView
    }
    
    private func annotationView(forClusterAnnotation clusterAnnotation: MKClusterAnnotation) -> MKAnnotationView? {
        guard let clusterAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier) as? LocationClusterAnnotationView else {
            return LocationClusterAnnotationView()
        }
        clusterAnnotationView.annotation = clusterAnnotation
        clusterAnnotationView.configureImage(
            for: clusterAnnotation,
            with: config.clusterImage
        )
        
        if config.isAllowedToTapAnnotations {
            let annotationTap = UITapGestureRecognizer(target: self, action: #selector(tappedClusterAnnotation))
            clusterAnnotationView.addGestureRecognizer(annotationTap)
        }
        return clusterAnnotationView
    }
    
    // MARK: - CLLocationManagerDelegate
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = manager.location?.coordinate else {
            return
        }
        userLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    
    // MARK: - Annotations
    private func addAnnotations() {
        if config.shouldClusterByCities {
            clusterAnnotationsByCities()
        } else {
            let annotations = config.locations.compactMap { LocationAnnotation(location: $0) }
            mapView.removeAnnotations(mapView.annotations)
            mapView.addAnnotations(annotations)
        }
        centerDefaultArea()
    }
    
    // MARK: - Set Region
    private func center(_ location: CLLocation, radius: CLLocationDistance) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: radius,
                                                  longitudinalMeters: radius)
        let mapRect = MKMapRectForCoordinateRegion(region: coordinateRegion)
        mapView.setVisibleMapRect(mapRect, animated: true)
    }
    
    private func center(_ coordinate: CLLocationCoordinate2D) {
        mapView.setCenter(coordinate, animated: true)
    }
    
    // MARK: - Location services
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func checkLocationServices() {
        setupLocationManager()
        checkLocationAuthorization()
    }
    
    private func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            return
        @unknown default:
            return
        }
    }
    
    // MARK: - Tap on map
    private func setupTapOnMap() {
        let singleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onMapTapped))
        singleTapRecognizer.delegate = self
        mapView.addGestureRecognizer(singleTapRecognizer)
    }
    
    @objc private func onMapTapped() {
        config.onMapTapped?()
        dataModel.setSelectedLocation(nil)
        addAnnotations()
    }
    
    // MARK: - Tap on pins
    @objc private func tappedAnnotation(_ sender: UITapGestureRecognizer) {
        guard let annotationView = sender.view as? MKAnnotationView,
              let locationAnnotation = annotationView.annotation as? LocationAnnotation else {
            print("WARNING! Annotation tapped is not a station annotation")
            return
        }
        selectAnnotation(locationAnnotation, shouldZoomIn: false)
    }
    
    @objc private func tappedClusterAnnotation(_ sender: UITapGestureRecognizer) {
        guard let annotationView = sender.view as? MKAnnotationView,
              let clusterAnnotation = annotationView.annotation as? MKClusterAnnotation else {
            print("WARNING! Unexpected view in sender")
            return
        }
        zoomInClusterAnnotation(clusterAnnotation)
    }
    
    // MARK: - Helpers
    private func configureImage(ofAnnotationView annotationView: MKAnnotationView?) {
        guard let annotationView = annotationView as? LocationAnnotationView,
              let annotation = annotationView.annotation as? LocationAnnotation else {
            return
        }
        if dataModel.isLocationSelected(annotation.location) {
            annotationView.configureImage(config.selectedAnnotationImage)
        } else {
            annotationView.configureImage(config.defaultAnnotationImage)
        }
    }
    
    private func centerDefaultArea() {
        let location = CLLocation(
            latitude: config.initialLocation.coordinates.latitude,
            longitude: config.initialLocation.coordinates.longitude
        )
        center(location, radius: config.radius * MapConstants.regionRadiusInMeters)
    }
    
    private func setupMapCornerRadius(with cornerRadius: CGFloat) {
        mapView.layer.cornerRadius = cornerRadius
        layer.cornerRadius = cornerRadius
    }
    
    private func zoomInClusterAnnotation(_ clusterAnnotation: MKClusterAnnotation) {
        let memberAnnotations = clusterAnnotation.memberAnnotations
        let maxDistance = dataModel.maxDistanceBetweenAnnotations(memberAnnotations)
        center(
            CLLocation(latitude: clusterAnnotation.coordinate.latitude,
                       longitude: clusterAnnotation.coordinate.longitude),
            radius: maxDistance
        )
    }
    
    private func selectAnnotation(_ annotation: LocationAnnotation, shouldZoomIn: Bool) {
        dataModel.setSelectedLocation(annotation.location)
        guard let selectedLocation = dataModel.selectedLocation,
              let selectedLocationLatitude = dataModel.selectedLocation?.coordinates.latitude,
              let selectedLocationLongitude = dataModel.selectedLocation?.coordinates.longitude else {
            return
        }
        addAnnotations()
        if shouldZoomIn {
            center(
                CLLocation(latitude: selectedLocationLatitude,
                           longitude: selectedLocationLongitude),
                radius: MapConstants.smallRadius * MapConstants.regionRadiusInMeters
            )
        } else {
            center(CLLocationCoordinate2D(latitude: selectedLocationLatitude,
                                          longitude: selectedLocationLongitude))
        }
        config.onLocationTapped?(selectedLocation)
    }
    
    private func MKMapRectForCoordinateRegion(region: MKCoordinateRegion) -> MKMapRect {
        let topLeft = CLLocationCoordinate2D(
            latitude: region.center.latitude + (region.span.latitudeDelta / 2.0),
            longitude: region.center.longitude - (region.span.longitudeDelta / 2.0)
        )
        
        let bottomRight = CLLocationCoordinate2D(
            latitude: region.center.latitude - (region.span.latitudeDelta / 2.0),
            longitude: region.center.longitude + (region.span.longitudeDelta / 2.0)
        )
        
        let topLeftPoint = MKMapPoint(topLeft)
        let bottomRightPoint = MKMapPoint(bottomRight)
        
        let rect = MKMapRect(
            origin: MKMapPoint(x: min(topLeftPoint.x, bottomRightPoint.x), y: min(topLeftPoint.y, bottomRightPoint.y)),
            size: MKMapSize(width: fabs(topLeftPoint.x - bottomRightPoint.x), height: fabs(topLeftPoint.y - bottomRightPoint.y))
        )
        
        return rect
    }
    
    private func clusterAnnotationsByCities() {
        let cities = config.cities
        var annotations: [LocationAnnotation] = []
        
        for city in cities {
            let cityLocation = CLLocation(latitude: city.coordinates.latitude, longitude: city.coordinates.longitude)
            let nearbyLocations = config.locations.filter {
                let location = CLLocation(latitude: $0.coordinates.latitude, longitude: $0.coordinates.longitude)
                return location.distance(from: cityLocation) < config.defaultCityRadius
            }
            
            if !nearbyLocations.isEmpty {
                let cityAnnotation = LocationAnnotation(location: Location(
                    id: city.hashValue,
                    coordinates: Coordinates(latitude: city.coordinates.latitude, longitude: city.coordinates.longitude)
                ))
                annotations.append(cityAnnotation)
            }
        }
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(annotations)
    }
}
