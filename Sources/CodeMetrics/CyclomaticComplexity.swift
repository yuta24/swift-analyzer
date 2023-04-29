import Foundation
import SwiftSyntax
import SwiftSyntaxParser

public struct CyclomaticComplexity {
    final class Visitor: SyntaxVisitor {
        private(set) var counter: Int = 1

        override func visit(_ node: DoStmtSyntax) -> SyntaxVisitorContinueKind {
            counter += 1
            return .visitChildren
        }

        override func visit(_ node: ForInStmtSyntax) -> SyntaxVisitorContinueKind {
            counter += 1
            return .visitChildren
        }

        override func visit(_ node: GuardStmtSyntax) -> SyntaxVisitorContinueKind {
            counter += 1
            return .visitChildren
        }

        override func visit(_ node: IdentifierPatternSyntax) -> SyntaxVisitorContinueKind {
            if node.identifier.text == "forEach" {
                counter += 1
            }

            return .visitChildren
        }

        override func visit(_ node: IfStmtSyntax) -> SyntaxVisitorContinueKind {
            counter += 1
            return .visitChildren
        }

        override func visit(_ node: RepeatWhileStmtSyntax) -> SyntaxVisitorContinueKind {
            counter += 1
            return .visitChildren
        }

        override func visit(_ node: WhileStmtSyntax) -> SyntaxVisitorContinueKind {
            counter += 1
            return .visitChildren
        }

        override func visit(_ node: SwitchCaseLabelSyntax) -> SyntaxVisitorContinueKind {
            counter += 1
            return .visitChildren
        }

        override func visit(_ node: SwitchDefaultLabelSyntax) -> SyntaxVisitorContinueKind {
            counter += 1
            return .visitChildren
        }
    }

    public let value: Int

    public init(contentOf url: URL) throws {
        let syntax = try SyntaxParser.parse(url)
        let visitor = Visitor(viewMode: .sourceAccurate)
        visitor.walk(syntax)

        self.value = visitor.counter
    }
}
