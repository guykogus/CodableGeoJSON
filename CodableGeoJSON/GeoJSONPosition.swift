//
//  GeoJSONCoordinate.swift
//  PassengerApp
//
//  Created by Guy Kogus on 21/12/2018.
//  Copyright © 2018 Guy Kogus. All rights reserved.
//

/// The fundamental geometry construct.
public struct GeoJSONPosition: Hashable {
    /// The longitudinal coordinate.
    public let longitude: Double
    /// The latitudinal coordinate.
    public let latitude: Double
    /// The elevation at the coordinates.
    public let elevation: Double?

    /// Create a new `GeoJSONPosition`
    ///
    /// - Parameters:
    ///   - longitude: The longitudinal coordinate.
    ///   - latitude: The latitudinal coordinate.
    ///   - elevation: The elevation at the coordinates.
    public init(longitude: Double, latitude: Double, elevation: Double? = nil) {
        self.longitude = longitude
        self.latitude = latitude
        self.elevation = elevation
    }
}

// MARK: - Codable

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
