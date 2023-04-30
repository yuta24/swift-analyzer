import Foundation
import SwiftSyntax
import SwiftSyntaxParser

private extension Syntax {
    var isScope: Bool {
        return self.is(CatchClauseSyntax.self) == true
            || self.is(ForInStmtSyntax.self) == true
            || self.is(IfStmtSyntax.self) == true
            || self.is(RepeatWhileStmtSyntax.self) == true
            || self.is(SwitchStmtSyntax.self) == true
            || self.is(WhileStmtSyntax.self) == true
    }
}

public struct CognitiveComplexity {
    private class Visitor: SyntaxVisitor {
        private(set) var namespace: [String] = []
        private(set) var extends: [Extend<Function, Int>] = []

        override func visit(_ node: CodeBlockSyntax) -> SyntaxVisitorContinueKind {
            guard let parent = node.parent else { return .visitChildren }

            if parent.isScope {
                extends.last?.other += 1
            }

            return .visitChildren
        }

        override func visitPost(_ node: CodeBlockSyntax) {
            guard let parent = node.parent else { return }

            if parent.isScope {
                extends.last?.other -= 1
            }
        }

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
                extends.last?.value.parameters.append(text)
            }
            return .visitChildren
        }

        override func visit(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
            let name: String = namespace.isEmpty ? node.identifier.text : namespace.joined(separator: ".") + "." + node.identifier.text
            extends.append(.init(value: .init(name: name, complexity: 0), other: 0))
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
            extends.last?.value.complexity += 1 + (extends.last?.other ?? 0)
            return .visitChildren
        }

        override func visit(_ node: ForInStmtSyntax) -> SyntaxVisitorContinueKind {
            extends.last?.value.complexity += 1 + (extends.last?.other ?? 0)
            return .visitChildren
        }

        override func visit(_ node: GuardStmtSyntax) -> SyntaxVisitorContinueKind {
            extends.last?.value.complexity += 1 + (extends.last?.other ?? 0)
            return .visitChildren
        }

        override func visit(_ node: IdentifierPatternSyntax) -> SyntaxVisitorContinueKind {
            if node.identifier.text == "forEach" {
                extends.last?.value.complexity += 1 + (extends.last?.other ?? 0)
            }

            return .visitChildren
        }

        override func visit(_ node: RepeatWhileStmtSyntax) -> SyntaxVisitorContinueKind {
            extends.last?.value.complexity += 1 + (extends.last?.other ?? 0)
            return .visitChildren
        }

        override func visit(_ node: SwitchStmtSyntax) -> SyntaxVisitorContinueKind {
            extends.last?.value.complexity += 1 + (extends.last?.other ?? 0)
            return .visitChildren
        }

        override func visit(_ node: TokenSyntax) -> SyntaxVisitorContinueKind {
            switch node.tokenKind {
            case .breakKeyword where node.parent?.is(SwitchStmtSyntax.self) == false:
                extends.last?.value.complexity += 1 + (extends.last?.other ?? 0)
            case .ifKeyword:
                extends.last?.value.complexity += 1 + (extends.last?.other ?? 0)
            case .elseKeyword where node.parent?.is(GuardStmtSyntax.self) == false:
                extends.last?.value.complexity += 1 + (extends.last?.other ?? 0)
            default:
                break
            }

            return .visitChildren
        }

        override func visit(_ node: WhileStmtSyntax) -> SyntaxVisitorContinueKind {
            extends.last?.value.complexity += 1 + (extends.last?.other ?? 0)
            return .visitChildren
        }
    }

    public let functions: [Function]

    public init(contentOf url: URL) throws {
        let syntax = try SyntaxParser.parse(url)
        let visitor = Visitor(viewMode: .sourceAccurate)
        visitor.walk(syntax)

        self.functions = visitor.extends.map(\.value)
    }
}
