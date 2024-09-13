// HolidayServiceTests.swift
// Created by msuzoagu on 9/12/24.

@testable import SettlementDateProvider
import XCTest

/** `HolidayService` is an integration point where the components `Loader, Parser, HolidayDateProcessor, and Storage` work together, it should focus on focus on
  how these components interact and ensure the overall behavior is correct.

  Implement 2 Types of test for HolidayService:
  • Integration Testing:
  - mock the dependencies (Loader, Parser, HolidayDateProcessor, and Storage) to verify that
 HolidayService coordinates these components correctly.
 - test the interaction between these components and ensure the correct data flow.
 - validate that HolidayService can handle different scenarios like missing data, corrupted files,
  or valid and invalid inputs.

  • End-to-End Testing:
  - use real instances of all dependencies to perform an end-to-end test of the
  complete workflow.
  - ensure that the HolidayService can load, parse, process, and store holiday
  dates as expected in a real-world scenario.
  - test full lifecycle from loading raw data to making processed dates available.
  */
final class HolidayServiceTests: XCTestCase {
    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    func testExample() throws {}

    func testPerformanceExample() throws {
        measure {}
    }
}
