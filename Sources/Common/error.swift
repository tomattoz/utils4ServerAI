//  Created by Ivan Kh on 22.08.2024.

import Foundation
import Vapor
import OpenAIKit
import Utils9
import Utils9AIAdapter

public final class JsonErrorMiddleware: AsyncMiddleware {
    public init() {}
    
    public func respond(to request: Vapor.Request,
                        chainingTo next: any Vapor.AsyncResponder) async throws -> Vapor.Response {
        do {
            return try await next.respond(to: request)
        }
        catch let error as HTTPError {
            return try Response(error: .http(error))
        }
        catch let error as RegistrationError {
            return try Response(error: .registration(error))
        }
        catch let error as ContentError {
            return try Response(error: .content(error))
        }
        catch let error as APIError {
            return try Response(error: .openai(.init(error)))
        }
        catch let error as OpenAIError {
            return try Response(error: .openai2(error))
        }
        catch {
            return try Response(error: .generic(.init(error)))
        }
    }
}

public final class ErrorLogMiddleware: AsyncMiddleware {
    public init() {}

    public func respond(to request: Vapor.Request,
                        chainingTo next: any Vapor.AsyncResponder) async throws -> Vapor.Response {
        do {
            return try await next.respond(to: request)
        }
        catch {
            log(error)
            throw error
        }
    }
}

private extension Response {
    convenience init(error: ServerError) throws {
        self.init(status: .internalServerError)
        body = .init(data: try JSONEncoder().encode(error))
    }
}
