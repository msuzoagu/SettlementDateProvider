// DatesStorage.swift
// Created by msuzoagu on 9/13/24.

import Foundation

class DatesStorage: FileOperations {
    let country: String

    init(country: String) {
        self.country = country
    }

    // MARK: - Internal Method

    /// saves dates extracted from Holidays to datesURL()
    func save(_ dates: [Date]) throws {
        let data = try encode(dates)
        let url = try datesURL()
        try writeFile(data: data, to: url)
    }

    func loadDates() throws -> [Date] {
        let url = try datesURL()
        let data = try readFile(at: url)
        return try decodeDates(from: data)
    }

    // MARK: - Private Methods

    private func encode(_ dates: [Date]) throws -> Data {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        do {
            return try encoder.encode(dates)
        } catch let error as EncodingError {
            throw CodableError.encodingError(error)
        }
    }

    private func decodeDates(from data: Data) throws -> [Date] {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        do {
            return try decoder.decode([Date].self, from: data)
        } catch let error as DecodingError {
            throw CodableError.decodingError(error)
        }
    }
}
