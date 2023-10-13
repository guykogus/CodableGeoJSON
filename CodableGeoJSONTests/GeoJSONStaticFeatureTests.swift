//
//  GeoJSONStaticFeatureTests.swift
//  CodableGeoJSONTests
//
//  Created by Guy Kogus on 21/12/2018.
//  Copyright © 2023 Guy Kogus. All rights reserved.
//

import XCTest
@testable import CodableGeoJSON

fileprivate struct LocationProperties: Codable {
    let address: String
    let name: String
}

class GeoJSONStaticFeatureTests: XCTestCase {
    let decoder = JSONDecoder()

    func testLocationFeature() {
        let string = """
{
  "geometry": {
    "coordinates": [
      -0.452207,
      51.471403
    ],
    "type": "Point"
  },
  "properties": {
    "address": "Longford, Hounslow TW6 1DB, UK",
    "name": "Heathrow Airport"
  },
  "type": "Feature"
}
"""

        do {
            typealias LocationFeature = GeoJSONFeature<PointGeometry, LocationProperties>

            let locationFeature = try decoder.decode(LocationFeature.self, from: string.data(using: .utf8)!)
            XCTAssertNil(locationFeature.id)
            XCTAssertEqual(locationFeature.geometry, .init(coordinates: .init(longitude: -0.452207, latitude: 51.471403)))
            XCTAssertEqual(locationFeature.properties?.address, "Longford, Hounslow TW6 1DB, UK")
            XCTAssertEqual(locationFeature.properties?.name, "Heathrow Airport")
        } catch {
            XCTFail("Failed to decode Location: \(error)")
        }
    }

    func testLocationFeatureCollection() {
        let string = """
{
  "features": [
    {
      "geometry": {
        "coordinates": [
          -0.452207,
          51.471403
        ],
        "type": "Point"
      },
      "properties": {
        "address": "Longford, Hounslow TW6 1DB, UK",
        "name": "Heathrow Airport"
      },
      "type": "Feature"
    }
  ],
  "type": "FeatureCollection"
}
"""

        do {
            typealias LocationFeatureCollection = GeoJSONFeatureCollection<PointGeometry, LocationProperties>

            let locationFeatures = try decoder.decode(LocationFeatureCollection.self, from: string.data(using: .utf8)!)
            let firstFeature = locationFeatures.features.first
            XCTAssertNil(firstFeature?.id)
            XCTAssertEqual(firstFeature?.geometry, .init(coordinates: .init(longitude: -0.452207, latitude: 51.471403)))
            XCTAssertEqual(firstFeature?.properties?.address, "Longford, Hounslow TW6 1DB, UK")
            XCTAssertEqual(firstFeature?.properties?.name, "Heathrow Airport")
        } catch {
            XCTFail("Failed to decode Location: \(error)")
        }
    }
}
