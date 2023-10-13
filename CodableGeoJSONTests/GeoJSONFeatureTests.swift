//
//  GeoJSONFeatureTests.swift
//  CodableGeoJSONTests
//
//  Created by Guy Kogus on 21/12/2018.
//  Copyright © 2023 Guy Kogus. All rights reserved.
//

import XCTest
@testable import CodableJSON
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
            let data = string.data(using: .utf8)!
            let feature = try decoder.decode(GeoJSON.Feature.self, from: data)
            XCTAssertEqual(feature,
                           GeoJSON.Feature(geometry: GeoJSON.Geometry.point(coordinates: GeoJSONPosition(longitude: 102, latitude: 0.5)),
                                           properties: ["prop0": "value0",
                                                        "prop1": ["this": "that"]],
                                           id: nil))

            // Test encoding
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            try XCTAssertEqual(JSON(encodableValue: feature), JSON(rawValue: jsonObject))
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
            let data = string.data(using: .utf8)!
            let feature = try decoder.decode(GeoJSON.Feature.self, from: data)
            XCTAssertEqual(feature,
                           GeoJSON.Feature(geometry: nil, properties: nil, id: nil))

            // Test encoding
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            try XCTAssertEqual(JSON(encodableValue: feature), JSON(rawValue: jsonObject))
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
                           GeoJSON.Feature(geometry: nil, properties: nil, id: "foo"))
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
                           GeoJSON.Feature(geometry: nil, properties: nil, id: 2))
        } catch {
            XCTFail("GeoJSONFeature decoding error: \(error)")
        }
    }
}
