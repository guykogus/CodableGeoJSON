//
//  GeoJSONStaticFeatureCollectionTests.swift
//  SwiftCodableGeoJSONTests
//
//  Created by Guy Kogus on 21/12/2018.
//  Copyright © 2018 Guy Kogus. All rights reserved.
//

import XCTest
@testable import SwiftCodableGeoJSON

struct LocationProperties: Codable {
    let address: String
    let name: String
}

typealias LocationFeatureCollection = GeoJSONFeatureCollection<PointGeometry, LocationProperties>

class GeoJSONStaticFeatureCollectionTests: XCTestCase {
    func testStaticLocation() {
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
            let decoder = JSONDecoder()
            let locationFeatures = try decoder.decode(LocationFeatureCollection.self, from: string.data(using: .utf8)!)
            let firstFeature = locationFeatures.features.first
            XCTAssertEqual(firstFeature?.id, nil)
            XCTAssertEqual(firstFeature?.geometry, .init(coordinates: .init(longitude: -0.452207, latitude: 51.471403)))
            XCTAssertEqual(firstFeature?.properties?.address, "Longford, Hounslow TW6 1DB, UK")
            XCTAssertEqual(firstFeature?.properties?.name, "Heathrow Airport")
        } catch {
            XCTFail("Failed to decode Location: \(error)")
        }
    }
}
