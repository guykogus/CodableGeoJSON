//
//  GeoJSONCoordinate.swift
//  PassengerApp
//
//  Created by Guy Kogus on 21/12/2018.
//  Copyright © 2018 Guy Kogus. All rights reserved.
//

import Foundation

public struct GeoJSONPosition: Equatable {
    public let longitude: Double
    public let latitude: Double
    public let elevation: Double?

    init(longitude: Double, latitude: Double, elevation: Double? = nil) {
        self.longitude = longitude
        self.latitude = latitude
        self.elevation = elevation
    }
}

extension GeoJSONPosition: Codable {
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        longitude = try container.decode(Double.self)
        latitude = try container.decode(Double.self)
        elevation = try container.decodeIfPresent(Double.self)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(longitude)
        try container.encode(latitude)
        if let elevation = elevation {
            try container.encode(elevation)
        }
    }
}
