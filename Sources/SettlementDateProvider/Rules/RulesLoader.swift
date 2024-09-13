// RulesLoader.swift
// Created by msuzoagu on 9/12/24.

import Foundation

/**  A protocol that combines file operations and data loading capabilities.
 Conforming types are expected to handle both file-related operations,
 such as reading and writing files, as well as the loading of data from
 specific sources, such as files, databases, or network locations. */
typealias Loader = DataLoader & FileOperations

/** A class responsible for loading raw data from a file containing
 JSON rules used to describe country-specific bank holiday rules.

 `RulesLoader` combines file operations and data loading capabilities
 to retrieve and provide raw data for further processing. This class
 abstracts away the details of file handling and data loading, focusing
 on the retrieval of holiday rules data specific to a given country. */
class RulesLoader: Loader {
    private(set) var country: String

    init(country: String) {
        self.country = country
    }

    // MARK: - Internal Methods

    func loadData() throws -> Data {
        let url = try rulesURL()
        return try readFile(at: url)
    }
}
