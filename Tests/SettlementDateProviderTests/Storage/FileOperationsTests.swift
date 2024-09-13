// FileOperationsTests.swift
// Created by msuzoagu on 9/13/24.

@testable import SettlementDateProvider
import XCTest

final class FileOperationsTests: XCTestCase {
    var operations: MockFileOperations!

    override func setUpWithError() throws {
        try super.setUpWithError()
        operations = MockFileOperations()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func test_rulesUrl_whenFileDoesNotExist() throws {
        let country = "none"
        operations.country = country

        XCTAssertThrowsError(try operations.rulesURL()) { error in
            guard case let FileError.rulesUrlNotFound(msg) = error else {
                XCTFail("Unexpected error type: \(String(describing: error))")
                return
            }
            let expectedMsg = "URL for \(country) holiday rules not found"
            XCTAssertEqual(msg, expectedMsg, "Unexpected error message: \(msg)")
        }
    }

    func test_rulesURL_whenFileExists() throws {
        let country = "US"
        operations.country = country
        do {
            let url = try operations.rulesURL()
            XCTAssertTrue(url.absoluteString.contains(country))
        } catch {
            XCTFail("Should not fail when the file exists")
        }
    }

    func test_datesURL_whenFileExists() throws {
        operations.country = "US"
        let expectedURL = try XCTUnwrap(
            FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask
            ).first?.appending(path: "usBankHolidayDates", directoryHint: .checkFileSystem)
        )
        let result = try operations.datesURL()
        XCTAssertEqual(result, expectedURL)
    }

    func test_datesURL_whenFileDoesNotExist() throws {
        operations.country = "US"
        operations.overrideDocDirUrl = true
        let result = try operations.datesURL()
        let expectedURL = URL(filePath: "usBankHolidayDates", relativeTo: URL(filePath: NSTemporaryDirectory()))
        XCTAssertEqual(result, expectedURL)
    }

    func test_writeAndReadConsistency() throws {}
}
