import WidgetKit
import SwiftUI

struct DashboardWidgetEntry: TimelineEntry {
    let date: Date
    let cpu: Double
    let memory: Double
    let activeAgents: Int
    let totalAgents: Int
}

struct DashboardWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> DashboardWidgetEntry {
        DashboardWidgetEntry(date: Date(), cpu: 45.0, memory: 60.0, activeAgents: 3, totalAgents: 3)
    }

    func getSnapshot(in context: Context, completion: @escaping (DashboardWidgetEntry) -> Void) {
        let entry = DashboardWidgetEntry(date: Date(), cpu: 45.0, memory: 60.0, activeAgents: 3, totalAgents: 3)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<DashboardWidgetEntry>) -> Void) {
        var entries: [DashboardWidgetEntry] = []
        let currentDate = Date()
        
        for hourOffset in 0..<12 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = DashboardWidgetEntry(
                date: entryDate,
                cpu: Double.random(in: 10...90),
                memory: Double.random(in: 20...80),
                activeAgents: Int.random(in: 2...3),
                totalAgents: 3
            )
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct DashboardWidgetView: View {
    var entry: DashboardWidgetEntry
    @Environment(.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(entry: entry)
        case .systemMedium:
            MediumWidgetView(entry: entry)
        case .systemLarge:
            LargeWidgetView(entry: entry)
        default:
            SmallWidgetView(entry: entry)
        }
    }
}

struct SmallWidgetView: View {
    let entry: DashboardWidgetEntry

    var body: some View {
        VStack(spacing: 8) {
            Text("⚡ Unified")
                .font(.caption)
                .foregroundColor(.white)
            
            HStack(spacing: 4) {
                VStack(alignment: .leading) {
                    Text("CPU")
                        .font(.caption2)
                    Text("\(String(format: "%.0f", entry.cpu))%")
                        .font(.title3)
                        .bold()
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("MEM")
                        .font(.caption2)
                    Text("\(String(format: "%.0f", entry.memory))%")
                        .font(.title3)
                        .bold()
                }
            }
            .foregroundColor(.white)
            
            Text("\(entry.activeAgents)/\(entry.totalAgents) agents")
                .font(.caption2)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.black)
    }
}

struct MediumWidgetView: View {
    let entry: DashboardWidgetEntry

    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Unified Powerhouse")
                    .font(.headline)
                
                HStack(spacing: 12) {
                    MetricWidgetItem(title: "CPU", value: entry.cpu, color: .blue)
                    MetricWidgetItem(title: "Memory", value: entry.memory, color: .green)
                }
            }
            
            Spacer()
            
            VStack {
                Text("\(entry.activeAgents)")
                    .font(.largeTitle)
                    .bold()
                Text("Agents Active")
                    .font(.caption)
            }
            .foregroundColor(.white)
        }
        .padding()
        .background(Color.black)
    }
}

struct LargeWidgetView: View {
    let entry: DashboardWidgetEntry

    var body: some View {
        VStack(spacing: 12) {
            Text("Unified Powerhouse Dashboard")
                .font(.headline)
            
            HStack(spacing: 16) {
                MetricWidgetItem(title: "CPU Usage", value: entry.cpu, color: .blue)
                MetricWidgetItem(title: "Memory", value: entry.memory, color: .green)
                MetricWidgetItem(title: "Disk", value: 30.0, color: .orange)
            }
            
            HStack {
                AgentStatusWidgetItem(name: "Hermes", status: "running")
                AgentStatusWidgetItem(name: "Claude", status: "ready")
                AgentStatusWidgetItem(name: "OpenClaw", status: "ready")
            }
        }
        .padding()
        .background(Color.black)
    }
}

struct MetricWidgetItem: View {
    let title: String
    let value: Double
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
            Text("\(String(format: "%.1f", value))%")
                .font(.title2)
                .bold()
                .foregroundColor(color)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .cornerRadius(2)
                    Rectangle()
                        .fill(color)
                        .frame(width: min(CGFloat(value) / 100.0 * geometry.size.width, geometry.size.width))
                        .cornerRadius(2)
                }
            }
            .frame(height: 4)
        }
        .foregroundColor(.white)
    }
}

struct AgentStatusWidgetItem: View {
    let name: String
    let status: String

    var statusColor: Color {
        switch status {
        case "running": return .green
        case "ready": return .blue
        case "busy": return .orange
        case "error": return .red
        default: return .gray
        }
    }

    var body: some View {
        VStack(spacing: 4) {
            Circle()
                .fill(statusColor)
                .frame(width: 8, height: 8)
            Text(name)
                .font(.caption)
            Text(status)
                .font(.caption2)
                .foregroundColor(statusColor)
        }
        .foregroundColor(.white)
    }
}

@main
struct UnifiedPowerhouseWidget: Widget {
    let kind: String = "UnifiedPowerhouseWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: DashboardWidgetProvider()) { entry in
            DashboardWidgetView(entry: entry)
        }
        .configurationDisplayName("Unified Powerhouse")
        .description("Monitor your agents and system metrics in real-time.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
