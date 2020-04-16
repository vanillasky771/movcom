//
//  Support.swift
//  movcom
//
//  Created by Ivan on 15/04/20.
//  Copyright © 2020 ivan. All rights reserved.
//

import Foundation

enum Results<T, E: Error> {
    case ok(T)
    case error(E)
}

enum FetchError: Error {
    case load(Error)
    case noData
    case deserialization(Error)
}

extension FetchError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .load(_):
            return NSLocalizedString("fetchError.load", comment: "")
        case .deserialization(_):
            return NSLocalizedString("fetchError.deserialization", comment: "")
        case .noData:
            return NSLocalizedString("fetchError.noData", comment: "")
        }
    }
}

func handleFetchResponse<T: Decodable>(data: Data?, networkError: Error?) -> Results<T, FetchError> {
    if let networkError = networkError {
        return .error(FetchError.load(networkError))
    }
    
    guard let data = data else {
        return .error(FetchError.noData)
    }
    
    do {
        let response = try JSONDecoder().decode(T.self, from: data)
        return .ok(response)
    } catch {
        return .error(FetchError.deserialization(error))
    }
}

