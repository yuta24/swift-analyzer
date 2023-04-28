import Foundation
import ArgumentParser

extension SwiftAnalyzer {
    struct LineOfCode: AsyncParsableCommand {
        @Argument<String>
        var path

        func run() async throws {
            let url = URL(fileURLWithPath: path)
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

            print("""
            total: \(total)
            blank: \(blank)
            comment: \(comment)
            code: \(total - blank - comment)
            """)
        }
    }
}
