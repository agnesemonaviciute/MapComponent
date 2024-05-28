//
//  City.swift
//
//
//  Created by Agne  on 27/05/2024.
//

import Foundation

public class City: Decodable, Hashable {
    
    // MARK: - Declarations
    var name: String
    var coordinates: Coordinates
    
    // MARK: - Methods
    public init(name: String, coordinates: Coordinates) {
        self.name = name
        self.coordinates = coordinates
    }
    
    public static func == (lhs: City, rhs: City) -> Bool {
        return lhs.name == rhs.name &&
        lhs.coordinates == rhs.coordinates
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(coordinates)
    }
}
