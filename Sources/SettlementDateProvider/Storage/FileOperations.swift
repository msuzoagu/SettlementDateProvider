// FileOperations.swift
// Created by msuzoagu on 9/13/24.

import Foundation

/** A protocol that defines basic file operation capabilities.
 Conforming types are expected to handle common file operations such as
 reading from and writing to files. This protocol abstracts away the
 specifics of file handling, allowing different implementations to
 manage file I/O in a consistent manner.
  */
protocol FileOperations {
    var country: String { get }
    func rulesURL() throws -> URL
    func datesURL() throws -> URL
    func fileExists(at url: URL) -> Bool
    func readFile(at url: URL) throws -> Data
    func writeFile(data: Data, to url: URL) throws
}

extension FileOperations {
    /** Returns the URL where the file containing JSON that describes a country's bank holiday rules is stored in Package resources folder.
     - Throws: `FileError.rulesUrlNotFound` if the JSON file for specified country is not found in the package's resource bundle.
     - Returns: The `URL` of the JSON file in the package's resource bundle.
     */
    func rulesURL() throws -> URL {
        guard let url = Bundle.module.url(forResource: country, withExtension: "json") else {
            throw FileError.rulesUrlNotFound(msg: "URL for \(country) holiday rules not found")
        }
        return url
    }

    /** Returns the `URL` to the path where the list of bank holiday dates ([dates]) is stored.
     - Throws: An error if the URL cannot be determined.
     - Returns: The `URL` where the bank holiday dates are stored.
     */
    func datesURL() throws -> URL {
        guard let url = documentDirectoryURL() else { return temporaryFileURL() }
        return url.appending(path: datesFileName(), directoryHint: .checkFileSystem)
    }

    func fileExists(at url: URL) -> Bool {
        FileManager.default.fileExists(atPath: url.path(percentEncoded: false))
    }

    /** Reads the contents of a file at the specified URL.
     - Parameter url: The URL of the file to read.
     - Returns: the Data read from the file
     - Throws: `FileError.failedToReadContents` if the file cannot be read.
     */
    func readFile(at url: URL) throws -> Data {
        do {
            let handler = try FileHandle(forReadingFrom: url)

            defer {
                do { try handler.close()
                } catch {
                    #warning("Issue #2")
                    print(error.localizedDescription)
                }
            }

            guard let data = try handler.readToEnd() else {
                throw FileError.failedToReadFileToEnd(msg: "Failed to read the entire contents of file at \(url)")
            }
            return try validate(data: data, from: url)

        } catch {
            throw FileError.failedToReadFileContents(msg: "Failed to read contents of file at \(url)")
        }
    }

    /** Writes the given data to a file at the specified URL.
     - Parameters:
      - data: The `Data` to write to the file; applies only to [Date]
      - url: The `URL` of the file to write to.
     - Throws: `FileError.failedToWriteContents` if the file cannot be written.
      */
    func writeFile(data: Data, to url: URL) throws {
        do {
            createFile(at: url.path(percentEncoded: false))
            let handler = try FileHandle(forWritingTo: url)

            defer {
                do {
                    try handler.close()
                } catch {
                    #warning("Issue #2")
                    print("Failed to close file handle at \(url): \(error.localizedDescription)")
                }
            }

            try handler.write(contentsOf: data)

        } catch {
            throw FileError.failedToWriteData(
                msg: "Failed to write data to url \(url): \(error.localizedDescription) "
            )
        }
    }

    // MARK: - Private Methods

    /// Documents directory in home directory of application container
    private func documentDirectoryURL() -> URL? {
        guard let url = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first else {
            #warning("add logging")
            return nil
        }
        return url
    }

    /// Generate and return URL that represents the path to a file within the temporary directory
    private func temporaryFileURL() -> URL {
        let tempDir = NSTemporaryDirectory()
        return URL(
            filePath: datesFileName(),
            directoryHint: .notDirectory,
            relativeTo: URL(filePath: tempDir, directoryHint: .isDirectory)
        )
    }

    /// string used as a filename for storing or accessing bank holiday dates specific to the country and year.
    private func datesFileName() -> String {
        let currentYear = DateValidator().currentYear
        return country.lowercased().appending("BankHolidayDates\(currentYear)")
    }

    private func validate(data: Data, from url: URL) throws -> Data {
        if data.isEmpty || data.count <= 2 {
            throw FileError.dataIsEmpty(
                msg: "file at url \(url) is empty"
            )
        }

        do {
            _ = try JSONSerialization.jsonObject(with: data, options: [])
        } catch {
            throw FileError.dataIsInvalid(
                msg: "file at url: \(url) contains invalid JSON"
            )
        }

        return data
    }

    private func createFile(at path: String) {
        if !FileManager.default.fileExists(atPath: path) {
            FileManager.default.createFile(
                atPath: path,
                contents: nil,
                attributes: nil
            )
        }
    }
}
