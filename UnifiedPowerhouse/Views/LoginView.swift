import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var username = "admin"
    @State private var password = "admin"
    
    var body: some View {
        ZStack {
            Color(hex: "#0a0a0f")
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Logo
                VStack(spacing: 16) {
                    Text("⚡")
                        .font(.system(size: 80))
                    
                    Text("Unified Powerhouse")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Control Panel")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color(hex: "#6366f1"))
                }
                .padding(.top, 60)
                
                Spacer()
                
                // Login Form
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Username")
                            .font(.caption)
                            .foregroundColor(Color(hex: "#94a3b8"))
                        
                        TextField("", text: $username)
                            .textContentType(.username)
                            .autocapitalization(.none)
                            .padding()
                            .background(Color(hex: "#12121a"))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(hex: "#2a2a4a"), lineWidth: 1)
                            )
                            .foregroundColor(.white)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password")
                            .font(.caption)
                            .foregroundColor(Color(hex: "#94a3b8"))
                        
                        SecureField("", text: $password)
                            .textContentType(.password)
                            .padding()
                            .background(Color(hex: "#12121a"))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(hex: "#2a2a4a"), lineWidth: 1)
                            )
                            .foregroundColor(.white)
                    }
                    
                    if let error = authManager.errorMessage {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.horizontal)
                    }
                    
                    Button(action: {
                        authManager.login(username: username, password: password)
                    }) {
                        HStack {
                            if authManager.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            }
                            Text(authManager.isLoading ? "Signing in..." : "Sign In")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "#6366f1"))
                        .cornerRadius(12)
                    }
                    .disabled(authManager.isLoading)
                }
                .padding(.horizontal, 30)
                
                Spacer()
                
                Text("v2.0")
                    .font(.caption)
                    .foregroundColor(Color(hex: "#64748b"))
                    .padding(.bottom, 30)
            }
        }
    }
}
