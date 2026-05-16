import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var webSocketManager: WebSocketManager
    
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Image(systemName: "square.grid.2x2")
                    Text("Dashboard")
                }
            
            TerminalView()
                .tabItem {
                    Image(systemName: "terminal")
                    Text("Terminal")
                }
            
            ProcessesView()
                .tabItem {
                    Image(systemName: "server.rack")
                    Text("Processes")
                }
            
            ChatView()
                .tabItem {
                    Image(systemName: "bubble.left.and.bubble.right")
                    Text("Chat")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
        .accentColor(Color(hex: "#6366f1"))
        .onAppear {
            webSocketManager.connect()
        }
    }
}
