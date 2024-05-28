//
//  LocationClusterAnnotationView.swift
//
//
//  Created by Agne  on 22/05/2024.
//

import UIKit
import MapKit

class LocationClusterAnnotationView: MKAnnotationView {
    
    // MARK: - Declarations
    private let maxAnnotationCountToDisplay: Int = 100
    private let maxAnnotationCountLabel = "99"
    private let expectedCountLabelPointInImage = CGPoint(x: 32.0, y: 9.0)
    
    // MARK: - Methods
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        displayPriority = .required
        collisionMode = .circle
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    func configureImage(
        for clusterAnnotation: MKClusterAnnotation,
        with clusterImage: UIImage
    ) {
        let memberAnnotations = clusterAnnotation.memberAnnotations
        let annotationCountString = memberAnnotations.count < maxAnnotationCountToDisplay ? "\(memberAnnotations.count)" :
        maxAnnotationCountLabel
        setImage(with: clusterImage, annotationCountString: annotationCountString)
    }
    
    private func setImage(with image: UIImage?, annotationCountString: String) {
        guard let image = image else {
            return
        }
        self.image = image.add(drawText: annotationCountString,
                               withAttributes: [:],
                               atPoint: expectedCountLabelPointInImage)
        offSetCenterPoint()
    }
}

