//
//  ErrorType.swift
//  Moviez
//
//  Created by Ibram on 10/5/20.
//  Copyright © 2020 Ibram. All rights reserved.
//  Error enum about errors type of network.

import Foundation

enum ErrorType: Error {
    case parseUrlFail
    case notFound
    case validationError
    case serverError
    case defaultError
    
    var errorDescription: String? {
        switch self {
        case .parseUrlFail:
            return "Cannot initial URL object."
        case .notFound:
            return "Not Found"
        case .validationError:
            return "Validation Errors"
        case .serverError:
            return "Internal Server Error"
        case .defaultError:
            return "Something went wrong."
        }
    }
}
