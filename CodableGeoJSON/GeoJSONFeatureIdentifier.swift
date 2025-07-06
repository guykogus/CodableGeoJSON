//
//  GeoJSONFeatureIdentifier.swift
//  CodableGeoJSON
//
//  Created by Guy Kogus on 21/12/2018.
//  Copyright © 2023 Guy Kogus. All rights reserved.
//

/// The identifier value of a feature
public enum GeoJSONFeatureIdentifier: Hashable {
    /// The identifier as a string value.
    case string(value: String)
    /// The identifier as an integer value.
    case int(value: Int)
}

// MARK: - Codable

extension GeoJSONFeatureIdentifier: Codable {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(String.self) {
            self = .string(value: value)
        } else {
            self = try .int(value: container.decode(Int.self))
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case let .string(value):
            try container.encode(value)
        case let .int(value):
            try container.encode(value)
        }
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension GeoJSONFeatureIdentifier: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self = .int(value: value)
    }
}

// MARK: - ExpressibleByStringLiteral

extension GeoJSONFeatureIdentifier: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .string(value: value)
    }
}
