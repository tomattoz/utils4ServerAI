//  Created by Ivan Khvorostinin on 06.05.2025.

import Foundation
import OpenAIKit
import Utils9AIAdapter

public extension APIError {
    init(_ src: OpenAIAPIError) {
        let data = try! JSONEncoder().encode(src)
        self = try! JSONDecoder().decode(APIError.self, from: data)
    }
}

public extension OpenAIAPIError {
    init(_ src: APIError) {
        self.init(message: src.message, type: src.type, param: src.param, code: src.code)
    }
}
