//
//  GeoJSONFeatureCollectionTests.swift
//  CodableGeoJSONTests
//
//  Created by Guy Kogus on 21/12/2018.
//  Copyright © 2023 Guy Kogus. All rights reserved.
//

import XCTest
@testable import CodableGeoJSON

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
            let featureCollection = try decoder.decode(GeoJSON.FeatureCollection.self, from: string.data(using: .utf8)!)
            XCTAssertEqual(featureCollection,
                           GeoJSON.FeatureCollection(features: [
                            GeoJSON.Feature(geometry: GeoJSON.Geometry.point(coordinates: GeoJSONPosition(longitude: 102, latitude: 0.5)),
                                            properties: ["prop0": "value0"],
                                            id: nil),
                            GeoJSON.Feature(geometry: GeoJSON.Geometry.lineString(coordinates: [
                                GeoJSONPosition(longitude: 102, latitude: 0),
                                GeoJSONPosition(longitude: 103, latitude: 1),
                                GeoJSONPosition(longitude: 104, latitude: 0),
                                GeoJSONPosition(longitude: 105, latitude: 1)
                            ]),
                            properties: ["prop0": "value0",
                                         "prop1": 0],
                            id: nil),
                            GeoJSON.Feature(geometry: GeoJSON.Geometry.polygon(coordinates: [[
                                GeoJSONPosition(longitude: 100, latitude: 0),
                                GeoJSONPosition(longitude: 101, latitude: 0),
                                GeoJSONPosition(longitude: 101, latitude: 1),
                                GeoJSONPosition(longitude: 100, latitude: 1),
                                GeoJSONPosition(longitude: 100, latitude: 0)
                            ]]),
                            properties: ["prop0": "value0",
                                         "prop1": ["this": "that"]],
                            id: nil)
                           ]))
        } catch {
            XCTFail("GeoJSON.Feature decoding error: \(error)")
        }
    }
}
