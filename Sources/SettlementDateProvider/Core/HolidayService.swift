// HolidayService.swift
// Created by msuzoagu on 9/12/24.

import Foundation

class HolidayService {
    private let loader: Loader
    private let parser: Parser
    private let storage: DatesStorage
    private let processor: HolidayDateProcessor

    init(loader: Loader, parser: Parser, storage: DatesStorage) {
        self.loader = loader
        self.parser = parser
        self.storage = storage
        self.processor = HolidayDateProvider()
    }

    /// Returns a list of holiday dates
    func holidayDates() throws -> [Date] {
        let url = try storage.datesURL()
        if storage.fileExists(at: url) {
            return try storage.loadDates()
        } else {
            try writeHolidayDatesToFile()
            return try storage.loadDates()
        }
    }

    // MARK: - Private Methods

    private func writeHolidayDatesToFile() throws {
        let data = try loader.loadData()
        let rulesArray = try parser.parse(data: data)
        let holidayArray = try processor.processHolidays(from: rulesArray)
        let holidayDatesArray = try processor.extractDates(from: holidayArray)
        try storage.save(holidayDatesArray)
    }
}
