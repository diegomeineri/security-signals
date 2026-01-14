import Foundation
import Capacitor
import UIKit
import CallKit

@objc(SecuritySignalsPlugin)
public class SecuritySignalsPlugin: CAPPlugin, CAPBridgedPlugin, CXCallObserverDelegate {
    public let identifier = "SecuritySignalsPlugin"
    public let jsName = "securitySignals"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "getScreenCaptureState", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "startScreenCaptureWatcher", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "stopScreenCaptureWatcher", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "getCommunicationState", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "startCommunicationWatcher", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "stopCommunicationWatcher", returnType: CAPPluginReturnPromise)
    ]

    private var screenObs: NSObjectProtocol?
    private let callObserver = CXCallObserver()
    private var commPollTimer: Timer?

    @objc func getScreenCaptureState(_ call: CAPPluginCall) {
        let captured = UIScreen.main.isCaptured
        call.resolve([
            "supported": true,
            "captured": captured
        ])
    }

    @objc func startScreenCaptureWatcher(_ call: CAPPluginCall) {
        print("[SecuritySignals] startScreenCaptureWatcher called")
        if screenObs == nil {
            print("[SecuritySignals] Registering observer for UIScreen.capturedDidChangeNotification")
            screenObs = NotificationCenter.default.addObserver(
                forName: UIScreen.capturedDidChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self else {
                    print("[SecuritySignals] Self is nil in observer callback")
                    return
                }
                let captured = UIScreen.main.isCaptured
                print("[SecuritySignals] Screen capture changed! captured=\(captured)")
                self.notifyListeners("screenCaptureChanged", data: [
                    "captured": captured
                ])
                print("[SecuritySignals] notifyListeners called for screenCaptureChanged")
            }
            print("[SecuritySignals] Observer registered successfully")
        } else {
            print("[SecuritySignals] Observer already exists, skipping registration")
        }
        call.resolve([ "supported": true ])
    }

    @objc func stopScreenCaptureWatcher(_ call: CAPPluginCall) {
        if let obs = screenObs {
            NotificationCenter.default.removeObserver(obs)
            screenObs = nil
        }
        call.resolve()
    }

    // ---- Communication ----

    @objc func getCommunicationState(_ call: CAPPluginCall) {
        // micInUse: iOS no permite saber si "otra app" usa el mic
        let callActive = callObserver.calls.contains { !$0.hasEnded }
        call.resolve([
            "micInUseSupported": false,
            "micInUse": NSNull(),
            "callSupported": true,
            "callActive": callActive
        ])
    }

    @objc func startCommunicationWatcher(_ call: CAPPluginCall) {
        // OJO: si te preocupa App Review, hacé esta parte "feature-flag" o removela
        callObserver.setDelegate(self, queue: nil)

        let pollMs = call.getInt("pollMs") ?? 500
        commPollTimer?.invalidate()
        commPollTimer = Timer.scheduledTimer(withTimeInterval: Double(pollMs) / 1000.0, repeats: true) { [weak self] _ in
            guard let self else { return }
            let callActive = self.callObserver.calls.contains { !$0.hasEnded }
            self.notifyListeners("communicationChanged", data: [
                "micInUseSupported": false,
                "micInUse": NSNull(),
                "callSupported": true,
                "callActive": callActive
            ])
        }

        call.resolve([ "supported": true ])
    }

    @objc func stopCommunicationWatcher(_ call: CAPPluginCall) {
        commPollTimer?.invalidate()
        commPollTimer = nil
        call.resolve()
    }

    public func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
        let callActive = callObserver.calls.contains { !$0.hasEnded }
        notifyListeners("communicationChanged", data: [
            "micInUseSupported": false,
            "micInUse": NSNull(),
            "callSupported": true,
            "callActive": callActive
        ])
    }
}
