//
//  GeoJSONFeatureCollection.swift
//  PassengerApp
//
//  Created by Guy Kogus on 21/12/2018.
//  Copyright © 2018 Guy Kogus. All rights reserved.
//

import Foundation

public struct GeoJSONFeatureCollection<Geometry, Properties>: Codable where Geometry: GeoJSONGeometry, Properties: Codable {
    public typealias Feature = GeoJSONFeature<Geometry, Properties>

    public let features: [Feature]
}
