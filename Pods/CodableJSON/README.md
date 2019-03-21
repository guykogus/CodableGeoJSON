# CodableJSON

JSON in Swift - the way it should be.

# Usage

In the modern era of `Codable` it is rare that we need to handle JSON data manually. Nevertheless there are times when we can't know the structure in advance, but we can still utilise `Codable` to make our lives easier.

When loading JSON data:

```JSON
{
  "Apple": {
    "address": {
      "street": "1 Infinite Loop",
      "city": "Cupertino",
      "state": "CA",
      "zip": "95014"
    },
    "employees": 132000
  }
}
```

### Previously

You would have had to perform a lot of casting to get the inner values.

```Swift
guard let companies = try JSONSerialization.jsonObject(with: companiesData) as? [String: Any] else { return }

if let company = companies["Apple"] as? [String: Any],
    let address = company["address"] as? [String: Any],
    let city = address["city"] as? String {
    print("Apple is in \(city)")
}
```

Changing the inner values would also involve several castings.

```Swift
guard var companies = try JSONSerialization.jsonObject(with: companiesData) as? [String: Any] else { return }

if var apple = companies["Apple"] as? [String: Any],
    var address = apple["address"] as? [String: Any] {
    address["state"] = "California"
    apple["address"] = address
    companies["Apple"] = apple
}
```

### Using `CodableJSON`

Since JSON has a fixed set of types there's no need to perform all these casts in long form. `CodableJSON` uses an `enum` to store each type. With the aid of some helper functions, accessing the JSON values is now significantly shorter and easier.

```Swift
let companies = try JSONDecoder().decode(JSON.self, from: companiesData)

if let city = companies["Apple"]?["address"]?["city"]?.stringValue {
    print("Apple is in \(city)")
}
```

You can even use mutable forms in order to change the inner values. E.g. You could change the state to its full name:

```Swift
var companies = try JSONDecoder().decode(JSON.self, from: companiesData)

companies["Apple"]?["address"]?["state"] = "California"
```

# Installation

CodableJSON is available through [Cocoapods](https://cocoapods.org). To install, add to your Podfile:

```
pod 'CodableJSON'
```

# License

CodableJSON is available under the MIT license. See the LICENSE file for more info.
