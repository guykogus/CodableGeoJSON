//
//  GeoJSONGeometry.swift
//  PassengerApp
//
//  Created by Guy Kogus on 21/12/2018.
//  Copyright © 2018 Guy Kogus. All rights reserved.
//

import Foundation

typealias LinearRing = [GeoJSONPosition]

protocol GeoJSONStaticGeometry: Codable, Equatable {
    associatedtype Coordinates: Codable

    var coordinates: Coordinates { get }
}

struct PointGeometry: GeoJSONStaticGeometry {
    let coordinates: GeoJSONPosition
}

struct MultiPointGeometry: GeoJSONStaticGeometry {
    let coordinates: [PointGeometry.Coordinates]
}

struct LineStringGeometry: GeoJSONStaticGeometry {
    let coordinates: [GeoJSONPosition]
}

struct MultiLineStringGeometry: GeoJSONStaticGeometry {
    let coordinates: [LineStringGeometry.Coordinates]
}

struct PolygonGeometry: GeoJSONStaticGeometry {
    let coordinates: [LinearRing]
}

struct MultiPolygonGeometry: GeoJSONStaticGeometry {
    let coordinates: [PolygonGeometry.Coordinates]
}

enum GeoJSONGeometry: Equatable {
    case point(coordinates: PointGeometry.Coordinates)
    case multiPoint(coordinates: MultiPointGeometry.Coordinates)
    case lineString(coordinates: LineStringGeometry.Coordinates)
    case multiLineString(coordinates: MultiLineStringGeometry.Coordinates)
    case polygon(coordinates: PolygonGeometry.Coordinates)
    case multiPolygon(coordinates: MultiPolygonGeometry.Coordinates)
    case geometryCollection(geometries: [GeoJSONGeometry])
}

extension GeoJSONGeometry: Codable {
    private enum CodingKeys: String, CodingKey {
        case type
        case coordinates
        case geometries
    }

    private enum GeometryType: String, Codable {
        case point = "Point"
        case multiPoint = "MultiPoint"
        case lineString = "LineString"
        case multiLineString = "MultiLineString"
        case polygon = "Polygon"
        case multiPolygon = "MultiPolygon"
        case geometryCollection = "GeometryCollection"
    }

    init(from decoder: Decoder) throws {
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
            self = .geometryCollection(geometries: try container.decode([GeoJSONGeometry].self, forKey: .geometries))
        }
    }

    func encode(to encoder: Encoder) throws {
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

    var type: String {
        return { () -> GeometryType in
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
        }().rawValue
    }
}
