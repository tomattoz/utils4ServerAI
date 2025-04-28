//  Created by Ivan Kh on 31.10.2024.

import Vapor
import OpenAIKit
import Utils9AIAdapter
import Utils9

class CompletionsResponse: ChatAsyncResponseEncodable {
    let providerID: String
    let response: Response
    let stream: AsyncThrowingStream<ChatStream, any Error>
    
    init(providerID: String,
         response: Response,
         stream: AsyncThrowingStream<ChatStream, any Error>) {
        self.providerID = providerID
        self.stream = stream
        self.response = response
    }
    
    override func encodeResponse(for request: Vapor.Request) async throws -> Vapor.Response {
        let stream = stream
        let providerID = providerID
        
        response.body = Response.Body(stream: { writer in
            Task {
                do {
                    for try await element in stream {
                        let dto = ChatDTO.PartialResponse(element, providerID: providerID)
                        let data = try ChatDTO.PartialResponse.headerData + JSONEncoder().encode(dto)

                        _ = writer.write(.buffer(.init(data: data)))
                    }
                    
                    _ = writer.write(.end)
                }
                catch {
                    _ = writer.write(.error(error))
                }
            }
        })
        
        return response
    }
}

