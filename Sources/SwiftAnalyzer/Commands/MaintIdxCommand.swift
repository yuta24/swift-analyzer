import Foundation
import ArgumentParser
import CodeMetrics

extension SwiftAnalyzer {
    struct MaintIdxCommand: AsyncParsableCommand {
        @Argument<String>
        var path

        static var configuration: CommandConfiguration {
            .init(commandName: "maint-idx")
        }

        func run() async throws {
            let url = URL(fileURLWithPath: path)
            let cyclomaticComplexity = try CyclomaticComplexity(contentOf: url)

            print("""
            Cyclomatic Complexity: \(cyclomaticComplexity.value)
            """)
        }
    }
}
