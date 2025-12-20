//
//  WrongArgumentsCount.swift
//
//
//  Created by Enrico Zannini on 20/12/25.
//

import Foundation
import SwiftSyntax
import SwiftDiagnostics

struct WrongArgumentsCount: DiagnosticMessage {
    
    let expected: Int
    let or: Int?
    let actual: Int
    
    init(expected: Int, or: Int? = nil, actual: Int) {
        self.expected = expected
        self.or = or
        self.actual = actual
    }
    
    var diagnosticID: MessageID { MessageID(domain: "com.ez.logger", id: "WrongArgumentCount\(expected)-\(actual)") }
    var message: String {
        let expected = if let or {
            "\(expected) or \(or)"
        } else {
            "\(expected)"
        }
        return """
        Expecting \(expected) parameters but got \(actual).
        This should not have happened.
        Please open an issue at: https://github.com/Enricoza/EZLog
        """
    }

    var severity: DiagnosticSeverity { .error }
    
    func diagnoseWith(node: some SyntaxProtocol) -> Diagnostic {
        Diagnostic(node: node, message: self)
    }
}
