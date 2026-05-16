import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var showingLogoutConfirmation = false
    
    var body: some View {
        NavigationView {
            List {
                // Connection Section
                Section(header: Text("CONNECTION")) {
                    HStack {
                        Text("WebSocket Status")
                        Spacer()
                        Text(WebSocketManager.shared.isConnected ? "Connected" : "Disconnected")
                            .foregroundColor(WebSocketManager.shared.isConnected ? Color(hex: "#22c55e") : Color(hex: "#ef4444"))
                    }
                    
                    HStack {
                        Text("Server URL")
                        Spacer()
                        Text("dashboard.cortexbuildpro.com")
                            .foregroundColor(Color(hex: "#64748b"))
                    }
                }
                
                // Account Section
                Section(header: Text("ACCOUNT")) {
                    HStack {
                        Text("Logged in as")
                        Spacer()
                        Text("admin")
                            .foregroundColor(Color(hex: "#64748b"))
                    }
                    
                    Button(action: {
                        showingLogoutConfirmation = true
                    }) {
                        HStack {
                            Text("Logout")
                                .foregroundColor(Color(hex: "#ef4444"))
                            Spacer()
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .foregroundColor(Color(hex: "#ef4444"))
                        }
                    }
                }
                
                // About Section
                Section(header: Text("ABOUT")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("2.0.0")
                            .foregroundColor(Color(hex: "#64748b"))
                    }
                    
                    HStack {
                        Text("Build")
                        Spacer()
                        Text("2026.05.16")
                            .foregroundColor(Color(hex: "#64748b"))
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .background(Color(hex: "#0a0a0f").ignoresSafeArea())
            .alert(isPresented: $showingLogoutConfirmation) {
                Alert(
                    title: Text("Logout"),
                    message: Text("Are you sure you want to logout?"),
                    primaryButton: .destructive(Text("Logout")) {
                        authManager.logout()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}
