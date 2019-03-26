//
//  GeoJSON.swift
//  PassengerApp
//
//  Created by Guy Kogus on 21/12/2018.
//  Copyright © 2018 Guy Kogus. All rights reserved.
//

import CodableJSON

/// A GeoJSON type.
public enum GeoJSON: Equatable {
    /// A spatially bounded entity.
    public struct Feature: Codable, Equatable {
        /// The identifier of the feature. May be either a string or integer.
        public let id: GeoJSONFeatureIdentifier?
        /// The geometry of the feature.
        public let geometry: Geometry?
        /// Additional properties of the feature.
        public let properties: CodableJSON.JSON?
    }

    /// A list of `Feature` objects.
    public struct FeatureCollection: Codable, Equatable {
        /// The features of the collection.
        public let features: [Feature]
    }

    /// A region of space.
    public enum Geometry: Equatable {
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

extension GeoJSON: Codable {
    private enum CodingKeys: String, CodingKey {
        case type
        case bbox
    }

    private enum ObjectType: String, Codable {
        case feature = "Feature"
        case featureCollection = "FeatureCollection"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        let boundingBox = try container.decodeIfPresent([Double].self, forKey: .bbox)
        switch type {
        case ObjectType.feature.rawValue:
            self = .feature(feature: try Feature(from: decoder), boundingBox: boundingBox)
        case ObjectType.featureCollection.rawValue:
            self = .featureCollection(featureCollection: try FeatureCollection(from: decoder), boundingBox: boundingBox)
        default:
            self = .geometry(geometry: try Geometry(from: decoder), boundingBox: boundingBox)
        }
    }

    public func encode(to encoder: Encoder) throws {
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

    private var type: String {
        switch self {
        case .feature(_, _):
            return ObjectType.feature.rawValue
        case .featureCollection(_, _):
            return ObjectType.featureCollection.rawValue
        case .geometry(let geometry, _):
            return geometry.type.rawValue
        }
    }
}

extension GeoJSON.Geometry: Codable {
    fileprivate enum GeometryType: String, Codable {
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
        try container.encode(type, forKey: .type)
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

    fileprivate var type: GeometryType {
        switch self {
        case .point(_):
            return GeometryType.point
        case .multiPoint(_):
            return GeometryType.multiPoint
        case .lineString(_):
            return GeometryType.lineString
        case .multiLineString(_):
            return GeometryType.multiLineString
        case .polygon(_):
            return GeometryType.polygon
        case .multiPolygon(_):
            return GeometryType.multiPolygon
        case .geometryCollection(_):
            return GeometryType.geometryCollection
        }
    }
}
