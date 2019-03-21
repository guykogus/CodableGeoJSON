//
//  JSON.swift
//  PassengerApp
//
//  Created by Guy Kogus on 21/12/2018.
//  Copyright © 2018 Guy Kogus. All rights reserved.
//

/// A JSON object.
public enum JSON: Equatable {
    /// A null object.
    case null
    /// A boolean value (true/false).
    case bool(_ value: Bool)
    /// A whole number integer value.
    case int(_ value: Int)
    /// A floating point value.
    case double(_ value: Double)
    /// A string value.
    case string(_ value: String)
    /// An array of JSON objects.
    case array(_ value: [JSON])
    /// A dictionary of string keys to JSON objects.
    case object(_ value: [String: JSON])
}

// MARK: - Initialisers

extension JSON {
    /// Initialise a boolean value (true/false).
    ///
    /// - Parameter value: `true` or `false`
    public init(_ value: Bool) {
        self = .bool(value)
    }

    /// Initialise an integer value.
    ///
    /// - Parameter value: An `Int` value.
    public init(_ value: Int) {
        self = .int(value)
    }

    /// Initialise an integer value.
    ///
    /// - Parameter value: Any value representable by `BinaryInteger`.
    public init<T>(_ value: T) where T: BinaryInteger {
        self = .int(.init(value))
    }

    /// Initialise a floating point value.
    ///
    /// - Parameter value: A `Double` value.
    public init(_ value: Double) {
        self = .double(value)
    }

    /// Initialise a floating point value.
    ///
    /// - Parameter value: Any value representable by `BinaryFloatingPoint`.
    public init<T>(_ value: T) where T: BinaryFloatingPoint {
        self = .double(.init(value))
    }

    /// Initialise a string value.
    ///
    /// - Parameter value: A `String` value.
    public init(_ value: String) {
        self = .string(value)
    }

    /// Initialise a string value.
    ///
    /// - Parameter value: Any value representable by `StringProtocol`.
    public init<T>(_ value: T) where T: StringProtocol {
        self = .string(.init(value))
    }

    /// Initialise an array of JSON objects.
    ///
    /// - Parameter value: An `Array` of `JSON` objects.
    public init(_ value: [JSON]) {
        self = .array(value)
    }

    /// Initialise an array of JSON objects.
    ///
    /// - Parameter value: A `Sequence` of `JSON` objects.
    public init<S>(_ value: S) where S: Sequence, S.Element == JSON {
        self = .array(.init(value))
    }

    /// Initialise a dictionary of string keys to JSON objects.
    ///
    /// - Parameter value: A `Dictionary` of `String` keys to `JSON` objects.
    public init(_ value: [String: JSON]) {
        self = .object(value)
    }
}

// MARK: - Helpers

extension JSON {
    /// Hepler function to check if the value is null.
    public var isNull: Bool {
        guard case .null = self else { return false }
        return true
    }

    /// Hepler function to get the boolean value, if possible.
    public var boolValue: Bool? {
        guard case .bool(let value) = self else { return nil }
        return value
    }

    /// Hepler function to get the integer value, if possible.
    public var intValue: Int? {
        switch self {
        case .null, .bool(_), .string(_), .array(_), .object(_):
            return nil
        case .int(let value):
            return value
        case .double(let value):
            return (value == value.rounded()) ? Int(value) : nil
        }
    }

    /// Hepler function to get the floating point value, if possible.
    public var doubleValue: Double? {
        switch self {
        case .null, .bool(_), .string(_), .array(_), .object(_):
            return nil
        case .int(let value):
            return Double(value)
        case .double(let value):
            return value
        }
    }

    /// Hepler function to get the string value, if possible.
    public var stringValue: String? {
        guard case .string(let value) = self else { return nil }
        return value
    }

    /// Hepler function to get the arraiy value, if possible.
    public var arrayValue: [JSON]? {
        guard case .array(let value) = self else { return nil }
        return value
    }

    /// Hepler function to get the object value, if possible.
    public var objectValue: [String: JSON]? {
        guard case .object(let value) = self else { return nil }
        return value
    }

    /// Hepler function to get the number of contained values, if possible.
    public var count: Int? {
        switch self {
        case .null, .bool(_), .int(_), .double(_), .string(_):
            return nil
        case .array(let value):
            return value.count
        case .object(let value):
            return value.count
        }
    }

    /// Helper function to provide access to the values of the array, if possible.
    ///
    /// An index check is performed to avoid out-of-bounds exceptions.
    ///
    /// - Parameter index: The index of the array
    public subscript(index: Int) -> JSON? {
        get {
            guard case .array(var value) = self,
                index < value.count else { return nil }
            return value[index]
        }
        set {
            guard case .array(var value) = self,
                index < value.count else { return }
            if let newValue = newValue {
                value[index] = newValue
            } else {
                value[index] = .null
            }
            self = .array(value)
        }
    }

    /// Helper function to provide access to the values of the dictionary, if possible.
    ///
    /// - Parameter key: The key for retrieving the value from the dictionary.
    public subscript(key: String) -> JSON? {
        get {
            return objectValue?[key]
        }
        set {
            guard case .object(var value) = self else { return }
            if newValue == nil {
                value[key] = .null
            } else {
                value[key] = newValue
            }
            self = .object(value)
        }
    }
}

// MARK: - Codable

extension JSON: Codable {
    private enum Errors: Error {
        case unknownType
    }

    private enum CodingKeys: CodingKey {
        case string(value: String)
        case int(value: Int)

        var stringValue: String {
            switch self {
            case .string(let value):
                return value
            case .int(let value):
                return "Index \(value)"
            }
        }

        init?(stringValue: String) {
            self = .string(value: stringValue)
        }

        var intValue: Int? {
            switch self {
            case .string(let value):
                return Int(value)
            case .int(let value):
                return value
            }
        }

        init?(intValue: Int) {
            self = .int(value: intValue)
        }
    }

    public init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: CodingKeys.self) {
            var object = [String: JSON]()
            for key in container.allKeys {
                object[key.stringValue] = try container.decode(JSON.self, forKey: key)
            }
            self = .object(object)
        } else if var arrayContainer = try? decoder.unkeyedContainer() {
            var array = [JSON]()
            array.reserveCapacity(arrayContainer.count ?? 0)
            while !arrayContainer.isAtEnd {
                array.append(try arrayContainer.decode(JSON.self))
            }
            self = .array(array)
        } else {
            let container = try decoder.singleValueContainer()
            if container.decodeNil() {
                self = .null
            } else if let string = try? container.decode(String.self) {
                self = .string(string)
            } else if let int = try? container.decode(Int.self) {
                self = .int(int)
            } else if let double = try? container.decode(Double.self) {
                self = .double(double)
            } else if let bool = try? container.decode(Bool.self) {
                self = .bool(bool)
            } else {
                throw Errors.unknownType
            }
        }
    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .null:
            var container = encoder.singleValueContainer()
            try container.encodeNil()
        case .bool(let value):
            var container = encoder.singleValueContainer()
            try container.encode(value)
        case .int(let value):
            var container = encoder.singleValueContainer()
            try container.encode(value)
        case .double(let value):
            var container = encoder.singleValueContainer()
            try container.encode(value)
        case .string(let value):
            var container = encoder.singleValueContainer()
            try container.encode(value)
        case .array(let value):
            var container = encoder.unkeyedContainer()
            for obj in value {
                try container.encode(obj)
            }
        case .object(let value):
            var container = encoder.container(keyedBy: CodingKeys.self)
            for (key, value) in value {
                try container.encode(value, forKey: JSON.CodingKeys(stringValue: key)!)
            }
        }
    }
}

// MARK: - Raw values

// Generally used for compatibility with other libraries.

extension JSON {
    /// Helper function for getting values as `Any`, if possible.
    ///
    /// Arrays and dictionaries will convert nested values to their `rawValue` equivalents, where possible.
    /// - `null` -> `nil`
    /// - `bool` -> `Bool`
    /// - `integer` -> `Int`
    /// - `double` -> `Double`
    /// - `string` -> `String`
    /// - `array` -> `[Any]`
    /// - `object` -> `[String: Any]`
    public var rawValue: Any? {
        switch self {
        case .null:
            return nil
        case .bool(let value):
            return value
        case .int(let value):
            return value
        case .double(let value):
            return value
        case .string(let value):
            return value
        case .array(let value):
            return value.compactMap { $0.rawValue }
        case .object(let value):
            return [String: Any](uniqueKeysWithValues: value.lazy.compactMap {
                guard let rawValue = $1.rawValue else { return nil }
                return ($0, rawValue)
            })
        }
    }
}

// MARK: - CustomStringConvertible

extension JSON: CustomStringConvertible {
    fileprivate static let descriptionSeparator = ", "

    public var description: String {
        switch self {
        case .null:
            return "null"
        case .bool(let value):
            return value ? "true" : "false"
        case .string(let value):
            return "\"\(value)\""
        case .int(let value):
            return String(value)
        case .double(let value):
            return String(value)
        case .array(let value):
            return "[\(value.map { $0.description }.joined(separator: JSON.descriptionSeparator))]"
        case .object(let value):
            return "{\(value.map { "\"\($0)\": \($1.description)" }.joined(separator: JSON.descriptionSeparator))}"
        }
    }
}

// MARK: - CustomDebugStringConvertible

extension JSON: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .null:
            return "<NULL>:\(description)"
        case .bool:
            return "<BOOL>:\(description)"
        case .string:
            return "<STRING>:\(description)"
        case .int:
            return "<INT>:\(description)"
        case .double:
            return "<DOUBLE>:\(description)"
        case .array(let value):
            return "<ARRAY>:[\(value.map { $0.debugDescription }.joined(separator: JSON.descriptionSeparator))]"
        case .object(let value):
            return "<OBJECT>:{\(value.map { "\"\($0)\": \($1.debugDescription)" }.joined(separator: JSON.descriptionSeparator))}"
        }
    }
}

// MARK: - Expressible Literals

extension JSON: ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        self = .null
    }
}

extension JSON: ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: Bool) {
        self = .bool(value)
    }
}

extension JSON: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self = .int(value)
    }
}

extension JSON: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self = .double(value)
    }
}

extension JSON: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .string(value)
    }
}

extension JSON: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: JSON...) {
        self = .array(elements)
    }
}

extension JSON: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, JSON)...) {
        self = .object(.init(uniqueKeysWithValues: elements))
    }
}
