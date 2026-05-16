import Foundation

class OfflineCacheManager {
    static let shared = OfflineCacheManager()
    
    private let userDefaults = UserDefaults.standard
    private let cacheKeyPrefix = "unified_cache_"
    
    // Cache keys
    private let agentsKey = "agents"
    private let metricsKey = "metrics"
    private let pm2Key = "pm2"
    private let dockerKey = "docker"
    private let lastUpdateKey = "last_update"
    
    func cacheAgents(_ agents: [Agent]) {
        if let data = try? JSONEncoder().encode(agents) {
            userDefaults.set(data, forKey: cacheKeyPrefix + agentsKey)
        }
    }
    
    func getCachedAgents() -> [Agent] {
        guard let data = userDefaults.data(forKey: cacheKeyPrefix + agentsKey),
              let agents = try? JSONDecoder().decode([Agent].self, from: data) else {
            return []
        }
        return agents
    }
    
    func cacheMetrics(_ metrics: SystemMetrics) {
        if let data = try? JSONEncoder().encode(metrics) {
            userDefaults.set(data, forKey: cacheKeyPrefix + metricsKey)
        }
    }
    
    func getCachedMetrics() -> SystemMetrics? {
        guard let data = userDefaults.data(forKey: cacheKeyPrefix + metricsKey),
              let metrics = try? JSONDecoder().decode(SystemMetrics.self, from: data) else {
            return nil
        }
        return metrics
    }
    
    func cachePM2Processes(_ processes: [PM2Process]) {
        if let data = try? JSONEncoder().encode(processes) {
            userDefaults.set(data, forKey: cacheKeyPrefix + pm2Key)
        }
    }
    
    func getCachedPM2Processes() -> [PM2Process] {
        guard let data = userDefaults.data(forKey: cacheKeyPrefix + pm2Key),
              let processes = try? JSONDecoder().decode([PM2Process].self, from: data) else {
            return []
        }
        return processes
    }
    
    func cacheDockerContainers(_ containers: [DockerContainer]) {
        if let data = try? JSONEncoder().encode(containers) {
            userDefaults.set(data, forKey: cacheKeyPrefix + dockerKey)
        }
    }
    
    func getCachedDockerContainers() -> [DockerContainer] {
        guard let data = userDefaults.data(forKey: cacheKeyPrefix + dockerKey),
              let containers = try? JSONDecoder().decode([DockerContainer].self, from: data) else {
            return []
        }
        return containers
    }
    
    func updateLastUpdateTime() {
        userDefaults.set(Date(), forKey: cacheKeyPrefix + lastUpdateKey)
    }
    
    func getLastUpdateTime() -> Date? {
        return userDefaults.object(forKey: cacheKeyPrefix + lastUpdateKey) as? Date
    }
    
    func clearCache() {
        let keys = [agentsKey, metricsKey, pm2Key, dockerKey, lastUpdateKey]
        for key in keys {
            userDefaults.removeObject(forKey: cacheKeyPrefix + key)
        }
    }
    
    var isCacheStale: Bool {
        guard let lastUpdate = getLastUpdateTime() else { return true }
        let fiveMinutes: TimeInterval = 5 * 60
        return Date().timeIntervalSince(lastUpdate) > fiveMinutes
    }
}
