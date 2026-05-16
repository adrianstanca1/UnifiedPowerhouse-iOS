import Foundation
import UserNotifications
import UIKit

class NotificationManager: NSObject, ObservableObject {
    static let shared = NotificationManager()
    
    @Published var isAuthorized = false
    private let notificationCenter = UNUserNotificationCenter.current()
    
    override init() {
        super.init()
        notificationCenter.delegate = self
    }
    
    func requestAuthorization() {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] granted, error in
            DispatchQueue.main.async {
                self?.isAuthorized = granted
                if granted {
                    self?.registerForRemoteNotifications()
                }
            }
        }
    }
    
    private func registerForRemoteNotifications() {
        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    func scheduleNotification(title: String, body: String, identifier: String = UUID().uuidString) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.badge = 1
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: nil)
        notificationCenter.add(request)
    }
    
    func scheduleAgentStatusChange(agentName: String, status: String) {
        let title = "Agent Status Changed"
        let body = "\(agentName) is now \(status)"
        scheduleNotification(title: title, body: body, identifier: "agent_\(agentName)_\(status)")
    }
    
    func scheduleHighCPUNotification(cpu: Double) {
        let title = "⚠️ High CPU Usage"
        let body = "CPU usage is at \(String(format: "%.1f", cpu))%"
        scheduleNotification(title: title, body: body, identifier: "cpu_alert")
    }
    
    func scheduleHighMemoryNotification(memory: Double) {
        let title = "⚠️ High Memory Usage"
        let body = "Memory usage is at \(String(format: "%.1f", memory))%"
        scheduleNotification(title: title, body: body, identifier: "memory_alert")
    }
    
    func scheduleProcessDownNotification(processName: String) {
        let title = "🚨 Process Down"
        let body = "\(processName) has stopped unexpectedly"
        scheduleNotification(title: title, body: body, identifier: "process_\(processName)_down")
    }
    
    func scheduleDockerContainerIssue(containerName: String, status: String) {
        let title = "🐳 Container Alert"
        let body = "\(containerName) is \(status)"
        scheduleNotification(title: title, body: body, identifier: "docker_\(containerName)")
    }
    
    func clearBadge() {
        DispatchQueue.main.async {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
