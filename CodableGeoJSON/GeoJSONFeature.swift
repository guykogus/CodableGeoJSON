//
//  GeoJSONFeature.swift
//  PassengerApp
//
//  Created by Guy Kogus on 21/12/2018.
//  Copyright © 2018 Guy Kogus. All rights reserved.
//

/// A spatially bounded entity.
public struct GeoJSONFeature<Geometry, Properties>: Codable where Geometry: GeoJSONGeometry, Properties: Codable {
    /// The identifier of the feature. May be either a string or integer.
    public let id: GeoJSONFeatureIdentifier?
    /// The geometry of the feature.
    public let geometry: Geometry?
    /// Additional properties of the feature.
    public let properties: Properties?
}
