//
//  GeoJSON.swift
//  PassengerApp
//
//  Created by Guy Kogus on 21/12/2018.
//  Copyright © 2018 Guy Kogus. All rights reserved.
//

import Foundation

enum GeoJSON: Codable, Equatable {
    private enum CodingKeys: String, CodingKey {
        case type
        case bbox
    }

    enum ObjectType: String, Codable {
        case feature = "Feature"
        case featureCollection = "FeatureCollection"
        case geometry = "Geometry"
    }

    case feature(feature: GeoJSONFeature, boundingBox: [Double]?)
    case featureCollection(featureCollection: GeoJSONFeatureCollection, boundingBox: [Double]?)
    case geometry(geometry: GeoJSONGeometry, boundingBox: [Double]?)

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(ObjectType.self, forKey: .type)
        let boundingBox = try container.decodeIfPresent([Double].self, forKey: .bbox)
        switch type {
        case .feature:
            self = .feature(feature: try GeoJSONFeature(from: decoder), boundingBox: boundingBox)
        case .featureCollection:
            self = .featureCollection(featureCollection: try GeoJSONFeatureCollection(from: decoder), boundingBox: boundingBox)
        case .geometry:
            self = .geometry(geometry: try GeoJSONGeometry(from: decoder), boundingBox: boundingBox)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        switch self {
        case .feature(let feature, let boundingBox):
            try container.encodeIfPresent(boundingBox, forKey: .bbox)
            try feature.encode(to: encoder)
        case .featureCollection(let featureCollection, let boundingBox):
            try container.encodeIfPresent(boundingBox, forKey: .bbox)
            try featureCollection.encode(to: encoder)
        case .geometry(let geometry, let boundingBox):
            try container.encodeIfPresent(boundingBox, forKey: .bbox)
            try geometry.encode(to: encoder)
        }
    }

    var type: ObjectType {
        switch self {
        case .feature(_, _):
            return ObjectType.feature
        case .featureCollection(_, _):
            return ObjectType.featureCollection
        case .geometry(_, _):
            return ObjectType.geometry
        }
    }
}
