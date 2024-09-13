// FileError.swift
// Created by msuzoagu on 9/13/24.

import Foundation

enum FileError: Error {
    case dataIsEmpty(msg: String)
    case dataIsInvalid(msg: String)
    case rulesUrlNotFound(msg: String)
    case failedToReadFileContents(msg: String)
    case failedToCloseFileHandle(msg: String)
    case failedToReadFileToEnd(msg: String)
    case failedToWriteData(msg: String)

    func description() -> String {
        switch self {
        case let .dataIsEmpty(msg):
            return msg
        case let .dataIsInvalid(msg):
            return msg
        case let .rulesUrlNotFound(msg):
            return msg
        case let .failedToReadFileContents(msg):
            return msg
        case let .failedToCloseFileHandle(msg):
            return msg
        case let .failedToReadFileToEnd(msg):
            return msg
        case let .failedToWriteData(msg):
            return msg
        }
    }
}
