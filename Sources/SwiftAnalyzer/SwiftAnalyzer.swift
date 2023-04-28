import ArgumentParser

@main
struct SwiftAnalyzer: AsyncParsableCommand {
    static var configuration: CommandConfiguration {
        .init(
            commandName: "swift-analyzer",
            subcommands: [LineOfCodeCommand.self, MaintIdxCommand.self])
    }
}
