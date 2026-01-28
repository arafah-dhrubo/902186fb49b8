import Flutter
import UIKit
import SystemConfiguration
import Darwin

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    let result = super.application(application, didFinishLaunchingWithOptions: launchOptions)
    
    let registrar = self.registrar(forPlugin: "VitalVitals")!
    let vitalChannel = FlutterMethodChannel(name: "com.example.vital/vitals",
                                              binaryMessenger: registrar.messenger())
    
    vitalChannel.setMethodCallHandler { [weak self] (call, result) in
        guard let self = self else { 
            result(FlutterError(code: "UNAVAILABLE", message: "AppDelegate is nil", details: nil))
            return 
        }
        
        switch call.method {
        case "getThermalState":
            result(self.getThermalState())
        case "getBatteryLevel":
            result(self.getBatteryLevel())
        case "getMemoryUsage":
            result(self.getMemoryUsage())
        case "getConnectivityStatus":
            if let args = call.arguments as? [String: Any],
               let host = args["host"] as? String {
                result(self.getConnectivityStatus(host: host))
            } else {
                result(self.getConnectivityStatus(host: "google.com")) // Fallback
            }
        case "getDeviceId":
            result(self.getDeviceId())
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    return result
  }

  private func getDeviceId() -> String {
    return UIDevice.current.identifierForVendor?.uuidString ?? "unknown_ios"
  }

  private func getThermalState() -> Int {
    let state = ProcessInfo.processInfo.thermalState
    switch state {
    case .nominal:
      return 0
    case .fair:
      return 1
    case .serious:
      return 2
    case .critical:
      return 3
    @unknown default:
      return 0
    }
  }

  private func getBatteryLevel() -> Int {
    let device = UIDevice.current
    device.isBatteryMonitoringEnabled = true
    if device.batteryLevel < 0 {
      return -1
    }
    return Int(device.batteryLevel * 100)
  }

    private func getMemoryUsage() -> Double {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size / MemoryLayout<integer_t>.size)

        let result = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                task_info(
                    mach_task_self_,
                    task_flavor_t(MACH_TASK_BASIC_INFO),
                    $0,
                    &count
                )
            }
        }

        if result != KERN_SUCCESS {
            return -1.0
        }

        let usedBytes = Double(info.resident_size)
        let totalBytes = Double(ProcessInfo.processInfo.physicalMemory)
        return (usedBytes / totalBytes) * 100.0
    }

    private func getConnectivityStatus(host: String) -> Bool {
        var flags: SCNetworkReachabilityFlags = []
        
        guard let reachability = SCNetworkReachabilityCreateWithName(nil, host) else {
            return false
        }
        
        SCNetworkReachabilityGetFlags(reachability, &flags)
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return isReachable && !needsConnection
    }
}
