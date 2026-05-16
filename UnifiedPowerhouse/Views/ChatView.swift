import SwiftUI

struct ChatView: View {
    @EnvironmentObject var webSocketManager: WebSocketManager
    @State private var messageText = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Chat messages
                ScrollView {
                    ScrollViewReader { proxy in
                        LazyVStack(spacing: 12) {
                            ForEach(webSocketManager.chatMessages) { message in
                                ChatBubble(message: message)
                            }
                            
                            if webSocketManager.chatMessages.isEmpty {
                                VStack(spacing: 16) {
                                    Text("💬")
                                        .font(.system(size: 60))
                                    Text("Unified Chat Console")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Text("Send commands or messages to any agent")
                                        .font(.caption)
                                        .foregroundColor(Color(hex: "#64748b"))
                                }
                                .padding(.top, 100)
                            }
                        }
                        .padding()
                    }
                }
                .background(Color(hex: "#0a0a0f"))
                
                // Input area
                HStack(spacing: 12) {
                    TextField("Type a command or message...", text: $messageText)
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Color(hex: "#12121a"))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(hex: "#2a2a4a"), lineWidth: 1)
                        )
                        .disabled(!webSocketManager.isConnected)
                    
                    Button(action: {
                        if !messageText.isEmpty {
                            webSocketManager.sendChatMessage(messageText)
                            messageText = ""
                        }
                    }) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(Color(hex: "#6366f1"))
                    }
                    .disabled(!webSocketManager.isConnected || messageText.isEmpty)
                }
                .padding()
                .background(Color(hex: "#12121a"))
                .overlay(
                    Rectangle()
                        .stroke(Color(hex: "#2a2a4a"), lineWidth: 1)
                )
            }
            .navigationTitle("Chat")
            .navigationBarTitleDisplayMode(.large)
            .background(Color(hex: "#0a0a0f").ignoresSafeArea())
        }
    }
}

struct ChatBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
            }
            
            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                Text(message.sender.uppercased())
                    .font(.caption2)
                    .foregroundColor(Color(hex: "#94a3b8"))
                
                Text(message.content)
                    .font(.system(size: 14))
                    .foregroundColor(message.isUser ? .white : Color(hex: "#f1f5f9"))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(message.isUser ? Color(hex: "#6366f1") : Color(hex: "#12121a"))
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(hex: "#2a2a4a"), lineWidth: message.isUser ? 0 : 1)
                    )
            }
            
            if !message.isUser {
                Spacer()
            }
        }
    }
}
