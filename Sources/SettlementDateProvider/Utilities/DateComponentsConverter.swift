// DateComponentsConverter.swift
// Created by msuzoagu on 9/12/24.

import Foundation

enum DateComponentConverter {
    static func toIntFrom(weekDay: String) -> Int? {
        switch weekDay.lowercased() {
        case "monday": return 2
        case "tuesday": return 3
        case "wednesday": return 4
        case "thursday": return 5
        case "friday": return 6
        case "saturday": return 7
        case "sunday": return 1
        default: return nil
        }
    }

    static func toIntFrom(week: String) -> Int? {
        switch week {
        case "1": return 1
        case "2": return 2
        case "3": return 3
        case "4": return 4
        case "last": return -1
        default: return nil
        }
    }

    static func toIntFrom(month: String) -> Int? {
        switch month.lowercased() {
        case "january": return 1
        case "february": return 2
        case "march": return 3
        case "april": return 4
        case "may": return 5
        case "june": return 6
        case "july": return 7
        case "august": return 8
        case "september": return 9
        case "october": return 10
        case "november": return 11
        case "december": return 12
        default: return nil
        }
    }
}
