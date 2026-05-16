import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var webSocketManager: WebSocketManager
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Connection Status
                    ConnectionStatusBar()
                    
                    // Agents Section
                    AgentsSection()
                    
                    // Metrics Section
                    MetricsSection()
                    
                    // Quick Actions
                    QuickActionsSection()
                }
                .padding()
            }
            .background(Color(hex: "#0a0a0f").ignoresSafeArea())
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        AuthManager.shared.logout()
                    }) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .foregroundColor(Color(hex: "#ef4444"))
                    }
                }
            }
        }
    }
}

struct ConnectionStatusBar: View {
    @EnvironmentObject var webSocketManager: WebSocketManager
    
    var body: some View {
        HStack {
            Circle()
                .fill(webSocketManager.isConnected ? Color(hex: "#22c55e") : Color(hex: "#ef4444"))
                .frame(width: 8, height: 8)
                .shadow(color: webSocketManager.isConnected ? Color(hex: "#22c55e").opacity(0.5) : Color(hex: "#ef4444").opacity(0.5), radius: 4)
            
            Text(webSocketManager.isConnected ? "Live Connection" : "Disconnected")
                .font(.caption)
                .foregroundColor(webSocketManager.isConnected ? Color(hex: "#22c55e") : Color(hex: "#ef4444"))
            
            Spacer()
            
            Text("Unified Powerhouse")
                .font(.caption2)
                .foregroundColor(Color(hex: "#64748b"))
        }
        .padding()
        .background(Color(hex: "#12121a"))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(hex: "#2a2a4a"), lineWidth: 1)
        )
    }
}

struct AgentsSection: View {
    @EnvironmentObject var webSocketManager: WebSocketManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Active Agents")
                .font(.headline)
                .foregroundColor(.white)
            
            ForEach(webSocketManager.agents) { agent in
                AgentCard(agent: agent)
            }
        }
    }
}

struct AgentCard: View {
    let agent: Agent
    @State private var isAnimating = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Status indicator with pulse animation
            ZStack {
                Circle()
                    .fill(statusColor)
                    .frame(width: 12, height: 12)
                
                Circle()
                    .fill(statusColor)
                    .frame(width: 12, height: 12)
                    .scaleEffect(isAnimating ? 1.5 : 1.0)
                    .opacity(isAnimating ? 0.0 : 0.5)
                    .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: false), value: isAnimating)
            }
            .frame(width: 20, height: 20)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(agent.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(agent.role.uppercased())
                    .font(.caption2)
                    .foregroundColor(Color(hex: "#6366f1"))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color(hex: "#6366f1").opacity(0.2))
                    .cornerRadius(4)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(agent.status.capitalized)
                    .font(.caption)
                    .foregroundColor(statusColor)
                
                Text(agent.activity)
                    .font(.caption2)
                    .foregroundColor(Color(hex: "#64748b"))
            }
        }
        .padding()
        .background(Color(hex: "#12121a"))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(hex: "#2a2a4a"), lineWidth: 1)
        )
        .onAppear {
            isAnimating = true
        }
    }
    
    var statusColor: Color {
        switch agent.status {
        case "running": return Color(hex: "#22c55e")
        case "ready": return Color(hex: "#06b6d4")
        case "busy": return Color(hex: "#f59e0b")
        case "error": return Color(hex: "#ef4444")
        default: return Color(hex: "#64748b")
        }
    }
}

struct MetricsSection: View {
    @EnvironmentObject var webSocketManager: WebSocketManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("System Metrics")
                .font(.headline)
                .foregroundColor(.white)
            
            if let metrics = webSocketManager.metrics {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    MetricCard(title: "CPU", value: metrics.cpu, color: "#6366f1", unit: "%")
                    MetricCard(title: "Memory", value: metrics.memory, color: "#22c55e", unit: "%")
                    MetricCard(title: "Disk", value: metrics.disk, color: "#f59e0b", unit: "%")
                    MetricCard(title: "Load", value: metrics.load.first ?? 0, color: "#06b6d4", unit: "")
                }
            }
        }
    }
}

struct MetricCard: View {
    let title: String
    let value: Double
    let color: String
    let unit: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(Color(hex: "#94a3b8"))
            
            Text("\(String(format: "%.1f", value))\(unit)")
                .font(.system(size: 24, weight: .bold, design: .monospaced))
                .foregroundColor(Color(hex: color))
            
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color(hex: "#1a1a2e"))
                        .cornerRadius(2)
                    
                    Rectangle()
                        .fill(Color(hex: color))
                        .frame(width: min(CGFloat(value) / 100.0 * geometry.size.width, geometry.size.width))
                        .cornerRadius(2)
                }
            }
            .frame(height: 4)
        }
        .padding()
        .background(Color(hex: "#12121a"))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(hex: "#2a2a4a"), lineWidth: 1)
        )
    }
}

struct QuickActionsSection: View {
    @EnvironmentObject var webSocketManager: WebSocketManager
    
    let actions = [
        ("Sync", "arrow.triangle.2.circlepath", "#6366f1"),
        ("Health", "heart.text.square", "#22c55e"),
        ("Status", "chart.bar", "#06b6d4"),
        ("Deploy", "rocket", "#f59e0b")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .font(.headline)
                .foregroundColor(.white)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(actions, id: \.0) { action in
                    QuickActionButton(
                        title: action.0,
                        icon: action.1,
                        color: action.2
                    ) {
                        webSocketManager.sendCommand(action.0.lowercased())
                    }
                }
            }
        }
    }
}

struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(Color(hex: color))
                
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding()
            .background(Color(hex: "#12121a"))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(hex: "#2a2a4a"), lineWidth: 1)
            )
        }
    }
}
