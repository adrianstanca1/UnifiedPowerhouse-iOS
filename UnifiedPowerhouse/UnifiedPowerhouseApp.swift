import SwiftUI

@main
struct UnifiedPowerhouseApp: App {
    @StateObject private var authManager = AuthManager.shared
    @StateObject private var webSocketManager = WebSocketManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authManager)
                .environmentObject(webSocketManager)
                .preferredColorScheme(.dark)
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        Group {
            if authManager.isAuthenticated {
                MainTabView()
            } else {
                LoginView()
            }
        }
    }
}
