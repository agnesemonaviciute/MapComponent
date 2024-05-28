//
//  MKAnnotationView.swift
//
//
//  Created by Agne  on 22/05/2024.
//

import UIKit
import MapKit

extension MKAnnotationView {
    func offSetCenterPoint() {
        if let image = self.image {
            centerOffset = CGPoint(x: 0.0, y: -image.size.height / 2.0)
        } else {
            centerOffset = CGPoint(x: 0.0, y: 0.0)
        }
    }
    
    func setImage(_ newImage: UIImage?) {
        if #available(iOS 14.0, *) {
            guard let image = newImage, let imageLayer: CALayer = self.layer.sublayers?.first else {
                self.image = newImage
                return
            }
            
            let animation: CABasicAnimation = CABasicAnimation(keyPath: "contents")
            animation.fromValue = imageLayer.contents
            animation.toValue = image.cgImage
            animation.fillMode = .backwards
            animation.timingFunction = CAMediaTimingFunction(name: .default)
            animation.duration = 0.25
            CATransaction.begin()
            CATransaction.setValue(true, forKey: kCATransactionDisableActions)
            self.image = image
            CATransaction.commit()
            imageLayer.add(animation, forKey: "contents")
        } else {
            self.image = newImage
        }
    }
}
