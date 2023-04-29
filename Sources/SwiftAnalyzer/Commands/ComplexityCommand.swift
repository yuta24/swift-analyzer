import Foundation
import ArgumentParser
import CodeMetrics

extension SwiftAnalyzer {
    struct ComplexityCommand: AsyncParsableCommand {
        enum Kind: String, ExpressibleByArgument {
            case cognitive
            case cyclomatic
        }

        @Argument<Kind>
        var kind

        @Argument<String>
        var path

        static var configuration: CommandConfiguration {
            .init(commandName: "complexity")
        }

        func run() async throws {
            let url = URL(fileURLWithPath: path)

            let functions: [Function] = try {
                switch kind {
                case .cognitive:
                    let complexity = try CognitiveComplexity(contentOf: url)
                    return complexity.functions
                case .cyclomatic:
                    let complexity = try CyclomaticComplexity(contentOf: url)
                    return complexity.functions
                }
            }()

            for function in functions {
                print("""
                \(function.signature): \(function.complexity)
                """)
            }
        }
    }
}
