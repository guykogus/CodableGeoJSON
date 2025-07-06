//
//  GeoJSONFeatureCollection.swift
//  PassengerApp
//
//  Created by Guy Kogus on 21/12/2018.
//  Copyright © 2023 Guy Kogus. All rights reserved.
//

/// A list of `GeoJSONFeature` objects.
public struct GeoJSONFeatureCollection<Geometry, Properties>: Codable, Sendable where Geometry: GeoJSONGeometry, Properties: Codable, Properties: Sendable {
    public typealias Feature = GeoJSONFeature<Geometry, Properties>

    /// The features of the collection.
    public let features: [Feature]
}
