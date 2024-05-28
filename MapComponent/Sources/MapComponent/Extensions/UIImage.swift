//
//  UIImage.swift
//
//
//  Created by Agne  on 22/05/2024.
//

import UIKit

extension UIImage {
    
    func add(drawText text: String, withAttributes attributes: [NSAttributedString.Key: Any], atPoint point: CGPoint) -> UIImage {
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        draw(in: CGRect(origin: CGPoint.zero, size: size))
        
        let rect = CGRect(origin: point, size: size)
        text.draw(in: rect, withAttributes: attributes)
        
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return UIImage()
        }
        UIGraphicsEndImageContext()
        return newImage
    }
}
