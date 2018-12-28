//
//  GeoJSONGeometry.swift
//  PassengerApp
//
//  Created by Guy Kogus on 21/12/2018.
//  Copyright © 2018 Guy Kogus. All rights reserved.
//

import Foundation

public protocol GeoJSONGeometry: Codable, Equatable {}

public struct PointGeometry: GeoJSONGeometry {
    public typealias Coordinates = GeoJSONPosition

    public let coordinates: Coordinates
}

public struct MultiPointGeometry: GeoJSONGeometry {
    public typealias Coordinates = [PointGeometry.Coordinates]

    public let coordinates: Coordinates
}

public struct LineStringGeometry: GeoJSONGeometry {
    public typealias Coordinates = [GeoJSONPosition]

    public let coordinates: Coordinates
}

public struct MultiLineStringGeometry: GeoJSONGeometry {
    public typealias Coordinates = [LineStringGeometry.Coordinates]

    public let coordinates: Coordinates
}

public struct PolygonGeometry: GeoJSONGeometry {
    public typealias LinearRing = [GeoJSONPosition]
    public typealias Coordinates = [LinearRing]

    public let coordinates: Coordinates

    public var exteriorRing: Coordinates.Element? {
        return coordinates.first
    }
}

public struct MultiPolygonGeometry: GeoJSONGeometry {
    public typealias Coordinates = [PolygonGeometry.Coordinates]

    public let coordinates: Coordinates
}

public struct GeometryCollection: GeoJSONGeometry {
    public typealias Geometries = [GeoJSON.Geometry]

    public let geometries: Geometries
}
