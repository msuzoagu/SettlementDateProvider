// SettlementDateFactoryTests.swift
// Created by msuzoagu on 9/12/24.

@testable import SettlementDateProvider
import XCTest

final class SettlementDateFactoryTests: XCTestCase {
    var dateValidator: DateValidator!
    var factory: SettlementDateFactory!

    override func setUpWithError() throws {
        try super.setUpWithError()
        dateValidator = DateValidator()
        factory = SettlementDateFactory()
    }

    override func tearDownWithError() throws {
        dateValidator = nil
        factory = nil
        try super.tearDownWithError()
    }

    func testMakeProvider_withOutStrategy_andInvalidCountryCode() throws {
        let country = "XX"
        var thrownError: Error?

        XCTAssertThrowsError(try factory.makeProvider(for: country, given: [Date()])) { error in
            thrownError = error
            guard case let SettlementDateFactoryError.invalidCountryCode(msg) = error else {
                XCTFail("Expected SettlementDate Error; got \(String(describing: error))")
                return
            }
            let expectedErrorMsg = "Country \(country) is not supported"
            XCTAssertEqual(msg, expectedErrorMsg)
        }

        XCTAssertTrue(
            thrownError is SettlementDateFactoryError,
            "Unexpected error type: \(type(of: thrownError))"
        )
    }

    func testMakeProvider_withStrategy_andInvalidCountryCode() throws {
        let country = "ZZ"
        var thrownError: Error?

        XCTAssertThrowsError(try factory.makeProvider(for: country, using: .permissive, given: [Date()])) { error in
            thrownError = error
            guard case let SettlementDateFactoryError.invalidCountryCode(msg) = error else {
                XCTFail("Expected SettlementDate Error; got \(String(describing: error))")
                return
            }

            let expectedErrorMsg = "Country \(country) is not supported"
            XCTAssertEqual(msg, expectedErrorMsg)
        }

        XCTAssertTrue(
            thrownError is SettlementDateFactoryError,
            "Unexpected error type: \(type(of: thrownError))"
        )
    }

    func testMakeProvider_emptyCountryCode() throws {
        var thrownError: Error?

        XCTAssertThrowsError(try factory.makeProvider(for: "", given: [Date()])) { error in
            thrownError = error
            guard case let SettlementDateFactoryError.emptyCountryCode(msg) = error else {
                XCTFail("Expected SettlementDate Error; got \(String(describing: error))")
                return
            }
            let expectedErrorMsg = "You must provide a valid `iSO 3166-1 alpha 2` country code"
            XCTAssertEqual(msg, expectedErrorMsg)
        }

        XCTAssertTrue(
            thrownError is SettlementDateFactoryError,
            "Expected SettlementDateFactoryError; got: \(type(of: thrownError))"
        )
    }

    func testMakeProvider_emptyPaymentDates() throws {
        var thrownError: Error?

        XCTAssertThrowsError(try factory.makeProvider(for: "US", given: [])) { error in
            thrownError = error
            guard case let SettlementDateFactoryError.emptyPaymentDates(msg) = error else {
                XCTFail("Expected SettlementDateFactoryError; got \(String(describing: error))")
                return
            }
            let expectedErrorMsg = "paymentDates cannot be empty"
            XCTAssertEqual(msg, expectedErrorMsg)
        }

        XCTAssertTrue(
            thrownError is SettlementDateFactoryError,
            "Expected SettlementDateFactoryError; got: \(type(of: thrownError))"
        )
    }

    func testMakeProvider_validCountryCodeWithDefaultStrategy() {
        let factory = SettlementDateFactory()
        let paymentDates: [Date] = [Date()]

        XCTAssertNoThrow(try factory.makeProvider(for: "US", given: paymentDates))
    }

    func testMakeProvider_validCountryCodeWithStrategies() {
        let factory = SettlementDateFactory()
        let paymentDates: [Date] = [Date()]

        let strategies: [SettlementStrategy] = [.permissive, .restrictive]

        for strategy in strategies {
            XCTAssertNoThrow(try factory.makeProvider(for: "US", using: strategy, given: paymentDates))
        }
    }
}
