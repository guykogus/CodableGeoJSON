//
//  GeoJSONFeatureTests.swift
//  CodableGeoJSONTests
//
//  Created by Guy Kogus on 21/12/2018.
//  Copyright © 2018 Guy Kogus. All rights reserved.
//

import XCTest
@testable import CodableGeoJSON

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
            let feature = try decoder.decode(GeoJSON.Feature.self, from: string.data(using: .utf8)!)
            XCTAssertEqual(feature,
                           GeoJSON.Feature(id: nil,
                                           geometry: GeoJSON.Geometry.point(coordinates: GeoJSONPosition(longitude: 102, latitude: 0.5)),
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
            let feature = try decoder.decode(GeoJSON.Feature.self, from: string.data(using: .utf8)!)
            XCTAssertEqual(feature,
                           GeoJSON.Feature(id: nil, geometry: nil, properties: nil))
        } catch {
            XCTFail("GeoJSONFeature decoding error: \(error)")
        }
    }

    func testFeatureWithIdsGeometry() {
        let stringIdentifier = """
{
  "type": "Feature",
  "id": "foo",
  "geometry": null
}
"""
        let decoder = JSONDecoder()
        do {
            let feature1 = try decoder.decode(GeoJSON.Feature.self, from: stringIdentifier.data(using: .utf8)!)
            XCTAssertEqual(feature1,
                           GeoJSON.Feature(id: "foo", geometry: nil, properties: nil))
        } catch {
            XCTFail("GeoJSONFeature decoding error: \(error)")
        }

        let intIdentifier = """
{
  "type": "Feature",
  "id": 2,
  "geometry": null
}
"""
        do {
            let feature2 = try decoder.decode(GeoJSON.Feature.self, from: intIdentifier.data(using: .utf8)!)
            XCTAssertEqual(feature2,
                           GeoJSON.Feature(id: 2, geometry: nil, properties: nil))
        } catch {
            XCTFail("GeoJSONFeature decoding error: \(error)")
        }
    }
}
