import ArgumentParser

@main
struct SwiftAnalyzer: AsyncParsableCommand {
    static var configuration: CommandConfiguration {
        return .init(
            commandName: "swift-analyzer",
            version: Version.value,
            subcommands: [
                ComplexityCommand.self,
                LineOfCodeCommand.self,
                MaintIdxCommand.self,
            ])
    }
}
