//
//  Coordinates.swift
//
//
//  Created by Agne  on 21/05/2024.
//

import Foundation

public class Coordinates: Decodable, Hashable {
    
    // MARK: - Declarations
    var latitude: Double
    var longitude: Double
    
    // MARK: - Methods
    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    public static func == (lhs: Coordinates, rhs: Coordinates) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }
}
