import Foundation
import LocalAuthentication

class BiometricAuthManager: ObservableObject {
    static let shared = BiometricAuthManager()
    
    @Published var isAuthenticated = false
    @Published var biometricType: LABiometryType = .none
    @Published var errorMessage: String?
    
    private let context = LAContext()
    
    init() {
        checkBiometricAvailability()
    }
    
    func checkBiometricAvailability() {
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            biometricType = context.biometryType
        } else {
            biometricType = .none
            if let error = error {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    func authenticate() {
        let reason = "Authenticate to access Unified Powerhouse"
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, error in
            DispatchQueue.main.async {
                if success {
                    self?.isAuthenticated = true
                    self?.errorMessage = nil
                } else {
                    self?.isAuthenticated = false
                    self?.errorMessage = error?.localizedDescription ?? "Authentication failed"
                }
            }
        }
    }
    
    func authenticateWithPasscode() {
        let reason = "Enter passcode to access Unified Powerhouse"
        
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { [weak self] success, error in
            DispatchQueue.main.async {
                if success {
                    self?.isAuthenticated = true
                    self?.errorMessage = nil
                } else {
                    self?.isAuthenticated = false
                    self?.errorMessage = error?.localizedDescription ?? "Authentication failed"
                }
            }
        }
    }
    
    var biometricIcon: String {
        switch biometricType {
        case .faceID:
            return "faceid"
        case .touchID:
            return "touchid"
        default:
            return "lock"
        }
    }
    
    var biometricName: String {
        switch biometricType {
        case .faceID:
            return "Face ID"
        case .touchID:
            return "Touch ID"
        default:
            return "Passcode"
        }
    }
}
