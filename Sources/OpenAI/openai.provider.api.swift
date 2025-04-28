//  Created by Ivan Khvorostinin on 05.05.2025.

extension Provider.OpenAI {
    open class APIBase: Base, @unchecked Sendable {
        public override var id: String { "openai_api" }
    }
}
