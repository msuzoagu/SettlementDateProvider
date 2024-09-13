// RulesParser.swift
// Created by msuzoagu on 9/13/24.

import Foundation

typealias Parser = DataParser & FileOperations

struct RulesParser: Parser {
    let country: String

    // MARK: - Internal Methods

    func parse(data: Data) throws -> [HolidayRule] {
        let decoder = JSONDecoder()

        do {
            let holidays = try decoder.decode(Holidays.self, from: data)
            return holidays.rules
        } catch let error as DecodingError {
            throw CodableError.decodingError(error)
        }
    }
}
