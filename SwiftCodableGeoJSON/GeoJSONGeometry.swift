//
//  GeoJSONGeometry.swift
//  PassengerApp
//
//  Created by Guy Kogus on 21/12/2018.
//  Copyright © 2018 Guy Kogus. All rights reserved.
//

import Foundation

public typealias LinearRing = [GeoJSONPosition]

public protocol GeoJSONGeometry: Codable, Equatable {
    associatedtype Coordinates: Codable

    var coordinates: Coordinates { get }
}

public struct PointGeometry: GeoJSONGeometry {
    public let coordinates: GeoJSONPosition
}

public struct MultiPointGeometry: GeoJSONGeometry {
    public let coordinates: [PointGeometry.Coordinates]
}

public struct LineStringGeometry: GeoJSONGeometry {
    public let coordinates: [GeoJSONPosition]
}

public struct MultiLineStringGeometry: GeoJSONGeometry {
    public let coordinates: [LineStringGeometry.Coordinates]
}

public struct PolygonGeometry: GeoJSONGeometry {
    public let coordinates: [LinearRing]

    public var exteriorRing: LinearRing? {
        return coordinates.first
    }
}

public struct MultiPolygonGeometry: GeoJSONGeometry {
    public let coordinates: [PolygonGeometry.Coordinates]
}
