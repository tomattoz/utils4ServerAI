//  Created by Ivan Khvorostinin on 29.01.2025.

import Vapor
import Utils9AIAdapter
import Utils9AIFirestore
import Utils9

extension ChatgptAccess {
    public static let tokens = LockedVar([ChatgptAccess]())    
}

public extension Request {
    func updateConfigIfNeeded() async {
        await ChatgptAccessUpdater.shared.updateConfigIfNeeded(self)
    }
}

final class ChatgptAccessUpdater: Sendable {
    static let shared = ChatgptAccessUpdater()
    nonisolated(unsafe) private var lastUpdateDate: Date?
    private let lock = NSLock()
    
    func updateConfigIfNeeded(_ request: Request) async {
        var lastUpdateDate: Date?
        
        lock.locked {
            lastUpdateDate = self.lastUpdateDate
        }
        
        if let lastUpdateDate, Date().timeIntervalSince(lastUpdateDate) < 60 /* 1 minute */ {
            return
        }
        
        do {
            try await updateConfig(request)
            
            lock.locked {
                self.lastUpdateDate = Date()
            }
        }
        catch {
            log(error: "Unable to update config from Firestore")
            log(error)
        }
    }
    
    private func updateConfig(_ request: Request) async throws {
        ChatgptAccess.tokens.value = try await ChatgptAccess.list(request.application.firestoreService)
    }

}

extension ChatgptAccess.Kind {
    public var isFree: Bool {
        switch self {
        case .free: true
        case .plus, .team: false
        }
    }
}
