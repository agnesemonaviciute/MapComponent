//
//  Location.swift
//
//
//  Created by Agne  on 21/05/2024.
//

import Foundation

public class Location: Equatable {
    
    // MARK: - Declarations
    var id: Int
    var coordinates: Coordinates
    
    // MARK: - Methods
    public init(id: Int, coordinates: Coordinates) {
        self.id = id
        self.coordinates = coordinates
    }
    
    public static func == (lhs: Location, rhs: Location) -> Bool {
        return lhs.id == rhs.id
    }
}
