//  Created by Ivan Khvorostinin on 05.05.2025.

import Vapor
import AsyncHTTPClient
import OpenAIKit
import Utils9AIAdapter
import Utils9AIFirestore
import Utils9

extension Provider.OpenAI {
    open class WebBase: Base, @unchecked Sendable {
        public override var id: String { "openai_web_\(access.email)" }
        let access: ChatgptAccess
        
        public init(_ access: ChatgptAccess) {
            self.access = access
        }
        
        open override func process(_ error: Error, request: Vapor.Request) async -> Error {
            let error = await super.process(error, request: request)
            let access = access
            
            if let error = error as? APIError,
               [ "cf_chl_opt", "token_expired" ].contains(error.code) {
                Task {
                    do {
                        var request = HTTPClientRequest(url: URL.chatGPTauth.absoluteString)
                        let requestBytes = ByteBuffer(string: access.email)
                        
                        request.headers.add(name: .httpHeaderContentType, value: "text/plain")
                        request.body = .bytes(requestBytes)
                        request.method = .POST
                        _ = try await HTTPClient.shared.execute(request, timeout: .seconds(5))
                        
                        log("[\(id)] CHATGPT AUTH SENT")
                    }
                    catch {
                        log("[\(id)] CHATGPT AUTH FAIL")
                        log(error)
                    }
                }
            }
            
            return error
        }
        
        override func openai(for request: Vapor.Request) -> OpenAIKit.Client {
            request.openaiWeb(access)
        }
    }
}
