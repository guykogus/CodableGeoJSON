//
//  GeoJSONTests.swift
//  GeoJSONCodableTests
//
//  Created by Guy Kogus on 21/12/2018.
//  Copyright © 2018 Guy Kogus. All rights reserved.
//

import XCTest
@testable import GeoJSONCodable

class GeoJSONTests: XCTestCase {
    let decoder = JSONDecoder()

    func testFeature() {
        let string = """
{
  "type": "Feature",
  "geometry": {
    "type": "Point",
    "coordinates": [
      102.0,
      0.5
    ]
  },
  "properties": {
    "prop0": "value0",
    "prop1": {
      "this": "that"
    }
  }
}
"""

        do {
            guard case GeoJSON.feature(let feature, _) = try decoder.decode(GeoJSON.self, from: string.data(using: .utf8)!) else {
                XCTFail("Failed to get feature")
                return
            }

            XCTAssertEqual(feature,
                           GeoJSONFeature(id: nil,
                                          geometry: GeoJSONGeometry.point(coordinates: GeoJSONPosition(longitude: 102, latitude: 0.5)),
                                          properties: ["prop0": "value0",
                                                       "prop1": ["this": "that"]]))
        } catch {
            XCTFail("GeoJSON.feature decoding error: \(error)")
        }
    }
}
