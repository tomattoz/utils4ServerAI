//  Created by Ivan Khvorostinin on 29.01.2025.

import Vapor
import AsyncHTTPClient
import OpenAIKit
import Utils9AIAdapter
import Utils9

public extension Provider { struct OpenAI {} }

extension Provider.OpenAI {
    open class Base: @unchecked Sendable {
        public var id: String {
            "base"
        }
        
        public init() {
        }
        
        func openai(for request: Vapor.Request) -> OpenAIKit.Client {
            request.openaiAPI
        }
        
        open func query(for request: Vapor.Request, data: ChatDTO.Request) async throws -> ChatQuery {
            .init(modelID: Model.auto, messages: [], parentMessageID: nil, conversationID: nil)
        }
        
        open func process(_ error: Error, request: Vapor.Request) async -> Error {
            log(error: "[\(id)] provider")
            return error
        }
        
        func answer(req: Vapor.Request, data: ChatDTO.Request) async throws
        -> ChatDTO.Response {
            try await exec(request: req, method: "ANSWER") {
                let query = try await query(for: req, data: data)
                let response = try await openai(for: req).chats.create(query)
                
                return .init(response, providerID: id)
            }
        }
        
        func answerStream(req: Vapor.Request, data: ChatDTO.Request) async throws
        -> ChatAsyncResponseEncodable {
            try await exec(request: req, method: "STREAM") {
                let openai = openai(for: req)
                let response = Response(status: .ok)
                let query = try await query(for: req, data: data)
                let stream = try await openai.chats.stream(query)
                
                return CompletionsResponse(providerID: id, response: response, stream: stream)
            }
        }
        
        func download(req: Vapor.Request, data: FileDTO.Request) async throws
        -> Response {
            throw ContentError.unsupported
        }

        private func exec<T>(request: Vapor.Request,
                             method: String,
                             _ block: () async throws -> T) async throws -> T {
            do {
                let result = try await block()
                log("[\(id)] \(method) SUCCESS")
                return result
            }
            catch {
                log("[\(id)] \(method) ERROR")
                throw await process(error, request: request)
            }
        }
    }
}

extension Provider.OpenAI {
    public struct Adapter: Provider.Proto, Sendable {
        let adapter: Base
        
        public init(_ adapter: Base) {
            self.adapter = adapter
        }
        
        public var id: String {
            adapter.id
        }
        
        public func answer(req: Vapor.Request, data: ChatDTO.Request) async throws
        -> ChatDTO.Response {
            try await adapter.answer(req: req, data: data)
        }
        
        public func answerStream(req: Vapor.Request, data: ChatDTO.Request) async throws
        -> ChatAsyncResponseEncodable {
            try await adapter.answerStream(req: req, data: data)
        }
        
        public func download(req: Vapor.Request, data: FileDTO.Request) async throws
        -> Response {
            try await adapter.download(req: req, data: data)
        }
    }
}

