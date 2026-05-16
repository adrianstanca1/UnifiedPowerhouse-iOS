import SwiftUI

struct BiometricLoginView: View {
    @EnvironmentObject var biometricAuth: BiometricAuthManager
    @State private var showingFallbackLogin = false
    
    var body: some View {
        ZStack {
            Color(hex: "#0a0a0f")
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // Logo
                VStack(spacing: 16) {
                    Text("⚡")
                        .font(.system(size: 80))
                    
                    Text("Unified Powerhouse")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                // Biometric Button
                VStack(spacing: 20) {
                    Button(action: {
                        if biometricAuth.biometricType != .none {
                            biometricAuth.authenticate()
                        } else {
                            showingFallbackLogin = true
                        }
                    }) {
                        VStack(spacing: 12) {
                            Image(systemName: biometricAuth.biometricIcon)
                                .font(.system(size: 50))
                                .foregroundColor(Color(hex: "#6366f1"))
                            
                            Text("Authenticate with \(biometricAuth.biometricName)")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                        .background(Color(hex: "#12121a"))
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color(hex: "#2a2a4a"), lineWidth: 1)
                        )
                    }
                    
                    if let error = biometricAuth.errorMessage {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                    }
                    
                    Button(action: {
                        showingFallbackLogin = true
                    }) {
                        Text("Use Password Instead")
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "#6366f1"))
                    }
                }
                .padding(.horizontal, 30)
                
                Spacer()
                
                Text("v2.0")
                    .font(.caption)
                    .foregroundColor(Color(hex: "#64748b"))
                    .padding(.bottom, 30)
            }
        }
        .sheet(isPresented: $showingFallbackLogin) {
            LoginView()
        }
        .onAppear {
            biometricAuth.checkBiometricAvailability()
        }
    }
}
