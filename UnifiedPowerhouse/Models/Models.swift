import Foundation

struct Agent: Identifiable, Codable {
    let id: String
    let name: String
    let status: String
    let role: String
    var activity: String
    let pid: Int?
}

struct SystemMetrics: Codable {
    let cpu: Double
    let memory: Double
    let disk: Double
    let load: [Double]
    let timestamp: TimeInterval?
    
    init(cpu: Double, memory: Double, disk: Double, load: [Double]) {
        self.cpu = cpu
        self.memory = memory
        self.disk = disk
        self.load = load
        self.timestamp = Date().timeIntervalSince1970
    }
}

struct LogEntry: Identifiable {
    let id = UUID()
    let timestamp: String
    let level: String
    let message: String
    let source: String
}

struct ChatMessage: Identifiable {
    let id: UUID
    let sender: String
    let content: String
    let timestamp: Date
    var isUser: Bool { sender.lowercased() == "user" }

    init(id: UUID = UUID(), sender: String, content: String, timestamp: Date) {
        self.id = id
        self.sender = sender
        self.content = content
        self.timestamp = timestamp
    }
}

struct PM2Process: Identifiable, Codable {
    let id = UUID()
    let name: String
    let pid: Int
    let status: String
    let cpu: Double
    let memory: Int
    let uptime: Int
    let restarts: Int
}

struct DockerContainer: Identifiable, Codable {
    let id = UUID()
    let names: String
    let image: String
    let status: String
}

struct CommandResult: Identifiable {
    let id = UUID()
    let command: String
    let output: String
    let success: Bool
}
