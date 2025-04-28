//  Created by Ivan Kh on 12.09.2024.

import Foundation
import Vapor
import Utils9
import Utils9AIAdapter

extension Vapor.Request {
    private func validate(hash data: StringHashable) throws {
        guard data.stringHash(salt: .salt) != headers.first(name: .httpHeaderContentHash) else { return }
        
        log(HTTPError.invalidHash)
        throw HTTPError.invalidHash
    }
    
    public func decodeAndValidate<D: Decodable & StringHashable>(_: D.Type) throws -> D {
        return try content.decode(D.self)
    }
}
