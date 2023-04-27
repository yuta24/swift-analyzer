import ArgumentParser

@main
struct SwiftAnalyzer: ParsableCommand {
    static var configuration: CommandConfiguration {
        .init(commandName: "swift-analyzer")
    }
}
