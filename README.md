# Unified Powerhouse iOS App

## 🚀 Native iOS Control Panel

### Features
- ✅ Real-time WebSocket communication with backend
- ✅ JWT authentication
- ✅ Live agent status with pulse animations
- ✅ System metrics (CPU, Memory, Disk, Load)
- ✅ PM2 process monitoring
- ✅ Docker container monitoring
- ✅ Interactive terminal
- ✅ Chat console
- ✅ Dark theme with neon accents

### Requirements
- iOS 16.0+
- Xcode 14.0+
- Swift 5.7+

### Project Structure
```
UnifiedPowerhouse-iOS/
├── UnifiedPowerhouse.xcodeproj/
├── UnifiedPowerhouse/
│   ├── UnifiedPowerhouseApp.swift
│   ├── Models/
│   │   └── Models.swift
│   ├── Views/
│   │   ├── LoginView.swift
│   │   ├── MainTabView.swift
│   │   ├── DashboardView.swift
│   │   ├── TerminalView.swift
│   │   ├── ProcessesView.swift
│   │   ├── ChatView.swift
│   │   └── SettingsView.swift
│   ├── ViewModels/
│   │   └── DashboardViewModel.swift
│   ├── Services/
│   │   ├── AuthManager.swift
│   │   └── WebSocketManager.swift
│   ├── Utils/
│   │   └── Color+Hex.swift
│   └── Resources/
│       └── Info.plist
└── Package.swift
```

### Building
1. Open `UnifiedPowerhouse.xcodeproj` in Xcode
2. Select your device/simulator
3. Press Cmd+R to build and run

### Configuration
- Backend URL: `https://dashboard.cortexbuildpro.com`
- WebSocket: `wss://dashboard.cortexbuildpro.com/ws`
- Login: `admin` / `admin`

### Screenshots
- Login screen with dark theme
- Dashboard with agent cards and metrics
- Terminal for command execution
- Process monitoring (PM2 + Docker)
- Chat console for agent messaging
