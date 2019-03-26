//
//  GeoJSONTests.swift
//  CodableGeoJSONTests
//
//  Created by Guy Kogus on 21/12/2018.
//  Copyright © 2018 Guy Kogus. All rights reserved.
//

import XCTest
@testable import CodableGeoJSON

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
                           GeoJSON.Feature(id: nil,
                                           geometry: GeoJSON.Geometry.point(coordinates: GeoJSONPosition(longitude: 102, latitude: 0.5)),
                                           properties: ["prop0": "value0",
                                                        "prop1": ["this": "that"]]))
        } catch {
            XCTFail("GeoJSON.feature decoding error: \(error)")
        }
    }

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

        do {
            guard case GeoJSON.featureCollection(let featureCollection, _) = try decoder.decode(GeoJSON.self, from: string.data(using: .utf8)!) else {
                XCTFail("Failed to get feature collection")
                return
            }

            XCTAssertEqual(featureCollection,
                           GeoJSON.FeatureCollection(features: [
                            GeoJSON.Feature(id: nil,
                                            geometry: GeoJSON.Geometry.point(coordinates: GeoJSONPosition(longitude: 102, latitude: 0.5)),
                                            properties: ["prop0": "value0"]),
                            GeoJSON.Feature(id: nil,
                                            geometry: GeoJSON.Geometry.lineString(coordinates: [
                                                GeoJSONPosition(longitude: 102, latitude: 0),
                                                GeoJSONPosition(longitude: 103, latitude: 1),
                                                GeoJSONPosition(longitude: 104, latitude: 0),
                                                GeoJSONPosition(longitude: 105, latitude: 1)
                                                ]),
                                            properties: ["prop0": "value0",
                                                         "prop1": 0]),
                            GeoJSON.Feature(id: nil,
                                            geometry: GeoJSON.Geometry.polygon(coordinates: [[
                                                GeoJSONPosition(longitude: 100, latitude: 0),
                                                GeoJSONPosition(longitude: 101, latitude: 0),
                                                GeoJSONPosition(longitude: 101, latitude: 1),
                                                GeoJSONPosition(longitude: 100, latitude: 1),
                                                GeoJSONPosition(longitude: 100, latitude: 0)
                                                ]]),
                                            properties: ["prop0": "value0",
                                                         "prop1": ["this": "that"]])
                            ]))
        } catch {
            XCTFail("GeoJSON.featureCollection decoding error: \(error)")
        }
    }

    func testGeometry() {
        let string = """
{
  "type": "Point",
  "coordinates": [
    100.0,
    -100.0
  ]
}
"""

        do {
            guard case GeoJSON.geometry(let geometry, _) = try decoder.decode(GeoJSON.self, from: string.data(using: .utf8)!) else {
                XCTFail("Failed to get geometry")
                return
            }

            XCTAssertEqual(geometry,
                           GeoJSON.Geometry.point(coordinates: GeoJSONPosition(longitude: 100, latitude: -100)))
        } catch {
            XCTFail("GeoJSON.geometry decoding error: \(error)")
        }
    }

    func testGeometryCollection() {
        let string = """
{
  "type": "GeometryCollection",
  "geometries": [
    {
      "type": "Point",
      "coordinates": [
        100.0,
        -100.0
      ]
    },
    {
      "type": "LineString",
      "coordinates": [
        [
          101.0,
          -101.0
        ],
        [
          102.0,
          -102.0
        ]
      ]
    }
  ]
}
"""

        do {
            guard case GeoJSON.geometry(let geometry, _) = try decoder.decode(GeoJSON.self, from: string.data(using: .utf8)!) else {
                XCTFail("Failed to get geometries")
                return
            }

            XCTAssertEqual(geometry,
                           GeoJSON.Geometry.geometryCollection(geometries: [
                            GeoJSON.Geometry.point(coordinates: GeoJSONPosition(longitude: 100, latitude: -100)),
                            GeoJSON.Geometry.lineString(coordinates: [
                                GeoJSONPosition(longitude: 101, latitude: -101),
                                GeoJSONPosition(longitude: 102, latitude: -102)
                                ])
                            ]))
        } catch {
            XCTFail("GeoJSON.geometry decoding error: \(error)")
        }
    }
}
