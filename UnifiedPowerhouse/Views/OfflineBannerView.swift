import SwiftUI

struct OfflineBannerView: View {
    @EnvironmentObject var webSocketManager: WebSocketManager
    @State private var showingCachedData = false
    
    var body: some View {
        if !webSocketManager.isConnected {
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "wifi.slash")
                        .foregroundColor(Color(hex: "#f59e0b"))
                    
                    Text("Offline Mode")
                        .font(.caption)
                        .foregroundColor(Color(hex: "#f59e0b"))
                    
                    Spacer()
                    
                    Button(action: {
                        showingCachedData = true
                    }) {
                        Text("View Cached")
                            .font(.caption)
                            .foregroundColor(Color(hex: "#6366f1"))
                    }
                }
                
                if let lastUpdate = OfflineCacheManager.shared.getLastUpdateTime() {
                    Text("Last updated: \(lastUpdate.formatted())")
                        .font(.caption2)
                        .foregroundColor(Color(hex: "#64748b"))
                }
            }
            .padding()
            .background(Color(hex: "#1a1a2e"))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(hex: "#f59e0b").opacity(0.3), lineWidth: 1)
            )
            .padding(.horizontal)
            .sheet(isPresented: $showingCachedData) {
                CachedDataView()
            }
        }
    }
}

struct CachedDataView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section("Cached Agents") {
                    ForEach(OfflineCacheManager.shared.getCachedAgents()) { agent in
                        Text(agent.name)
                    }
                }
                
                Section("Cached Metrics") {
                    if let metrics = OfflineCacheManager.shared.getCachedMetrics() {
                        Text("CPU: \(String(format: "%.1f", metrics.cpu))%")
                        Text("Memory: \(String(format: "%.1f", metrics.memory))%")
                    }
                }
                
                Section("Cached PM2 Processes") {
                    ForEach(OfflineCacheManager.shared.getCachedPM2Processes()) { process in
                        Text(process.name)
                    }
                }
                
                Section("Cached Docker Containers") {
                    ForEach(OfflineCacheManager.shared.getCachedDockerContainers()) { container in
                        Text(container.names)
                    }
                }
            }
            .navigationTitle("Cached Data")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
