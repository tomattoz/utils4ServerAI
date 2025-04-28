//  Created by Ivan Khvorostinin on 06.05.2025.

import Vapor
import OpenAIKit
import Utils9AIFirestore

private extension URL {
    static let chatGPTweb = URL(string: .urlChatGPTweb)!
}

extension Vapor.Request {
    var openaiAPI: OpenAIKit.Client {
        guard let result = storage[OpenAIStorageKey.self] else {
            let openai = OpenAIKit.Client(
                httpClient: application.httpClient,
                configuration: .init(apiKey: openaiKeyOrDefault))
            storage.set(OpenAIStorageKey.self, to: openai)
            return openai
        }
        
        return result
    }

    func openaiWeb(_ access: ChatgptAccess) -> OpenAIKit.Client {
        OpenAIKit.Client(
            httpClient: application.httpClient,
            configuration: .init(apiKey: access.token,
                                 api: .init(scheme: .custom(URL.chatGPTweb.scheme!),
                                            host: URL.chatGPTweb.host!)))
    }

    public var openaiKey: String? {
        headers.first(name: "openai_key")
    }
    
    var openaiKeyOrDefault: String {
        openaiKey ?? .apiKey
    }
}

private final class OpenAIStorageKey: StorageKey {
    typealias Value = OpenAIKit.Client
}

private final class OpenAIWebStorageKey: StorageKey {
    typealias Value = OpenAIKit.Client
}

private final class OpenAIWebStorageKeyFree: StorageKey {
    typealias Value = OpenAIKit.Client
}
