import ArgumentParser

extension SwiftAnalyzer {
    struct MaintIdxCommand: AsyncParsableCommand {
        static var configuration: CommandConfiguration {
            .init(commandName: "maint-idx")
        }
    }
}
