//  Created by Ivan Khvorostinin on 28.04.2025.

import Vapor
import Utils9
import Utils9AIAdapter

public struct Provider {}
extension Provider { public typealias Proto = ChatProvider }

public protocol ChatProvider: Sendable, Identifiable {
    var id: String { get }
    func answer(req: Request, data: ChatDTO.Request) async throws -> ChatDTO.Response
    func answerStream(req: Request, data: ChatDTO.Request) async throws -> ChatAsyncResponseEncodable
}

extension Provider {
    public struct Unsupported: Proto {
        public init() {}
        
        public var id: String {
            "unsupported"
        }
        
        public func answer(req: Request, data: ChatDTO.Request) async throws -> ChatDTO.Response {
            throw ContentError.unsupported
        }
        
        public func answerStream(req: Request, data: ChatDTO.Request) async throws -> ChatAsyncResponseEncodable {
            throw ContentError.unsupported
        }
    }
}

extension Provider {
    public struct Array: Proto {
        let array: [any Proto]
        let preffered: String?
        
        public init(preffered: String?, _ array: [any Proto]) {
            self.array = array
            self.preffered = preffered
        }
        
        private func exec<T>(req: Vapor.Request,
                             data: ChatDTO.Request,
                             exec: (any Proto) async throws -> T) async throws -> T {
            var resultError: Error?
            var array = array
            var data = data
            
            if let provider = array.first(where: { $0.id == preffered }) {
                do {
                    return try await exec(provider)
                }
                catch {
                    resultError = error
                    log(error)
                }
                
                array.removeAll { $0.id == preffered }
                data = data.copy(conversation: nil)
            }
            
            for provider in array {
                do {
                    return try await exec(provider)
                }
                catch {
                    resultError = error
                    log(error)
                }
            }
            
            if let resultError {
                throw resultError
            }
            else {
                throw ContentError.empty
            }
        }
        
        public var id: String {
            "array"
        }
        
        public func answer(req: Vapor.Request, data: ChatDTO.Request) async throws
        -> ChatDTO.Response {
            try await exec(req: req, data: data) {
                try await $0.answer(req: req, data: data)
            }
        }
        
        public func answerStream(req: Vapor.Request, data: ChatDTO.Request) async throws
        -> ChatAsyncResponseEncodable {
            try await exec(req: req, data: data) {
                try await $0.answerStream(req: req, data: data)
            }
        }
    }
}
