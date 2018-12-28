//
//  GeoJSONFeatureIdentifier.swift
//  CodableGeoJSON
//
//  Created by Guy Kogus on 21/12/2018.
//  Copyright © 2018 Guy Kogus. All rights reserved.
//

import Foundation

public enum GeoJSONFeatureIdentifier: Equatable {
    case string(value: String)
    case int(value: Int)
}

extension GeoJSONFeatureIdentifier: Codable {
    private enum Errors: Error {
        case unknownType
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(String.self) {
            self = .string(value: value)
        } else if let value = try? container.decode(Int.self) {
            self = .int(value: value)
        } else {
            throw Errors.unknownType
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
