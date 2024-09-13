// HolidaysTestData.swift
// Created by msuzoagu on 9/12/24.

import Foundation

let fixedHolidayMissingReqField: Data = """
{
    "rules": [
        {
            "name": "New Year's Day",
            "type": "fixed"
        }
    ]
}
""".data(using: .utf8)!

let fixedHolidayExtraFields: Data = """
{
    "rules": [
        {
            "name": "New Year's Day",
            "monthDay": "January 1",
            "type": "fixed",
            "month": "January",
            "week": "1",
            "weekDay": "Monday"
        }
    ]
}
""".data(using: .utf8)!

let dynamicHolidyMissingReqField: Data = """
{
    "rules": [
        {
            "name": "Labour Day",
            "type": "dynamic",
        }
    ]
}
""".data(using: .utf8)!

let extraFieldDynamicHolid: Data = """
{
    "rules": [
        {
            "name": "Labor Day",
            "month": "September",
            "week": "1",
            "weekDay": "Monday",
            "monthDay": "September 7",
            "type": "dynamic"
        }
    ]
}
""".data(using: .utf8)!

let validJSON: Data = """
{
    "rules": [
        {
            "name": "New Year's Day",
            "monthDay": "January 1",
            "type": "fixed"
        },
        {
            "name": "Dr. Martin Luther King, Jr. Day",
            "month": "January",
            "week": "3",
            "weekDay": "Monday",
            "type": "dynamic"
        },
        {
            "name": "Washington's Birthday (Presidents' Day)",
            "month": "February",
            "week": "3",
            "weekDay": "Monday",
            "type": "dynamic"
        },
        {
            "name": "Memorial Day",
            "month": "May",
            "week": "last",
            "weekDay": "Monday",
            "type": "dynamic"
        },
        {
            "name": "Juneteenth",
            "monthDay": "June 19",
            "type": "fixed"
        },
        {
            "name": "Independence Day",
            "monthDay": "July 4",
            "type": "fixed"
        },
        {
            "name": "Labor Day",
            "month": "September",
            "week": "1",
            "weekDay": "Monday",
            "type": "dynamic"
        },
        {
            "name": "Columbus Day/Indigenous People's Day",
            "month": "October",
            "week": "2",
            "weekDay": "Monday",
            "type": "dynamic"
        },
        {
            "name": "Veterans' Day",
            "monthDay": "November 11",
            "type": "fixed"
        },
        {
            "name": "Thanksgiving Day",
            "month": "November",
            "week": "4",
            "weekDay": "Thursday",
            "type": "dynamic"
        },
        {
            "name": "Christmas Day",
            "monthDay": "December 25",
            "type": "fixed"
        }
    ]
}
""".data(using: .utf8)!
