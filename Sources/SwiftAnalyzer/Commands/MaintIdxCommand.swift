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
            let index = try MaintainabilityIndex(contentOf: url)

            print("""
            \(url.relativeString): \(index.value)
            """)
        }
    }
}
