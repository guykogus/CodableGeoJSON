//
//  GeoJSONGeometryTests.swift
//  CodableGeoJSONTests
//
//  Created by Guy Kogus on 21/12/2018.
//  Copyright © 2023 Guy Kogus. All rights reserved.
//

import XCTest
@testable import CodableGeoJSON

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

        let coordinates = GeoJSONPosition(longitude: 100, latitude: -100)

        XCTAssertEqual(geometry(from: pointString),
                       GeoJSON.Geometry.point(coordinates: coordinates))

        XCTAssertEqual(geometry(from: pointString),
                       PointGeometry(coordinates: coordinates))
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

        let coordinates = [
            GeoJSONPosition(longitude: 100, latitude: -100),
            GeoJSONPosition(longitude: 101, latitude: -101)
        ]

        XCTAssertEqual(geometry(from: multiPointString),
                       GeoJSON.Geometry.multiPoint(coordinates: coordinates))

        XCTAssertEqual(geometry(from: multiPointString),
                       MultiPointGeometry(coordinates: coordinates))
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

        let coordinates = [
            GeoJSONPosition(longitude: 100, latitude: -100),
            GeoJSONPosition(longitude: 101, latitude: -101)
        ]

        XCTAssertEqual(geometry(from: lineStringString),
                       GeoJSON.Geometry.lineString(coordinates: coordinates))

        XCTAssertEqual(geometry(from: lineStringString),
                       LineStringGeometry(coordinates: coordinates))
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

        let coordinates = [
            [
                GeoJSONPosition(longitude: 100, latitude: -100),
                GeoJSONPosition(longitude: 101, latitude: -101)
            ],
            [
                GeoJSONPosition(longitude: 102, latitude: -102),
                GeoJSONPosition(longitude: 103, latitude: -103)
            ]
        ]

        XCTAssertEqual(geometry(from: multiLineStringString),
                       GeoJSON.Geometry.multiLineString(coordinates: coordinates))

        XCTAssertEqual(geometry(from: multiLineStringString),
                       MultiLineStringGeometry(coordinates: coordinates))
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

        let coordinates = [
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
        ]

        XCTAssertEqual(geometry(from: polygonString),
                       GeoJSON.Geometry.polygon(coordinates: coordinates))

        XCTAssertEqual(geometry(from: polygonString),
                       PolygonGeometry(coordinates: coordinates))
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

        let coordinates = [
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
        ]

        XCTAssertEqual(geometry(from: multiPolygonString),
                       GeoJSON.Geometry.multiPolygon(coordinates: coordinates))

        XCTAssertEqual(geometry(from: multiPolygonString),
                       MultiPolygonGeometry(coordinates: coordinates))
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

        let geometries = [
            GeoJSON.Geometry.point(coordinates: GeoJSONPosition(longitude: 100, latitude: -100)),
            GeoJSON.Geometry.lineString(coordinates: [
                GeoJSONPosition(longitude: 101, latitude: -101),
                GeoJSONPosition(longitude: 102, latitude: -102)
            ])
        ]

        XCTAssertEqual(geometry(from: geometryCollectionString),
                       GeoJSON.Geometry.geometryCollection(geometries: geometries))

        XCTAssertEqual(geometry(from: geometryCollectionString),
                       GeometryCollection(geometries: geometries))
    }

    // MARK: - Private functions

    private func geometry<T>(from string: String) -> T? where T: Codable {
        do {
            return try decoder.decode(T.self, from: string.data(using: .utf8)!)
        } catch {
            XCTFail("Failed to decode geometry: \(string)\n\(error)")
            return nil
        }
    }
}
