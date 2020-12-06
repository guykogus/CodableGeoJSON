//
//  GeoJSONFeatureIdentifier.swift
//  CodableGeoJSON
//
//  Created by Guy Kogus on 21/12/2018.
//  Copyright © 2018 Guy Kogus. All rights reserved.
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
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(String.self) {
            self = .string(value: value)
        } else {
            self = .int(value: try container.decode(Int.self))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let value):
            try container.encode(value)
        case .int(let value):
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
