//
//  GeoJSONGeometryTests.swift
//  SwiftCodableGeoJSONTests
//
//  Created by Guy Kogus on 21/12/2018.
//  Copyright © 2018 Guy Kogus. All rights reserved.
//

import XCTest
@testable import SwiftCodableGeoJSON

class GeoJSONGeometryTests: XCTestCase {
    let decoder = JSONDecoder()

    func testPoint() {
        let pointString = """
{
  "type": "Point",
  "coordinates": [
    100.0,
    -100
  ]
}
"""

        XCTAssertEqual(geometry(from: pointString),
                       GeoJSON.Geometry.point(coordinates: GeoJSONPosition(longitude: 100, latitude: -100)))
    }

    func testMultiPoint() {
        let multiPointString = """
{
  "type": "MultiPoint",
  "coordinates": [
    [
      100.0,
      -100
    ],
    [
      101.0,
      -101
    ]
  ]
}
"""

        XCTAssertEqual(geometry(from: multiPointString),
                       GeoJSON.Geometry.multiPoint(coordinates: [
                        GeoJSONPosition(longitude: 100, latitude: -100),
                        GeoJSONPosition(longitude: 101, latitude: -101)
                        ]))
    }

    func testLineString() {
        let lineStringString = """
{
  "type": "LineString",
  "coordinates": [
    [
      100.0,
      -100
    ],
    [
      101.0,
      -101
    ]
  ]
}
"""

        XCTAssertEqual(geometry(from: lineStringString),
                       GeoJSON.Geometry.lineString(coordinates: [
                        GeoJSONPosition(longitude: 100, latitude: -100),
                        GeoJSONPosition(longitude: 101, latitude: -101)
                        ]))
    }

    func testMultiLineString() {
        let multiLineStringString = """
{
  "type": "MultiLineString",
  "coordinates": [
    [
      [
        100.0,
        -100.0
      ],
      [
        101.0,
        -101.0
      ]
    ],
    [
      [
        102.0,
        -102.0
      ],
      [
        103.0,
        -103.0
      ]
    ]
  ]
}
"""

        XCTAssertEqual(geometry(from: multiLineStringString),
                       GeoJSON.Geometry.multiLineString(coordinates: [
                        [
                            GeoJSONPosition(longitude: 100, latitude: -100),
                            GeoJSONPosition(longitude: 101, latitude: -101)
                        ],
                        [
                            GeoJSONPosition(longitude: 102, latitude: -102),
                            GeoJSONPosition(longitude: 103, latitude: -103)
                        ]
                        ]))
    }

    func testPolygon() {
        let polygonString = """
{
  "type": "Polygon",
  "coordinates": [
    [
      [
        100.0,
        -100.0
      ],
      [
        101.0,
        -100.0
      ],
      [
        101.0,
        -101.0
      ],
      [
        100.0,
        -101.0
      ],
      [
        100.0,
        -100.0
      ]
    ],
    [
      [
        100.8,
        -100.2
      ],
      [
        100.8,
        -100.8
      ],
      [
        100.2,
        -100.8
      ],
      [
        100.2,
        -100.2
      ],
      [
        100.8,
        -100.2
      ]
    ]
  ]
}
"""

        XCTAssertEqual(geometry(from: polygonString),
                       GeoJSON.Geometry.polygon(coordinates: [
                        [
                            GeoJSONPosition(longitude: 100, latitude: -100),
                            GeoJSONPosition(longitude: 101, latitude: -100),
                            GeoJSONPosition(longitude: 101, latitude: -101),
                            GeoJSONPosition(longitude: 100, latitude: -101),
                            GeoJSONPosition(longitude: 100, latitude: -100)
                        ],
                        [
                            GeoJSONPosition(longitude: 100.8, latitude: -100.2),
                            GeoJSONPosition(longitude: 100.8, latitude: -100.8),
                            GeoJSONPosition(longitude: 100.2, latitude: -100.8),
                            GeoJSONPosition(longitude: 100.2, latitude: -100.2),
                            GeoJSONPosition(longitude: 100.8, latitude: -100.2)
                        ]
                        ]))
    }

    func testMultiPolygon() {
        let multiPolygonString = """
{
  "type": "MultiPolygon",
  "coordinates": [
    [
      [
        [
          102.0,
          -102.0
        ],
        [
          103.0,
          -102.0
        ],
        [
          103.0,
          -103.0
        ],
        [
          102.0,
          -103.0
        ],
        [
          102.0,
          -102.0
        ]
      ]
    ],
    [
      [
        [
          100.0,
          -100.0
        ],
        [
          101.0,
          -100.0
        ],
        [
          101.0,
          -101.0
        ],
        [
          100.0,
          -101.0
        ],
        [
          100.0,
          -100.0
        ]
      ],
      [
        [
          100.2,
          -100.2
        ],
        [
          100.2,
          -100.8
        ],
        [
          100.8,
          -100.8
        ],
        [
          100.8,
          -100.2
        ],
        [
          100.2,
          -100.2
        ]
      ]
    ]
  ]
}
"""

        XCTAssertEqual(geometry(from: multiPolygonString),
                       GeoJSON.Geometry.multiPolygon(coordinates: [
                        [
                            [
                                GeoJSONPosition(longitude: 102, latitude: -102),
                                GeoJSONPosition(longitude: 103, latitude: -102),
                                GeoJSONPosition(longitude: 103, latitude: -103),
                                GeoJSONPosition(longitude: 102, latitude: -103),
                                GeoJSONPosition(longitude: 102, latitude: -102)
                            ]
                        ],
                        [

                            [
                                GeoJSONPosition(longitude: 100, latitude: -100),
                                GeoJSONPosition(longitude: 101, latitude: -100),
                                GeoJSONPosition(longitude: 101, latitude: -101),
                                GeoJSONPosition(longitude: 100, latitude: -101),
                                GeoJSONPosition(longitude: 100, latitude: -100)
                            ],
                            [
                                GeoJSONPosition(longitude: 100.2, latitude: -100.2),
                                GeoJSONPosition(longitude: 100.2, latitude: -100.8),
                                GeoJSONPosition(longitude: 100.8, latitude: -100.8),
                                GeoJSONPosition(longitude: 100.8, latitude: -100.2),
                                GeoJSONPosition(longitude: 100.2, latitude: -100.2)
                            ]
                        ]
                        ]))
    }

    func testGeometryCollection() {
        let geometryCollectionString = """
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

        XCTAssertEqual(geometry(from: geometryCollectionString),
                       GeoJSON.Geometry.geometryCollection(geometries: [
                        GeoJSON.Geometry.point(coordinates: GeoJSONPosition(longitude: 100, latitude: -100)),
                        GeoJSON.Geometry.lineString(coordinates: [
                            GeoJSONPosition(longitude: 101, latitude: -101),
                            GeoJSONPosition(longitude: 102, latitude: -102)
                            ])
                        ]))
    }

    // MARK: - Private functions

    private func geometry(from string: String) -> GeoJSON.Geometry? {
        do {
            return try decoder.decode(GeoJSON.Geometry.self, from: string.data(using: .utf8)!)
        } catch {
            XCTFail("Failed to decode geometry: \(string)\n\(error)")
            return nil
        }
    }
}
