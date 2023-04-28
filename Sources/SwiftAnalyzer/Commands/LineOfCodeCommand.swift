import Foundation
import ArgumentParser
import CodeMetrics

extension SwiftAnalyzer {
    struct LineOfCodeCommand: AsyncParsableCommand {
        @Argument<String>
        var path

        static var configuration: CommandConfiguration {
            .init(commandName: "line-of-code")
        }

        func run() async throws {
            let url = URL(fileURLWithPath: path)
            let lineOfCode = try LineOfCode(contentOf: url)

            print("""
            total: \(lineOfCode.total)
            blank: \(lineOfCode.blank)
            comment: \(lineOfCode.comment)
            code: \(lineOfCode.code)
            """)
        }
    }
}
