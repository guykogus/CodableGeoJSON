//
//  JSONObject.swift
//  PassengerApp
//
//  Created by Guy Kogus on 21/12/2018.
//  Copyright © 2018 Guy Kogus. All rights reserved.
//

import Foundation

enum JSONObject: Equatable {
    case null
    case bool(value: Bool)
    case int(value: Int)
    case double(value: Double)
    case string(value: String)
    case array(value: [JSONObject])
    case object(value: [String: JSONObject])

    var isNull: Bool {
        guard case .null = self else { return false }
        return true
    }
    var boolValue: Bool? {
        guard case .bool(let value) = self else { return nil }
        return value
    }
    var intValue: Int? {
        guard case .int(let value) = self else { return nil }
        return value
    }
    var doubleValue: Double? {
        guard case .double(let value) = self else { return nil }
        return value
    }
    var stringValue: String? {
        guard case .string(let value) = self else { return nil }
        return value
    }
    subscript(key: Int) -> JSONObject? {
        guard case .array(let value) = self else { return nil }
        return value[key]
    }
    subscript(key: String) -> JSONObject? {
        guard case .object(let value) = self else { return nil }
        return value[key]
    }
}

// MARK: - Codable

extension JSONObject: Codable {
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

    init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: CodingKeys.self) {
            var object = [String: JSONObject]()
            for key in container.allKeys {
                object[key.stringValue] = try container.decode(JSONObject.self, forKey: key)
            }
            self = .object(value: object)
        } else if var arrayContainer = try? decoder.unkeyedContainer() {
            var array = [JSONObject]()
            array.reserveCapacity(arrayContainer.count ?? 0)
            while !arrayContainer.isAtEnd {
                array.append(try arrayContainer.decode(JSONObject.self))
            }
            self = .array(value: array)
        } else {
            let container = try decoder.singleValueContainer()
            if container.decodeNil() {
                self = .null
            } else if let string = try? container.decode(String.self) {
                self = .string(value: string)
            } else if let int = try? container.decode(Int.self) {
                self = .int(value: int)
            } else if let double = try? container.decode(Double.self) {
                self = .double(value: double)
            } else if let bool = try? container.decode(Bool.self) {
                self = .bool(value: bool)
            } else {
                throw Errors.unknownType
            }
        }
    }

    func encode(to encoder: Encoder) throws {
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
                try container.encode(value, forKey: JSONObject.CodingKeys(stringValue: key)!)
            }
        }
    }
}

// MARK: - CustomStringConvertible

extension JSONObject: CustomStringConvertible {
    private static let descriptionSeparator = ", "

    var description: String {
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
            return "[\(value.map { $0.description }.joined(separator: ", "))]"
        case .object(let value):
            return "{\(value.map { "\"\($0)\": \($1.description)" }.joined(separator: ", "))}"
        }
    }
}

// MARK: - CustomDebugStringConvertible

extension JSONObject: CustomDebugStringConvertible {
    var debugDescription: String {
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
            return "<ARRAY>:[\(value.map { $0.debugDescription }.joined(separator: ", "))]"
        case .object(let value):
            return "<OBJECT>:{\(value.map { "\"\($0)\": \($1.debugDescription)" }.joined(separator: ", "))}"
        }
    }
}

// MARK: - ExpressibleByNilLiteral

extension JSONObject: ExpressibleByNilLiteral {
    init(nilLiteral: ()) {
        self = .null
    }
}

// MARK: - ExpressibleByBooleanLiteral

extension JSONObject: ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: Bool) {
        self = .bool(value: value)
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension JSONObject: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self = .int(value: value)
    }
}

// MARK: - ExpressibleByFloatLiteral

extension JSONObject: ExpressibleByFloatLiteral {
    init(floatLiteral value: Double) {
        self = .double(value: value)
    }
}

// MARK: - ExpressibleByStringLiteral

extension JSONObject: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        self = .string(value: value)
    }
}

// MARK: - ExpressibleByArrayLiteral

extension JSONObject: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: JSONObject...) {
        self = .array(value: elements)
    }
}

// MARK: - ExpressibleByDictionaryLiteral

extension JSONObject: ExpressibleByDictionaryLiteral {
    init(dictionaryLiteral elements: (String, JSONObject)...) {
        self = .object(value: [String: JSONObject](elements, uniquingKeysWith: { (lhs, _) in lhs }))
    }
}
