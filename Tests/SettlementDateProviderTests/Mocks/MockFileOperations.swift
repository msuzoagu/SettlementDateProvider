// MockFileOperations.swift
// Created by msuzoagu on 9/13/24.

import Foundation
@testable import SettlementDateProvider

final class MockFileOperations: FileOperations {
    var country: String = ""
    var overrideDocDirUrl: Bool = false

    func datesURL() throws -> URL {
        if overrideDocDirUrl { return temporaryFileURL() } else {
            guard let url = documentDirectoryURL() else {
                return temporaryFileURL()
            }
            return url.appending(path: datesFileName(), directoryHint: .checkFileSystem)
        }
    }

    private func documentDirectoryURL() -> URL? {
        if overrideDocDirUrl { return nil }
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }

    private func temporaryFileURL() -> URL {
        let tempDir = NSTemporaryDirectory()
        return URL(
            filePath: datesFileName(),
            directoryHint: .notDirectory,
            relativeTo: URL(filePath: tempDir, directoryHint: .isDirectory)
        )
    }

    private func datesFileName() -> String {
        return country.lowercased().appending("BankHolidayDates")
    }
}
