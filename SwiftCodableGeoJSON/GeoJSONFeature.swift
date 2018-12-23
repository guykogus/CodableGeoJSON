//
//  GeoJSONFeature.swift
//  PassengerApp
//
//  Created by Guy Kogus on 21/12/2018.
//  Copyright © 2018 Guy Kogus. All rights reserved.
//

import Foundation

public struct GeoJSONFeature<Geometry, Properties>: Codable where Geometry: GeoJSONGeometry, Properties: Codable {
    public let id: GeoJSONFeatureIdentifier?
    public let geometry: Geometry?
    public let properties: Properties?
}
