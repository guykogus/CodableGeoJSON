//
//  JSON.swift
//  PassengerApp
//
//  Created by Guy Kogus on 21/12/2018.
//  Copyright © 2018 Guy Kogus. All rights reserved.
//

import Foundation

public enum JSON: Equatable {
    case null
    case bool(value: Bool)
    case int(value: Int)
    case double(value: Double)
    case string(value: String)
    case array(value: [JSON])
    case object(value: [String: JSON])

    public var isNull: Bool {
        guard case .null = self else { return false }
        return true
    }
    public var boolValue: Bool? {
        guard case .bool(let value) = self else { return nil }
        return value
    }
    public var intValue: Int? {
        guard case .int(let value) = self else { return nil }
        return value
    }
    public var doubleValue: Double? {
        guard case .double(let value) = self else { return nil }
        return value
    }
    public var stringValue: String? {
        guard case .string(let value) = self else { return nil }
        return value
    }
    public var count: Int {
        switch self {
        case .null, .bool(_), .int(_), .double(_), .string(_):
            return 0
        case .array(let value):
            return value.count
        case .object(let value):
            return value.count
        }
    }
    public subscript(key: Int) -> JSON? {
        get {
            guard case .array(let value) = self,
                key < value.count else { return nil }
            return value[key]
        }
        set {
            guard case .array(var value) = self,
                key < value.count else { return }
            if let newValue = newValue {
                value[key] = newValue
            } else {
                value.remove(at: key)
            }
            self = .array(value: value)
        }
    }
    public subscript(key: String) -> JSON? {
        get {
            guard case .object(let value) = self else { return nil }
            return value[key]
        }
        set {
            guard case .object(var value) = self else { return }
            value[key] = newValue
            self = .object(value: value)
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
            self = .object(value: object)
        } else if var arrayContainer = try? decoder.unkeyedContainer() {
            var array = [JSON]()
            array.reserveCapacity(arrayContainer.count ?? 0)
            while !arrayContainer.isAtEnd {
                array.append(try arrayContainer.decode(JSON.self))
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

// MARK: - CustomStringConvertible

extension JSON: CustomStringConvertible {
    private static let descriptionSeparator = ", "

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
            return "[\(value.map { $0.description }.joined(separator: ", "))]"
        case .object(let value):
            return "{\(value.map { "\"\($0)\": \($1.description)" }.joined(separator: ", "))}"
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
            return "<ARRAY>:[\(value.map { $0.debugDescription }.joined(separator: ", "))]"
        case .object(let value):
            return "<OBJECT>:{\(value.map { "\"\($0)\": \($1.debugDescription)" }.joined(separator: ", "))}"
        }
    }
}

// MARK: - ExpressibleByNilLiteral

extension JSON: ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        self = .null
    }
}

// MARK: - ExpressibleByBooleanLiteral

extension JSON: ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: Bool) {
        self = .bool(value: value)
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension JSON: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self = .int(value: value)
    }
}

// MARK: - ExpressibleByFloatLiteral

extension JSON: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self = .double(value: value)
    }
}

// MARK: - ExpressibleByStringLiteral

extension JSON: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .string(value: value)
    }
}

// MARK: - ExpressibleByArrayLiteral

extension JSON: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: JSON...) {
        self = .array(value: elements)
    }
}

// MARK: - ExpressibleByDictionaryLiteral

extension JSON: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, JSON)...) {
        self = .object(value: [String: JSON](elements, uniquingKeysWith: { (lhs, _) in lhs }))
    }
}
