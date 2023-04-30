import Foundation
import SwiftSyntax
import SwiftSyntaxParser

public struct CyclomaticComplexity {
    private class Visitor: SyntaxVisitor {
        private(set) var namespace: [String] = []
        private(set) var functions: [Function] = []

        override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
            namespace.append(node.identifier.text)
            return .visitChildren
        }

        override func visitPost(_ node: ClassDeclSyntax) {
            namespace.removeLast()
        }

        override func visit(_ node: ActorDeclSyntax) -> SyntaxVisitorContinueKind {
            namespace.append(node.identifier.text)
            return .visitChildren
        }

        override func visitPost(_ node: ActorDeclSyntax) {
            namespace.removeLast()
        }

        override func visit(_ node: StructDeclSyntax) -> SyntaxVisitorContinueKind {
            namespace.append(node.identifier.text)
            return .visitChildren
        }

        override func visitPost(_ node: StructDeclSyntax) {
            namespace.removeLast()
        }

        override func visit(_ node: ExtensionDeclSyntax) -> SyntaxVisitorContinueKind {
            namespace.append(node.extensionKeyword.text)
            return .visitChildren
        }

        override func visitPost(_ node: ExtensionDeclSyntax) {
            namespace.removeLast()
        }

        override func visit(_ node: FunctionParameterSyntax) -> SyntaxVisitorContinueKind {
            if case .identifier(let text) = node.firstToken?.tokenKind {
                functions.last?.parameters.append(text)
            }
            return .visitChildren
        }

        override func visit(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
            let name: String = namespace.isEmpty ? node.identifier.text : namespace.joined(separator: ".") + "." + node.identifier.text
            functions.append(.init(name: name, complexity: 1))
            return .visitChildren
        }

        override func visit(_ node: EnumDeclSyntax) -> SyntaxVisitorContinueKind {
            namespace.append(node.enumKeyword.text)
            return .visitChildren
        }

        override func visitPost(_ node: EnumDeclSyntax) {
            namespace.removeLast()
        }

        override func visit(_ node: CatchClauseSyntax) -> SyntaxVisitorContinueKind {
            functions.last?.complexity += 1
            return .visitChildren
        }

        override func visit(_ node: ForInStmtSyntax) -> SyntaxVisitorContinueKind {
            functions.last?.complexity += 1
            return .visitChildren
        }

        override func visit(_ node: GuardStmtSyntax) -> SyntaxVisitorContinueKind {
            functions.last?.complexity += 1
            return .visitChildren
        }

        override func visit(_ node: IdentifierPatternSyntax) -> SyntaxVisitorContinueKind {
            if node.identifier.text == "forEach" {
                functions.last?.complexity += 1
            }

            return .visitChildren
        }

        override func visit(_ node: IfStmtSyntax) -> SyntaxVisitorContinueKind {
            functions.last?.complexity += 1
            return .visitChildren
        }

        override func visit(_ node: RepeatWhileStmtSyntax) -> SyntaxVisitorContinueKind {
            functions.last?.complexity += 1
            return .visitChildren
        }

        override func visit(_ node: WhileStmtSyntax) -> SyntaxVisitorContinueKind {
            functions.last?.complexity += 1
            return .visitChildren
        }

        override func visit(_ node: SwitchCaseLabelSyntax) -> SyntaxVisitorContinueKind {
            functions.last?.complexity += 1
            return .visitChildren
        }

        override func visit(_ node: SwitchDefaultLabelSyntax) -> SyntaxVisitorContinueKind {
            functions.last?.complexity += 1
            return .visitChildren
        }
    }

    public let functions: [Function]

    public var file: Int {
        functions.reduce(into: 0) { result, function in
            result += function.complexity
        }
    }

    public init(contentOf url: URL) throws {
        let syntax = try SyntaxParser.parse(url)
        let visitor = Visitor(viewMode: .sourceAccurate)
        visitor.walk(syntax)

        self.functions = visitor.functions
    }
}
