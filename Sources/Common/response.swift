//  Created by Ivan Khvorostinin on 05.05.2025.

import Vapor
import Utils9AIAdapter

open class ChatAsyncResponseEncodable: AsyncResponseEncodable {
    public init() {}
    
    open func encodeResponse(for request: Vapor.Request) async throws -> Vapor.Response {
        throw ContentError.unsupported
    }
}
