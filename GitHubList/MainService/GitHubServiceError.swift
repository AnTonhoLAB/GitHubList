//
//  GitHubServiceError.swift
//  GitHubList
//
//  Created by George Gomes on 01/07/23.
//

import Foundation

enum GitHubServiceError: Error {
    case internalError
    case NoConnection
}

extension GitHubServiceError {
    var localizedDescription: String {
        switch self {
        case .internalError:
            return "Internal error, try again"
        case .NoConnection:
            return "No connection, turn on the internet and try again"
        }
    }
}
