# CodableGeoJSON

[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/CodableGeoJSON.svg)](https://cocoapods.org)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![SPM compatible](https://img.shields.io/badge/SPM-Compatible-brightgreen.svg?style=flat)](https://swift.org/package-manager/)

This implementation of [GeoJSON](http://geojson.org) conforms to [rfc7946](https://tools.ietf.org/html/rfc7946) and is designed for usage with `Codable` objects.

This library includes both a dynamic and static variant of the GeoJSON models. The static variant is useful when handling pre-defined GeoJSON responses.

# Requirements

- iOS 9.0+ / macOS 10.9+ / tvOS 9.0+ / watchOS 2.0+
- Xcode 10.2+
- Swift 5.0+

# Usage

## Static Models

The static models are recommended for when your project is set up to load data for which you know what structure to expect.

For example, if you know that you're loading a list of locations inside a "FeatureCollection" like this:

```JSON
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
```

You can define the model using a `struct` and a `typealias`.

```Swift
struct LocationProperties: Codable {
    let address: String
    let name: String
}

typealias LocationFeatureCollection = GeoJSONFeatureCollection<PointGeometry, LocationProperties>
```

The benefit here is that you can access the specific geometry and all the properties directly, without having to perform any introspection. E.g.

```Swift
let locationFeatures = try JSONDecoder().decode(LocationFeatureCollection.self, from: data)
let firstFeature = locationFeatures.features.first
firstFeature?.geometry.longitude // -0.452207
firstFeature?.properties?.name // "Heathrow Airport"
```

### Geometry Collection

A geometry collection is, by definition, not statically typed, as it can contain a mixed array of different GeoJSON geometry types. Therefore you will need to check each array by hand. (If somebody has a way of simplifying this, feel free to post a PR 😉)

```Swift
let geometryColection = try JSONDecoder().decode(GeometryCollection.self, from: data)
if geometryColection.geometries.count > 0,
    case GeoJSON.Geometry.point(let pointCoordinates) = geometryColection.geometries[0] {
    let point = PointGeometry(coordinates: pointCoordinates)
} else {
    // Failed to get expected geometry
}
```

### Empty properties

If you don't want or need any of the properties of the feature, you can define an empty `struct` and set it as the `Properties` template parameter.

```Swift
struct EmptyProperties: Codable {}

typealias PointFeature = GeoJSONFeature<PointGeometry, EmptyProperties>
```

This will result in the "Feature" objects containing only a point coordinate.

## Dynamic Models

The dynamic models should only be used when the expected structure is undefined or may change.

First, let's assume that you have a GeoJSON data object. The first step is to decode it.

```Swift
do {
    switch try JSONDecoder().decode(GeoJSON.self, from: data) {
    case .feature(let feature, _):
        handleGeometry(feature.geometry)
    case .featureCollection(let featureCollection, _):
        for feature in featureCollection.features {
            handleGeometry(feature.geometry)
        }
    case .geometry(let geometry, _):
        handleGeometry(geometry)
    }
} catch {
    // Handle decoding error
}
```

Then you can explore the different geometries provided.

```Swift
func handleGeometry(_ geometry: GeoJSONGeometry?) {
    guard let geometry = geometry else { return }

    switch geometry {
    case .point(let coordinates):
        break
    case .multiPoint(let coordinates):
        break
    case .lineString(let coordinates):
        break
    case .multiLineString(let coordinates):
        break
    case .polygon(let coordinates):
        break
    case .multiPolygon(let coordinates):
        break
    case .geometryCollection(let geometries):
        for geometry in geometries {
            handleGeometry(geometry)
        }
    }
}
```

If you know the geometry type that you're looking for, you can try and get it directly.

```Swift
func handleGeometry(_ geometry: GeoJSONGeometry?) {
    guard case GeoJSONGeometry.polygon(let coordinates)? = geometry else { return }

    displayPolygon(linearRings: coordinates)
}
```

# Installation

<details>
<summary>CocoaPods</summary>
</br>
<p>To integrate CodableGeoJSON into your Xcode project using <a href="http://cocoapods.org">CocoaPods</a>, specify it in your <code>Podfile</code>:</p>
<pre><code class="ruby language-ruby">pod 'CodableGeoJSON'</code></pre>
</details>

<details>
<summary>Carthage</summary>
</br>
<p>To integrate CodableGeoJSON into your Xcode project using <a href="https://github.com/Carthage/Carthage">Carthage</a>, specify it in your <code>Cartfile</code>:</p>
<pre><code class="ogdl language-ogdl">github "guykogus/CodableGeoJSON"</code></pre>
</details>

<details>
<summary>Swift Package Manager</summary>
</br>
<p>You can use <a href="https://swift.org/package-manager">The Swift Package Manager</a> to install <code>CodableGeoJSON</code> by adding the proper description to your <code>Package.swift</code> file:</p>

<pre><code class="swift language-swift">import PackageDescription

let package = Package(
    name: "YOUR_PROJECT_NAME",
    targets: [],
    dependencies: [
        .package(url: "https://github.com/guykogus/CodableGeoJSON.git", from: "1.2.0")
    ]
)
</code></pre>

<p>Next, add <code>CodableGeoJSON</code> to your targets dependencies like so:</p>
<pre><code class="swift language-swift">.target(
    name: "YOUR_TARGET_NAME",
    dependencies: [
        "CodableGeoJSON",
    ]
),</code></pre>
<p>Then run <code>swift package update</code>.</p>
</details>

# License

CodableGeoJSON is available under the MIT license. See the LICENSE file for more info.
