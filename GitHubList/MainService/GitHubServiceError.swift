//
//  GitHubServiceError.swift
//  GitHubList
//
//  Created by George Gomes on 01/07/23.
//

import Foundation
import RxSwift

enum GitHubServiceError: Error {
    case internalError
    case NoConnection
    case notFound
}

extension GitHubServiceError {
    var localizedDescription: String {
        switch self {
        case .internalError:
            return "Internal error, try again"
        case .NoConnection:
            return "No connection, turn on the internet and try again"
        case .notFound:
            return "User not found, check the name entered and try again"
        }
    }
}
enum GitHUBServiceErrorRX<T>: Error {
    case NoConnection
}


extension GitHUBServiceErrorRX {
    var noConectionRXSingle: Single<T> {
        return Single<T>
            .create { single in
                single(.failure(GitHubServiceError.NoConnection))
                return Disposables.create()
            }
    }
}
