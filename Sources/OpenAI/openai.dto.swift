//  Created by Ivan Khvorostinin on 23.01.2025.

import Vapor
import OpenAIKit
import Utils9AIAdapter

extension ChatDTO.Response {
    init(_ src: Chat, providerID: String) {
        self.init(message: src.choices.first?.message.content ?? "",
                  provider: providerID,
                  conversation: .init(ID: src.conversationId,
                                      targetMessageID: src.messageId))
    }
}

extension ChatDTO.PartialResponse {
    init(_ src: ChatStream, providerID: String?) {
        self.init(message: src.choices.first?.delta.content ?? "",
                  provider: providerID,
                  conversation: .init(ID: src.conversationId,
                                      targetMessageID: src.messageId))
    }
}

extension ChatDTO.Request: Content {
}
