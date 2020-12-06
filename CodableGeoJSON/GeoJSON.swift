//
//  GeoJSON.swift
//  PassengerApp
//
//  Created by Guy Kogus on 21/12/2018.
//  Copyright © 2018 Guy Kogus. All rights reserved.
//

import CodableJSON

/// A GeoJSON type.
public enum GeoJSON: Hashable {
    /// A spatially bounded entity.
    public struct Feature: Hashable {
        /// The geometry of the feature.
        public let geometry: Geometry?
        /// Additional properties of the feature.
        public let properties: CodableJSON.JSON?
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

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        let boundingBox = try container.decodeIfPresent([Double].self, forKey: .bbox)
        switch type {
        case GeoJSONType.feature.rawValue:
            self = .feature(feature: try Feature(from: decoder), boundingBox: boundingBox)
        case GeoJSONType.featureCollection.rawValue:
            self = .featureCollection(featureCollection: try FeatureCollection(from: decoder), boundingBox: boundingBox)
        default:
            self = .geometry(geometry: try Geometry(from: decoder), boundingBox: boundingBox)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
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
}

extension GeoJSON.Feature: Codable {
    private enum CodingKeys: String, CodingKey {
        case type
        case geometry
        case properties
        case id
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(GeoJSON.GeoJSONType.self, forKey: .type)
        assert(type == GeoJSON.GeoJSONType.feature)
        geometry = try container.decodeIfPresent(GeoJSON.Geometry.self, forKey: .geometry)
        properties = try container.decodeIfPresent(CodableJSON.JSON.self, forKey: .properties)
        id = try container.decodeIfPresent(GeoJSONFeatureIdentifier.self, forKey: .id)
    }

    public func encode(to encoder: Encoder) throws {
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

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(GeoJSON.GeoJSONType.self, forKey: .type)
        assert(type == GeoJSON.GeoJSONType.featureCollection)
        features = try container.decode([GeoJSON.Feature].self, forKey: .features)
    }

    public func encode(to encoder: Encoder) throws {
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

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(GeometryType.self, forKey: .type)
        switch type {
        case .point:
            self = .point(coordinates: try container.decode(PointGeometry.Coordinates.self, forKey: .coordinates))
        case .multiPoint:
            self = .multiPoint(coordinates: try container.decode(MultiPointGeometry.Coordinates.self, forKey: .coordinates))
        case .lineString:
            self = .lineString(coordinates: try container.decode(LineStringGeometry.Coordinates.self, forKey: .coordinates))
        case .multiLineString:
            self = .multiLineString(coordinates: try container.decode(MultiLineStringGeometry.Coordinates.self, forKey: .coordinates))
        case .polygon:
            self = .polygon(coordinates: try container.decode(PolygonGeometry.Coordinates.self, forKey: .coordinates))
        case .multiPolygon:
            self = .multiPolygon(coordinates: try container.decode(MultiPolygonGeometry.Coordinates.self, forKey: .coordinates))
        case .geometryCollection:
            self = .geometryCollection(geometries: try container.decode([GeoJSON.Geometry].self, forKey: .geometries))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(geometryType, forKey: .type)
        switch self {
        case .point(let coordinates):
            try container.encode(coordinates, forKey: .coordinates)
        case .multiPoint(let coordinates):
            try container.encode(coordinates, forKey: .coordinates)
        case .lineString(let coordinates):
            try container.encode(coordinates, forKey: .coordinates)
        case .multiLineString(let coordinates):
            try container.encode(coordinates, forKey: .coordinates)
        case .polygon(let coordinates):
            try container.encode(coordinates, forKey: .coordinates)
        case .multiPolygon(let coordinates):
            try container.encode(coordinates, forKey: .coordinates)
        case .geometryCollection(let geometries):
            try container.encode(geometries, forKey: .geometries)
        }
    }

    public var type: String { geometryType.rawValue }

    private var geometryType: GeometryType {
        switch self {
        case .point:
            return GeometryType.point
        case .multiPoint:
            return GeometryType.multiPoint
        case .lineString:
            return GeometryType.lineString
        case .multiLineString:
            return GeometryType.multiLineString
        case .polygon:
            return GeometryType.polygon
        case .multiPolygon:
            return GeometryType.multiPolygon
        case .geometryCollection:
            return GeometryType.geometryCollection
        }
    }
}
