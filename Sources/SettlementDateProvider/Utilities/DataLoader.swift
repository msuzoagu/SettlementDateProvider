// DataLoader.swift
// Created by msuzoagu on 9/12/24.

import Foundation

/** A protocol that defines the capability to load data from a source.

  Conforming types are expected to implement a method for loading data,
 typically from an external source such as a file, database, or web service.
 This protocol abstracts away the specifics of how the data is retrieved,
 allowing different implementations to focus on the source of the data. */
protocol DataLoader {
    /// Loads data from a specific source
    ///  - Returns: the raw data loaded from the source
    ///  - Throws: an error if the data cannot be loaded
    func loadData() throws -> Data
}

protocol DataParser {
    func parse(data: Data) throws -> [HolidayRule]
}
