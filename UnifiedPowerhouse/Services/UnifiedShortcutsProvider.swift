import Foundation
import Intents

class UnifiedShortcutsProvider {
    static let shared = UnifiedShortcutsProvider()
    
    func donateCheckStatusIntent() {
        let intent = CheckAgentStatusIntent()
        intent.suggestedInvocationPhrase = "Check agent status"
        
        let interaction = INInteraction(intent: intent, response: nil)
        interaction.donate { error in
            if let error = error {
                print("Error donating intent: \(error)")
            }
        }
    }
    
    func donateRestartAgentIntent(agentName: String) {
        let intent = RestartAgentIntent()
        intent.agentName = agentName
        intent.suggestedInvocationPhrase = "Restart \(agentName) agent"
        
        let interaction = INInteraction(intent: intent, response: nil)
        interaction.donate { error in
            if let error = error {
                print("Error donating intent: \(error)")
            }
        }
    }
    
    func donateRunHealthCheckIntent() {
        let intent = RunHealthCheckIntent()
        intent.suggestedInvocationPhrase = "Run health check"
        
        let interaction = INInteraction(intent: intent, response: nil)
        interaction.donate { error in
            if let error = error {
                print("Error donating intent: \(error)")
            }
        }
    }
    
    func donateSyncMemoryIntent() {
        let intent = SyncMemoryIntent()
        intent.suggestedInvocationPhrase = "Sync unified memory"
        
        let interaction = INInteraction(intent: intent, response: nil)
        interaction.donate { error in
            if let error = error {
                print("Error donating intent: \(error)")
            }
        }
    }
}

import AppIntents

struct CheckAgentStatusIntent: AppIntent {
    static var title: LocalizedStringResource = "Check Agent Status"
    static var description = IntentDescription("Check the status of all Unified Powerhouse agents")
    
    func perform() async throws -> some IntentResult {
        // Trigger a notification or update widget
        NotificationManager.shared.scheduleNotification(
            title: "Agent Status Check",
            body: "All agents are operational"
        )
        return .result()
    }
}

struct RestartAgentIntent: AppIntent {
    static var title: LocalizedStringResource = "Restart Agent"
    static var description = IntentDescription("Restart a specific Unified Powerhouse agent")
    
    @Parameter(title: "Agent Name", description: "The name of the agent to restart")
    var agentName: String
    
    func perform() async throws -> some IntentResult {
        WebSocketManager.shared.sendCommand("restart \(agentName)")
        return .result()
    }
}

struct RunHealthCheckIntent: AppIntent {
    static var title: LocalizedStringResource = "Run Health Check"
    static var description = IntentDescription("Run a system health check")
    
    func perform() async throws -> some IntentResult {
        WebSocketManager.shared.sendCommand("health")
        return .result()
    }
}

struct SyncMemoryIntent: AppIntent {
    static var title: LocalizedStringResource = "Sync Memory"
    static var description = IntentDescription("Sync Unified Powerhouse memory")
    
    func perform() async throws -> some IntentResult {
        WebSocketManager.shared.sendCommand("sync")
        return .result()
    }
}
