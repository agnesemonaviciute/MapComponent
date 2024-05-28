//
//  LocationAnnotationView.swift
//
//
//  Created by Agne  on 22/05/2024.
//

import Foundation
import MapKit

class LocationAnnotationView: MKAnnotationView {
    
    override var annotation: MKAnnotation? {
        willSet {
            clusteringIdentifier = "LocationAnnotation"
            displayPriority = .required
        }
    }
    
    func configureImage(_ image: UIImage?) {
        setImage(image)
        offSetCenterPoint()
    }
}
