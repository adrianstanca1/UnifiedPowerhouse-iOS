import SwiftUI

struct TerminalView: View {
    @EnvironmentObject var webSocketManager: WebSocketManager
    @State private var command = ""
    @State private var commandHistory: [String] = []
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Output display
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(commandHistory, id: \.self) { history in
                            Text(history)
                                .font(.system(size: 12, design: .monospaced))
                                .foregroundColor(.white)
                                .padding(.horizontal)
                        }
                        
                        if let result = webSocketManager.commandResult {
                            Text(result.output)
                                .font(.system(size: 12, design: .monospaced))
                                .foregroundColor(result.success ? Color(hex: "#22c55e") : Color(hex: "#ef4444"))
                                .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
                .background(Color(hex: "#0a0a0f"))
                
                // Command input
                HStack(spacing: 12) {
                    Text("$")
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                        .foregroundColor(Color(hex: "#6366f1"))
                    
                    TextField("Enter command...", text: $command)
                        .font(.system(size: 14, design: .monospaced))
                        .foregroundColor(.white)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    
                    Button(action: {
                        if !command.isEmpty {
                            commandHistory.append("$ \(command)")
                            webSocketManager.sendCommand(command)
                            command = ""
                        }
                    }) {
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(Color(hex: "#6366f1"))
                    }
                }
                .padding()
                .background(Color(hex: "#12121a"))
                .overlay(
                    Rectangle()
                        .stroke(Color(hex: "#2a2a4a"), lineWidth: 1)
                )
            }
            .navigationTitle("Terminal")
            .navigationBarTitleDisplayMode(.large)
            .background(Color(hex: "#0a0a0f").ignoresSafeArea())
        }
    }
}
