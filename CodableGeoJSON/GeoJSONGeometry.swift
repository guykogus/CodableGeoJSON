//
//  GeoJSONGeometry.swift
//  PassengerApp
//
//  Created by Guy Kogus on 21/12/2018.
//  Copyright © 2018 Guy Kogus. All rights reserved.
//

/// A region of space.
public protocol GeoJSONGeometry: Codable, Hashable {}

/// A single position.
public struct PointGeometry: GeoJSONGeometry {
    public typealias Coordinates = GeoJSONPosition

    public let coordinates: Coordinates
}

/// An array of positions.
public struct MultiPointGeometry: GeoJSONGeometry {
    public typealias Coordinates = [PointGeometry.Coordinates]

    public let coordinates: Coordinates
}

/// An array of 2 or more positions.
public struct LineStringGeometry: GeoJSONGeometry {
    public typealias Coordinates = [GeoJSONPosition]

    public let coordinates: Coordinates
}

/// An array of `lineString` coordinate arrays.
public struct MultiLineStringGeometry: GeoJSONGeometry {
    public typealias Coordinates = [LineStringGeometry.Coordinates]

    public let coordinates: Coordinates
}

/// An array of linear rings.
public struct PolygonGeometry: GeoJSONGeometry {
    /// A closed "Line String" with four or more positions.
    public typealias LinearRing = [GeoJSONPosition]
    public typealias Coordinates = [LinearRing]

    public let coordinates: Coordinates

    /// The first `LinearRing` of a polygon represents its external ring.
    public var exteriorRing: Coordinates.Element? {
        return coordinates.first
    }
    /// The internal holes of the polygon. May be empty.
    public var internalRings: Coordinates.SubSequence {
        return coordinates.dropFirst()
    }
}

/// An array of `polygon` coordinate arrays.
public struct MultiPolygonGeometry: GeoJSONGeometry {
    public typealias Coordinates = [PolygonGeometry.Coordinates]

    public let coordinates: Coordinates
}

/// An array of geometries.
public struct GeometryCollection: GeoJSONGeometry {
    public typealias Geometries = [GeoJSON.Geometry]

    public let geometries: Geometries
}
