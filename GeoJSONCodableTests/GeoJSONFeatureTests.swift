//
//  GeoJSONFeatureTests.swift
//  GeoJSONCodableTests
//
//  Created by Guy Kogus on 21/12/2018.
//  Copyright © 2018 Guy Kogus. All rights reserved.
//

import XCTest
@testable import GeoJSONCodable

class GeoJSONFeatureTests: XCTestCase {
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
        let decoder = JSONDecoder()
        do {
            let feature = try decoder.decode(GeoJSONFeature.self, from: string.data(using: .utf8)!)
            XCTAssertEqual(feature,
                           GeoJSONFeature(id: nil,
                                          geometry: GeoJSONGeometry.point(coordinates: GeoJSONPosition(longitude: 102, latitude: 0.5)),
                                          properties: ["prop0": "value0",
                                                       "prop1": ["this": "that"]]))
        } catch {
            XCTFail("GeoJSONFeature decoding error: \(error)")
        }
    }

    func testFeatureWithNullGeometry() {
        let string = """
{
  "type": "Feature",
  "geometry": null
}
"""
        let decoder = JSONDecoder()
        do {
            let feature = try decoder.decode(GeoJSONFeature.self, from: string.data(using: .utf8)!)
            XCTAssertEqual(feature,
                           GeoJSONFeature(id: nil, geometry: nil, properties: nil))
        } catch {
            XCTFail("GeoJSONFeature decoding error: \(error)")
        }
    }
}
