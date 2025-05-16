//  Created by Ivan Kh on 21.08.2024.

import Vapor
import OpenAIKit
import Utils9AIAdapter
import Utils9AIFirestore

extension Model {
    public enum Gismo: String, ModelID {
        case dalle = "gpt-4o-gizmo-g-2fkFE8rbu"
    }
}

extension Model {
    public struct Generic: ModelID {
        public let id: String
        public init(id: String) { self.id = id }
    }
}

public extension Model {
    static var auto: ModelID {
        Generic(id: "auto")
    }
}

public struct ChatQuery {
    public let modelID: ModelID
    public let messages: [Chat.Message]
    public let responseFormat: Chat.ResponseFormat?
    public let webSearchOptions: Chat.WebSearchOptions?
    public let parentMessageID: String?
    public let conversationID: String?
    
    public init(modelID: ModelID,
                messages: [Chat.Message],
                parentMessageID: String?,
                conversationID: String?,
                responseFormat: Chat.ResponseFormat? = nil,
                webSearchOptions: Chat.WebSearchOptions? = nil) {
        self.modelID = modelID
        self.messages = messages
        self.parentMessageID = parentMessageID
        self.conversationID = conversationID
        self.responseFormat = responseFormat
        self.webSearchOptions = webSearchOptions
    }
}

extension OpenAIKit.ChatProvider {
    func create(_ query: ChatQuery) async throws -> Chat {
        try await create(model: query.modelID,
                         messages: query.messages,
                         responseFormat: query.responseFormat,
                         webSearchOptions: query.webSearchOptions,
                         parentMessageID: query.parentMessageID,
                         conversationID: query.conversationID)
    }
    
    func stream(_ query: ChatQuery) async throws -> AsyncThrowingStream<ChatStream, any Error> {
        try await stream(model: query.modelID,
                         messages: query.messages,
                         responseFormat: query.responseFormat,
                         webSearchOptions: query.webSearchOptions,
                         parentMessageID: query.parentMessageID,
                         conversationID: query.conversationID)
    }
}
