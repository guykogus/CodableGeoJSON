//
//  GeoJSON.swift
//  PassengerApp
//
//  Created by Guy Kogus on 21/12/2018.
//  Copyright © 2023 Guy Kogus. All rights reserved.
//

import SwifterJSON

/// A GeoJSON type.
public enum GeoJSON: Hashable {
    /// A spatially bounded entity.
    public struct Feature: Hashable {
        /// The geometry of the feature.
        public let geometry: Geometry?
        /// Additional properties of the feature.
        public let properties: SwifterJSON.JSON?
        /// The identifier of the feature. May be either a string or integer.
        public let id: GeoJSONFeatureIdentifier?
    }

    /// A list of `Feature` objects.
    public struct FeatureCollection: Hashable {
        /// The features of the collection.
        public let features: [Feature]
    }

    /// A region of space.
    public enum Geometry: Hashable {
        /// A single position.
        case point(coordinates: PointGeometry.Coordinates)
        /// An array of positions.
        case multiPoint(coordinates: MultiPointGeometry.Coordinates)
        /// An array of 2 or more positions.
        case lineString(coordinates: LineStringGeometry.Coordinates)
        /// An array of `lineString` coordinate arrays.
        case multiLineString(coordinates: MultiLineStringGeometry.Coordinates)
        /// An array of linear rings.
        case polygon(coordinates: PolygonGeometry.Coordinates)
        /// An array of `polygon` coordinate arrays.
        case multiPolygon(coordinates: MultiPolygonGeometry.Coordinates)
        /// An array of geometries.
        case geometryCollection(geometries: GeometryCollection.Geometries)
    }

    /// A spatially bounded entity.
    case feature(feature: Feature, boundingBox: [Double]?)
    /// A list of `feature`s.
    case featureCollection(featureCollection: FeatureCollection, boundingBox: [Double]?)
    /// A region of space.
    case geometry(geometry: Geometry, boundingBox: [Double]?)
}

// MARK: - Codable

extension GeoJSON: Codable {
    public enum GeoJSONType: String, Codable {
        case feature = "Feature"
        case featureCollection = "FeatureCollection"
    }

    private enum CodingKeys: String, CodingKey {
        case type
        case bbox
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        let boundingBox = try container.decodeIfPresent([Double].self, forKey: .bbox)
        switch type {
        case GeoJSONType.feature.rawValue:
            self = try .feature(feature: Feature(from: decoder), boundingBox: boundingBox)
        case GeoJSONType.featureCollection.rawValue:
            self = try .featureCollection(featureCollection: FeatureCollection(from: decoder), boundingBox: boundingBox)
        default:
            self = try .geometry(geometry: Geometry(from: decoder), boundingBox: boundingBox)
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case let .feature(feature, boundingBox):
            try container.encodeIfPresent(boundingBox, forKey: .bbox)
            try feature.encode(to: encoder)
        case let .featureCollection(featureCollection, boundingBox):
            try container.encodeIfPresent(boundingBox, forKey: .bbox)
            try featureCollection.encode(to: encoder)
        case let .geometry(geometry, boundingBox):
            try container.encodeIfPresent(boundingBox, forKey: .bbox)
            try geometry.encode(to: encoder)
        }
    }
}

extension GeoJSON.Feature: Codable {
    private enum CodingKeys: String, CodingKey {
        case type
        case geometry
        case properties
        case id
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(GeoJSON.GeoJSONType.self, forKey: .type)
        assert(type == GeoJSON.GeoJSONType.feature)
        geometry = try container.decodeIfPresent(GeoJSON.Geometry.self, forKey: .geometry)
        properties = try container.decodeIfPresent(SwifterJSON.JSON.self, forKey: .properties)
        id = try container.decodeIfPresent(GeoJSONFeatureIdentifier.self, forKey: .id)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(GeoJSON.GeoJSONType.feature, forKey: .type)
        try container.encodeIfPresent(geometry, forKey: .geometry)
        try container.encodeIfPresent(properties, forKey: .properties)
        try container.encodeIfPresent(id, forKey: .id)
    }
}

extension GeoJSON.FeatureCollection: Codable {
    private enum CodingKeys: String, CodingKey {
        case type
        case features
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(GeoJSON.GeoJSONType.self, forKey: .type)
        assert(type == GeoJSON.GeoJSONType.featureCollection)
        features = try container.decode([GeoJSON.Feature].self, forKey: .features)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(GeoJSON.GeoJSONType.featureCollection, forKey: .type)
        try container.encode(features, forKey: .features)
    }
}

extension GeoJSON.Geometry: Codable {
    public enum GeometryType: String, Codable {
        case point = "Point"
        case multiPoint = "MultiPoint"
        case lineString = "LineString"
        case multiLineString = "MultiLineString"
        case polygon = "Polygon"
        case multiPolygon = "MultiPolygon"
        case geometryCollection = "GeometryCollection"
    }

    private enum CodingKeys: String, CodingKey {
        case type
        case coordinates
        case geometries
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(GeometryType.self, forKey: .type)
        switch type {
        case .point:
            self = try .point(coordinates: container.decode(PointGeometry.Coordinates.self, forKey: .coordinates))
        case .multiPoint:
            self = try .multiPoint(coordinates: container.decode(MultiPointGeometry.Coordinates.self, forKey: .coordinates))
        case .lineString:
            self = try .lineString(coordinates: container.decode(LineStringGeometry.Coordinates.self, forKey: .coordinates))
        case .multiLineString:
            self = try .multiLineString(coordinates: container.decode(MultiLineStringGeometry.Coordinates.self, forKey: .coordinates))
        case .polygon:
            self = try .polygon(coordinates: container.decode(PolygonGeometry.Coordinates.self, forKey: .coordinates))
        case .multiPolygon:
            self = try .multiPolygon(coordinates: container.decode(MultiPolygonGeometry.Coordinates.self, forKey: .coordinates))
        case .geometryCollection:
            self = try .geometryCollection(geometries: container.decode([GeoJSON.Geometry].self, forKey: .geometries))
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(geometryType, forKey: .type)
        switch self {
        case let .point(coordinates):
            try container.encode(coordinates, forKey: .coordinates)
        case let .multiPoint(coordinates):
            try container.encode(coordinates, forKey: .coordinates)
        case let .lineString(coordinates):
            try container.encode(coordinates, forKey: .coordinates)
        case let .multiLineString(coordinates):
            try container.encode(coordinates, forKey: .coordinates)
        case let .polygon(coordinates):
            try container.encode(coordinates, forKey: .coordinates)
        case let .multiPolygon(coordinates):
            try container.encode(coordinates, forKey: .coordinates)
        case let .geometryCollection(geometries):
            try container.encode(geometries, forKey: .geometries)
        }
    }

    public var type: String { geometryType.rawValue }

    private var geometryType: GeometryType {
        switch self {
        case .point:
            GeometryType.point
        case .multiPoint:
            GeometryType.multiPoint
        case .lineString:
            GeometryType.lineString
        case .multiLineString:
            GeometryType.multiLineString
        case .polygon:
            GeometryType.polygon
        case .multiPolygon:
            GeometryType.multiPolygon
        case .geometryCollection:
            GeometryType.geometryCollection
        }
    }
}
