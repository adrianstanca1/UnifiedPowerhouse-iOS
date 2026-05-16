import Foundation
import Combine

class WebSocketManager: ObservableObject {
    static let shared = WebSocketManager()
    
    @Published var isConnected = false
    @Published var agents: [Agent] = []
    @Published var metrics: SystemMetrics?
    @Published var logs: [LogEntry] = []
    @Published var chatMessages: [ChatMessage] = []
    @Published var pm2Processes: [PM2Process] = []
    @Published var dockerContainers: [DockerContainer] = []
    @Published var commandResult: CommandResult?
    
    private var webSocketTask: URLSessionWebSocketTask?
    private let baseURL = "wss://dashboard.cortexbuildpro.com/ws"
    private var reconnectTimer: Timer?
    private var heartbeatTimer: Timer?
    
    func connect() {
        guard let token = AuthManager.shared.token,
              let url = URL(string: baseURL) else { return }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        webSocketTask = URLSession.shared.webSocketTask(with: request)
        webSocketTask?.delegate = self
        webSocketTask?.resume()
        
        receiveMessage()
        startHeartbeat()
    }
    
    func disconnect() {
        reconnectTimer?.invalidate()
        heartbeatTimer?.invalidate()
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
        isConnected = false
    }
    
    func sendCommand(_ command: String) {
        let message: [String: Any] = [
            "type": "command",
            "command": command
        ]
        send(message)
    }
    
    func sendChatMessage(_ message: String) {
        let data: [String: Any] = [
            "type": "chat",
            "message": message,
            "sender": "user"
        ]
        send(data)
    }
    
    private func send(_ data: [String: Any]) {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: data) else { return }
        webSocketTask?.send(.data(jsonData)) { _ in }
    }
    
    private func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .success(let message):
                self?.handleMessage(message)
                self?.receiveMessage()
            case .failure(let error):
                print("WebSocket error: \(error)")
                self?.scheduleReconnect()
            }
        }
    }
    
    private func handleMessage(_ message: URLSessionWebSocketTask.Message) {
        guard case .string(let text) = message,
              let data = text.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
        
        DispatchQueue.main.async {
            guard let type = json["type"] as? String else { return }
            
            switch type {
            case "agents":
                if let agentsData = json["agents"] as? [String: [String: Any]] {
                    self.agents = agentsData.map { key, value in
                        Agent(
                            id: key,
                            name: key.capitalized,
                            status: value["status"] as? String ?? "unknown",
                            role: value["role"] as? String ?? "",
                            activity: value["activity"] as? String ?? "idle",
                            pid: value["pid"] as? Int
                        )
                    }
                }
            case "metrics":
                if let metricsData = json["metrics"] as? [String: Any] {
                    self.metrics = SystemMetrics(
                        cpu: metricsData["cpu"] as? Double ?? 0,
                        memory: metricsData["memory"] as? Double ?? 0,
                        disk: metricsData["disk"] as? Double ?? 0,
                        load: metricsData["load"] as? [Double] ?? [0, 0, 0]
                    )
                }
            case "log":
                if let logData = json["log"] as? [String: Any] {
                    self.logs.append(LogEntry(
                        timestamp: logData["timestamp"] as? String ?? "",
                        level: logData["level"] as? String ?? "info",
                        message: logData["message"] as? String ?? "",
                        source: logData["source"] as? String ?? ""
                    ))
                    if self.logs.count > 500 {
                        self.logs.removeFirst(self.logs.count - 500)
                    }
                }
            case "chat":
                if let chatData = json["message"] as? String,
                   let sender = json["sender"] as? String {
                    self.chatMessages.append(ChatMessage(
                        id: UUID(),
                        sender: sender,
                        content: chatData,
                        timestamp: Date()
                    ))
                }
            case "command_result":
                self.commandResult = CommandResult(
                    command: json["command"] as? String ?? "",
                    output: json["output"] as? String ?? "",
                    success: json["success"] as? Bool ?? false
                )
            default:
                break
            }
        }
    }
    
    private func startHeartbeat() {
        heartbeatTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
            self?.send(["type": "ping"])
        }
    }
    
    private func scheduleReconnect() {
        reconnectTimer?.invalidate()
        reconnectTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { [weak self] _ in
            self?.connect()
        }
    }
}

extension WebSocketManager: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        DispatchQueue.main.async {
            self.isConnected = true
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        DispatchQueue.main.async {
            self.isConnected = false
            if error != nil {
                self.scheduleReconnect()
            }
        }
    }
}
