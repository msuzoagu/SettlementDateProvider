// SettlementDateFactory.swift
// Created by msuzoagu on 9/12/24.

import Foundation

/** The SettlementDateFactory class is responsible for creating instances
 of SettlementDateProvider based on the provided country code, settlement
 strategy, and payment dates.
  */
public class SettlementDateFactory {
    public init() {}

    private let supportedCountries: Set<String> = [
        "US",
    ]

    /** creates an instance of `SettlementDateProvider` for the specified country, settlement strategy, and payment dates.
     - Parameters:
      - country: String iSO 3166-1 alpha-2 country code for which the SettlementDateProvider should be created
      - strategy: SettlementStrategy: strategy for determining settlement dates. Defaults to .permissive.
      - paymentDates: [Date] for which settlement dates beed to be provided
     - Returns: an instance of `SettlementDateProvider`
     - Throws:an instance of `SettlementDateProvider`
      */
    public func makeProvider(
        for country: String,
        using strategy: SettlementStrategy = .permissive,
        given paymentDates: [Date]
    ) throws -> SettlementDateProvider {
        guard !country.isEmpty else {
            throw SettlementDateFactoryError.emptyCountryCode(
                msg: "You must provide a valid `iSO 3166-1 alpha 2` country code"
            )
        }

        guard !paymentDates.isEmpty else {
            throw SettlementDateFactoryError.emptyPaymentDates(
                msg: "paymentDates cannot be empty"
            )
        }

        guard supportedCountries.contains(country) else {
            throw SettlementDateFactoryError.invalidCountryCode(
                msg: "Country \(country) is not supported"
            )
        }

        let loader = RulesLoader(country: country)
        let parser = RulesParser(country: country)
        let storage = DatesStorage(country: country)

        let holidayService = HolidayService(
            loader: loader,
            parser: parser,
            storage: storage
        )

        return SettlementDateProvider(
            strategy: strategy,
            paymentDates: paymentDates,
            holidayService: holidayService
        )
    }
}

enum SettlementDateFactoryError: Error {
    case invalidCountryCode(msg: String)
    case emptyPaymentDates(msg: String)
    case emptyCountryCode(msg: String)
}
