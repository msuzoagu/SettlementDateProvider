// SettlementDateProcessor.swift
// Created by msuzoagu on 9/13/24.

import Foundation

protocol SettlementDateProcessor {
    func settlementDates() throws -> [Date]
}
