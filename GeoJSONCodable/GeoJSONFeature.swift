//
//  GeoJSONFeature.swift
//  PassengerApp
//
//  Created by Guy Kogus on 21/12/2018.
//  Copyright © 2018 Guy Kogus. All rights reserved.
//

import Foundation

enum GeoJSONFeatureIdentifier: Codable, Equatable {
    enum Errors: Error {
        case unknownType
    }

    case string(value: String)
    case int(value: Int)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(Int.self) {
            self = .int(value: value)
        } else if let value = try? container.decode(String.self) {
            self = .string(value: value)
        } else {
            throw Errors.unknownType
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let value):
            try container.encode(value)
        case .int(let value):
            try container.encode(value)
        }
    }
}

struct GeoJSONFeature: Codable, Equatable {
    let id: GeoJSONFeatureIdentifier?
    let geometry: GeoJSONGeometry?
    let properties: JSONObject?
}

struct GeoJSONStaticFeature<Geometry, Properties>: Codable where Geometry: GeoJSONStaticGeometry, Properties: Codable {
    let id: GeoJSONFeatureIdentifier?
    let geometry: Geometry?
    let properties: Properties?
}
