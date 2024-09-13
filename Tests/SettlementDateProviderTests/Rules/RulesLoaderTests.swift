// RulesLoaderTests.swift
// Created by msuzoagu on 9/12/24.

@testable import SettlementDateProvider
import XCTest

final class RulesLoaderTests: XCTestCase {
    var country: String!
    var rulesLoader: Loader!
    var mockFileOperations: MockFileOperations!

    override func setUpWithError() throws {
        try super.setUpWithError()
        country = "US"
        mockFileOperations = MockFileOperations()
        rulesLoader = RulesLoader(country: country)
    }

    override func tearDownWithError() throws {
        country = nil
        rulesLoader = nil
        try super.tearDownWithError()
    }
}
