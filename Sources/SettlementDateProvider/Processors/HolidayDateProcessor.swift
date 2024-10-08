// HolidayDateProcessor.swift
// Created by msuzoagu on 9/13/24.

import Foundation

protocol HolidayDateProcessor {
    func processHolidays(from rules: [HolidayRule]) throws -> [Holiday]
    func extractDates(from holidays: [Holiday]) throws -> [Date]
}
