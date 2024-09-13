// HolidayDateProvider.swift
// Created by msuzoagu on 9/13/24.

import Foundation

struct HolidayDateProvider: HolidayDateProcessor {
    enum HolidayDateProviderError: Error {
        case missingMonthDay(msg: String)
        case missingWeek(msg: String)
        case missingWeekDay(msg: String)
        case missingMonth(msg: String)
        case conversionToIntFailed(msg: String)
    }

    func processHolidays(from rules: [HolidayRule]) throws -> [Holiday] {
        let toHoliday: (HolidayRule) throws -> Holiday = { rule in
            switch rule.type {
            case .fixed:
                return try self.fixedDate(from: rule)
            case .dynamic:
                return try self.dynamicDate(from: rule)
            }
        }
        return try rules.map(toHoliday)
    }

    func extractDates(from holidays: [Holiday]) throws -> [Date] {
        holidays.map { $0.date }
    }

    // MARKK: - Private Methods
    private func fixedDate(from rule: HolidayRule) throws -> Holiday {
        guard let monthDay = rule.monthDay else {
            throw HolidayDateProviderError.missingMonthDay(
                msg: "missing monthDay string (e.g. January 1) in fixed HolidayRule"
            )
        }
        let date = try DateGenerator.fixedDate(from: monthDay)
        return Holiday(date: date)
    }

    private func dynamicDate(from rule: HolidayRule) throws -> Holiday {
        guard let wk = rule.week?.rawValue else {
            throw HolidayDateProviderError.missingWeek(
                msg: "missing week Int e.g., first, second, last) in dynamic HolidayRule"
            )
        }

        guard let wkDay = rule.weekDay?.rawValue else {
            throw HolidayDateProviderError.missingWeekDay(
                msg: "missing week Int e.g., Monday) in dynamic HolidayRule"
            )
        }

        guard let month = rule.month else {
            throw HolidayDateProviderError.missingMonth(
                msg: "missing month in dynamic HolidayRule"
            )
        }

        guard
            let wkInt = DateComponentConverter.toIntFrom(week: wk),
            let wkDayInt = DateComponentConverter.toIntFrom(weekDay: wkDay),
            let monthInt = DateComponentConverter.toIntFrom(month: month)
        else {
            throw HolidayDateProviderError.conversionToIntFailed(
                msg: "conversion from string to Int failed in dynamic HolidayRule"
            )
        }

        let date = try DateGenerator.dynamicDate(
            week: wkInt, weekDay: wkDayInt, month: monthInt
        )

        return Holiday(date: date)
    }
}
