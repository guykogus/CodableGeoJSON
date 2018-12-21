//
//  GeoJSONFeatureCollection.swift
//  PassengerApp
//
//  Created by Guy Kogus on 21/12/2018.
//  Copyright © 2018 Guy Kogus. All rights reserved.
//

import Foundation

struct GeoJSONFeatureCollection: Codable, Equatable {
    typealias Feature = GeoJSONFeature

    let features: [Feature]
}

struct GeoJSONStaticFeatureCollection<Geometry, Properties>: Codable where Geometry: GeoJSONStaticGeometry, Properties: Codable {
    typealias Feature = GeoJSONStaticFeature<Geometry, Properties>

    let features: [Feature]
}
