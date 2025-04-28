//
//  File.swift
//  
//
//  Created by Ivan Kh on 11.10.2024.
//

import Foundation
import Vapor

private final class HttpClientStorageKey: StorageKey, Sendable {
    typealias Value = HTTPClient
}

extension Application {
    var httpClient: HTTPClient {
        get {
            guard let result = storage[HttpClientStorageKey.self] else {
                let httpClient = HTTPClient(eventLoopGroupProvider: .shared(eventLoopGroup))
                storage.set(HttpClientStorageKey.self, to: httpClient) { _ in
                    try? httpClient.syncShutdown()
                }
                return httpClient
            }
            
            return result
        }
        set {
            storage[HttpClientStorageKey.self] = newValue
        }
    }
}
