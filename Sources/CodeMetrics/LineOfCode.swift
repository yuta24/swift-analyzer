import Foundation

public struct LineOfCode {
    public let total: Int
    public let blank: Int
    public let comment: Int

    public var code: Int {
        total - blank - comment
    }

    public init(contentOf url: URL) throws {
        let content = try String(contentsOf: url)
        let lines = content.components(separatedBy: .newlines)

        let total = lines.count

        let blank = lines.reduce(into: 0) { result, line in
            result += line.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 1 : 0
        }
        // TODO: improve comment count
        let comment = lines.reduce(into: 0) { result, line in
            result += line.trimmingCharacters(in: .whitespacesAndNewlines).hasPrefix("//") ? 1 : 0
        }

        self.total = total
        self.blank = blank
        self.comment = comment
    }
}
