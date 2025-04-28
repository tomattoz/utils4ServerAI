//  Created by Ivan Khvorostinin on 29.04.2025.

import Foundation
import Vapor

extension String {
    static let salt = Environment.get("salt")!
    static let apiKey = Environment.get("openai_api_key")!
    static let urlChatGPTweb = Environment.get("chat2api_url")!
    static let urlChatGPTauth = Environment.get("chat_gpt_auth_url")!
}
