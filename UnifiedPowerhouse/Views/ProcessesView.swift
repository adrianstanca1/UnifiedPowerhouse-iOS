import SwiftUI

struct ProcessesView: View {
    @EnvironmentObject var webSocketManager: WebSocketManager
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Segmented control
                Picker("View", selection: $selectedTab) {
                    Text("PM2").tag(0)
                    Text("Docker").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .background(Color(hex: "#12121a"))
                
                if selectedTab == 0 {
                    PM2ProcessList()
                } else {
                    DockerContainerList()
                }
            }
            .navigationTitle("Processes")
            .navigationBarTitleDisplayMode(.large)
            .background(Color(hex: "#0a0a0f").ignoresSafeArea())
        }
    }
}

struct PM2ProcessList: View {
    @EnvironmentObject var webSocketManager: WebSocketManager
    
    var body: some View {
        List(webSocketManager.pm2Processes) { process in
            PM2ProcessRow(process: process)
                .listRowBackground(Color(hex: "#12121a"))
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
        }
        .listStyle(PlainListStyle())
        .background(Color(hex: "#0a0a0f"))
    }
}

struct PM2ProcessRow: View {
    let process: PM2Process
    
    var body: some View {
        HStack(spacing: 12) {
            // Status indicator
            Circle()
                .fill(statusColor)
                .frame(width: 8, height: 8)
                .shadow(color: statusColor.opacity(0.5), radius: 4)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(process.name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                
                Text("PID: \(process.pid)")
                    .font(.caption2)
                    .foregroundColor(Color(hex: "#64748b"))
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(String(format: "%.1f", process.cpu))%")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color(hex: "#6366f1"))
                    Text("CPU")
                        .font(.caption2)
                        .foregroundColor(Color(hex: "#64748b"))
                }
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text(formattedMemory)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color(hex: "#22c55e"))
                    Text("MEM")
                        .font(.caption2)
                        .foregroundColor(Color(hex: "#64748b"))
                }
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(process.restarts)")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color(hex: "#94a3b8"))
                    Text("Restarts")
                        .font(.caption2)
                        .foregroundColor(Color(hex: "#64748b"))
                }
            }
        }
        .padding()
        .background(Color(hex: "#12121a"))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(hex: "#2a2a4a"), lineWidth: 1)
        )
    }
    
    var statusColor: Color {
        switch process.status {
        case "online": return Color(hex: "#22c55e")
        case "stopped": return Color(hex: "#ef4444")
        case "errored": return Color(hex: "#f59e0b")
        default: return Color(hex: "#94a3b8")
        }
    }
    
    var formattedMemory: String {
        let mb = Double(process.memory) / 1024 / 1024
        return String(format: "%.1f MB", mb)
    }
}

struct DockerContainerList: View {
    @EnvironmentObject var webSocketManager: WebSocketManager
    
    var body: some View {
        List(webSocketManager.dockerContainers) { container in
            DockerContainerRow(container: container)
                .listRowBackground(Color(hex: "#12121a"))
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
        }
        .listStyle(PlainListStyle())
        .background(Color(hex: "#0a0a0f"))
    }
}

struct DockerContainerRow: View {
    let container: DockerContainer
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(statusColor)
                .frame(width: 8, height: 8)
                .shadow(color: statusColor.opacity(0.5), radius: 4)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(container.names)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(container.image)
                    .font(.caption2)
                    .foregroundColor(Color(hex: "#64748b"))
                    .lineLimit(1)
            }
            
            Spacer()
            
            Text(formattedStatus)
                .font(.caption)
                .foregroundColor(statusColor)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(statusColor.opacity(0.2))
                .cornerRadius(4)
        }
        .padding()
        .background(Color(hex: "#12121a"))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(hex: "#2a2a4a"), lineWidth: 1)
        )
    }
    
    var statusColor: Color {
        if container.status.contains("healthy") { return Color(hex: "#22c55e") }
        if container.status.contains("unhealthy") { return Color(hex: "#ef4444") }
        if container.status.contains("Up") { return Color(hex: "#06b6d4") }
        return Color(hex: "#f59e0b")
    }
    
    var formattedStatus: String {
        if container.status.contains("healthy") { return "Healthy" }
        if container.status.contains("unhealthy") { return "Unhealthy" }
        if container.status.contains("Up") { return "Running" }
        return container.status
    }
}
