//
//  GeoJSONFeatureCollectionTests.swift
//  GeoJSONCodableTests
//
//  Created by Guy Kogus on 21/12/2018.
//  Copyright © 2018 Guy Kogus. All rights reserved.
//

import XCTest
@testable import GeoJSONCodable

class GeoJSONFeatureCollectionTests: XCTestCase {
    func testFeatureCollection() {
        let string = """
{
  "type": "FeatureCollection",
  "features": [
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
        "prop0": "value0"
      }
    },
    {
      "type": "Feature",
      "geometry": {
        "type": "LineString",
        "coordinates": [
          [
            102.0,
            0.0
          ],
          [
            103.0,
            1.0
          ],
          [
            104.0,
            0.0
          ],
          [
            105.0,
            1.0
          ]
        ]
      },
      "properties": {
        "prop0": "value0",
        "prop1": 0.0
      }
    },
    {
      "type": "Feature",
      "geometry": {
        "type": "Polygon",
        "coordinates": [
          [
            [
              100.0,
              0.0
            ],
            [
              101.0,
              0.0
            ],
            [
              101.0,
              1.0
            ],
            [
              100.0,
              1.0
            ],
            [
              100.0,
              0.0
            ]
          ]
        ]
      },
      "properties": {
        "prop0": "value0",
        "prop1": {
          "this": "that"
        }
      }
    }
  ]
}
"""
        let decoder = JSONDecoder()
        do {
            let featureCollection = try decoder.decode(GeoJSONFeatureCollection.self, from: string.data(using: .utf8)!)
            XCTAssertEqual(featureCollection.features.count, 3)

            XCTAssertEqual(featureCollection.features[0],
                           GeoJSONFeature(id: nil,
                                          geometry: GeoJSONGeometry.point(coordinates: GeoJSONPosition(longitude: 102, latitude: 0.5)),
                                          properties: ["prop0": "value0"]))

            XCTAssertEqual(featureCollection.features[1],
                           GeoJSONFeature(id: nil,
                                          geometry: GeoJSONGeometry.lineString(coordinates: [
                                            GeoJSONPosition(longitude: 102, latitude: 0),
                                            GeoJSONPosition(longitude: 103, latitude: 1),
                                            GeoJSONPosition(longitude: 104, latitude: 0),
                                            GeoJSONPosition(longitude: 105, latitude: 1)
                                            ]),
                                          properties: ["prop0": "value0",
                                                       "prop1": 0]))

            XCTAssertEqual(featureCollection.features[2],
                           GeoJSONFeature(id: nil,
                                          geometry: GeoJSONGeometry.polygon(coordinates: [[
                                            GeoJSONPosition(longitude: 100, latitude: 0),
                                            GeoJSONPosition(longitude: 101, latitude: 0),
                                            GeoJSONPosition(longitude: 101, latitude: 1),
                                            GeoJSONPosition(longitude: 100, latitude: 1),
                                            GeoJSONPosition(longitude: 100, latitude: 0)
                                            ]]),
                                          properties: ["prop0": "value0",
                                                       "prop1": ["this": "that"]]))
        } catch {
            XCTFail("GeoJSONFeature decoding error: \(error)")
        }
    }
}
