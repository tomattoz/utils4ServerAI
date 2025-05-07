//  Created by Ivan Khvorostinin on 22.01.2025.

import Foundation
import OpenAIKit
import Utils9AIAdapter

public extension Chat.Message {
    init(_ src: ChatDTO.Message) {
        switch src {
        case .system(let content): self = .system(content: content)
        case .user(let content): self = .user(content: content)
        case .assistant(let content): self = .assistant(content: content)
        }
    }
    
    var isUser: Bool {
        switch self {
        case .user: true
        default: false
        }
    }

    var isSystem: Bool {
        switch self {
        case .system: true
        default: false
        }
    }
    
    var isAssistant: Bool {
        switch self {
        case .assistant: true
        default: false
        }
    }
}

public extension ChatDTO.Message {
    init(_ src: Chat.Message) {
        switch src {
        case .system(let content): self = .system(content: content)
        case .user(let content): self = .user(content: content)
        case .assistant(let content): self = .assistant(content: content)
        }
    }
}

public extension Array where Element == ChatDTO.Message {
    var openaikit: [Chat.Message] {
        map { .init($0) }
    }
}

public extension Array where Element == Chat.Message {
    var assistantsOrSystem: Self {
        filter { $0.isSystem || $0.isAssistant }
    }
    
    var user: Self {
        filter { $0.isUser }
    }
}
