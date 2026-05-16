import Foundation
import Combine

class AuthManager: ObservableObject {
    static let shared = AuthManager()
    
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let baseURL = "https://dashboard.cortexbuildpro.com"
    private let tokenKey = "auth_token"
    
    var token: String? {
        get { UserDefaults.standard.string(forKey: tokenKey) }
        set { UserDefaults.standard.set(newValue, forKey: tokenKey) }
    }
    
    init() {
        isAuthenticated = token != nil
    }
    
    func login(username: String, password: String) {
        isLoading = true
        errorMessage = nil
        
        guard let url = URL(string: "\(baseURL)/api/login") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["username": username, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    return
                }
                
                guard let data = data else {
                    self?.errorMessage = "No data received"
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let success = json["success"] as? Bool,
                       success,
                       let token = json["token"] as? String {
                        self?.token = token
                        self?.isAuthenticated = true
                    } else {
                        self?.errorMessage = "Invalid credentials"
                    }
                } catch {
                    self?.errorMessage = "Parse error"
                }
            }
        }.resume()
    }
    
    func logout() {
        token = nil
        isAuthenticated = false
        WebSocketManager.shared.disconnect()
    }
}
