// CodableError.swift
// Created by msuzoagu on 9/13/24.

import Foundation

enum CodableError: Error {
    case encodingError(EncodingError)
    case decodingError(DecodingError)

    var errorDescription: String? {
        switch self {
        case let .encodingError(encodingError):
            switch encodingError {
            case let .invalidValue(any, context):
                return "Failed to encode value \(any) - \(context.debugDescription)"
            @unknown default:
                return "An unknown encoding error occurred."
            }
        case let .decodingError(decodingError):
            switch decodingError {
            case let .typeMismatch(type, context):
                return "Type mismatch: expected type '\(type)', but found: \(context.debugDescription), at codingPath: \(context.codingPath.map { $0.stringValue }.joined(separator: " -> "))"
            case let .valueNotFound(type, context):
                return "Value not found: expected type '\(type)', but found: \(context.debugDescription), at codingPath: \(context.codingPath.map { $0.stringValue }.joined(separator: " -> "))"
            case let .keyNotFound(key, context):
                return "Key not found: '\(key.stringValue)' expected in: \(context.debugDescription), at codingPath: \(context.codingPath.map { $0.stringValue }.joined(separator: " -> "))"
            case let .dataCorrupted(context):
                return "Data corrupted: \(context.debugDescription), at codingPath: \(context.codingPath.map { $0.stringValue }.joined(separator: " -> "))"
            @unknown default:
                return "Unknown decoding error: \(decodingError.localizedDescription)"
            }
        }
    }
}
