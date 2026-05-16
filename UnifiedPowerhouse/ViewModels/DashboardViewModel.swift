import Foundation
import Combine

class DashboardViewModel: ObservableObject {
    @Published var agents: [Agent] = []
    @Published var metrics: SystemMetrics?
    @Published var logs: [LogEntry] = []
    @Published var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchMetrics() {
        guard let url = URL(string: "https://dashboard.cortexbuildpro.com/api/metrics") else { return }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(AuthManager.shared.token ?? "")", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            DispatchQueue.main.async {
                if let data = data {
                    if let metrics = try? JSONDecoder().decode(SystemMetrics.self, from: data) {
                        self?.metrics = metrics
                    }
                }
            }
        }.resume()
    }
    
    func fetchPM2Processes() {
        guard let url = URL(string: "https://dashboard.cortexbuildpro.com/api/pm2") else { return }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(AuthManager.shared.token ?? "")", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            DispatchQueue.main.async {
                // Parse PM2 processes
            }
        }.resume()
    }
    
    func fetchDockerContainers() {
        guard let url = URL(string: "https://dashboard.cortexbuildpro.com/api/docker") else { return }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(AuthManager.shared.token ?? "")", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            DispatchQueue.main.async {
                // Parse Docker containers
            }
        }.resume()
    }
}
