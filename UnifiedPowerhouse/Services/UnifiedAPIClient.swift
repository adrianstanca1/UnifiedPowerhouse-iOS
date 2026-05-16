import Foundation

class UnifiedAPIClient {
    static let shared = UnifiedAPIClient()
    
    private let baseURL = "https://dashboard.cortexbuildpro.com"
    
    private func makeRequest(endpoint: String, method: String = "GET", body: [String: Any]? = nil) async throws -> Data {
        guard let url = URL(string: "\(baseURL)/api/\(endpoint)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = AuthManager.shared.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = body {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.init(rawValue: httpResponse.statusCode))
        }
        
        return data
    }
    
    func fetchMetrics() async throws -> SystemMetrics {
        let data = try await makeRequest(endpoint: "metrics")
        return try JSONDecoder().decode(SystemMetrics.self, from: data)
    }
    
    func fetchPM2Processes() async throws -> [PM2Process] {
        let data = try await makeRequest(endpoint: "pm2")
        return try JSONDecoder().decode([PM2Process].self, from: data)
    }
    
    func fetchDockerContainers() async throws -> [DockerContainer] {
        let data = try await makeRequest(endpoint: "docker")
        return try JSONDecoder().decode([DockerContainer].self, from: data)
    }
    
    func executeCommand(_ command: String) async throws -> String {
        let data = try await makeRequest(endpoint: "execute", method: "POST", body: ["command": command])
        if let json = try JSONSerialization.jsonObject(with: data) as? [String: String] {
            return json["output"] ?? ""
        }
        return ""
    }
    
    func checkHealth() async -> Bool {
        do {
            let (_, response) = try await URLSession.shared.data(from: URL(string: "\(baseURL)/health")!)
            return (response as? HTTPURLResponse)?.statusCode == 200
        } catch {
            return false
        }
    }
}
