import Flutter
import UIKit
import AVFoundation

fileprivate enum AlerButton: String {
    case abortButton = "abort"
    case cancelButton = "cancel"
    case continueButton = "continue"
    case ignoreButton = "ignore"
    case noButton = "no"
    case okButton = "ok"
    case retryButton = "retry"
    case tryAgainButton = "try_again"
    case yesButton = "yes"
}

fileprivate enum FlutterPlatformAlertStyle: String {
    case abortRetryIgnore
    case cancelTryContinue
    case ok
    case okCancel
    case retryCancel
    case yesNo
    case yesNoCancel

    var buttons: [String] {
        switch self {
        case .abortRetryIgnore:
            return [NSLocalizedString("Abort", comment: ""),
                    NSLocalizedString("Retry", comment: ""),
                    NSLocalizedString("Ignore", comment: "")]
        case .cancelTryContinue:
            return [NSLocalizedString("Cancel", comment: ""),
                    NSLocalizedString("Try Again", comment: ""),
                    NSLocalizedString("Continue", comment: "")]
        case .ok:
            return [NSLocalizedString("OK", comment: "")]
        case .okCancel:
            return [NSLocalizedString("OK", comment: ""),
                    NSLocalizedString("Cancel", comment: "")]
        case .retryCancel:
            return [NSLocalizedString("Retry", comment: ""),
                    NSLocalizedString("Cancel", comment: "")]
        case .yesNo:
            return [NSLocalizedString("Yes", comment: ""),
                    NSLocalizedString("No", comment: "")]
        case .yesNoCancel:
            return [NSLocalizedString("Yes", comment: ""),
                    NSLocalizedString("No", comment: ""),
                    NSLocalizedString("Cancel", comment: ""),]
        }
    }

    func button(at index: Int) -> AlerButton {
        switch self {
        case .abortRetryIgnore:
            return [AlerButton.abortButton, AlerButton.retryButton, AlerButton.ignoreButton][index]
        case .cancelTryContinue:
            return [AlerButton.cancelButton, AlerButton.tryAgainButton, AlerButton.continueButton][index]
        case .ok:
            return AlerButton.okButton
        case .okCancel:
            return [AlerButton.okButton, AlerButton.cancelButton][index]
        case .retryCancel:
            return [AlerButton.retryButton, AlerButton.cancelButton][index]
        case .yesNo:
            return [AlerButton.yesButton, AlerButton.noButton][index]
        case .yesNoCancel:
            return [AlerButton.yesButton, AlerButton.noButton, AlerButton.cancelButton][index]
        }

    }
}

fileprivate enum FlutterPlatformIconStyle: String {
    case none
    case exclamation
    case warning
    case information
    case asterisk
    case question
    case stop
    case error
    case hand
}

public class SwiftFlutterPlatformAlertPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_platform_alert", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterPlatformAlertPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "playAlertSound":
            let systemSoundID: SystemSoundID = 4095
            AudioServicesPlaySystemSound(systemSoundID)
        case "showAlert":
            guard let args = call.arguments as? [AnyHashable:Any] else {
                result(nil)
                return
            }
            let windowTitle = args["windowTitle"] as? String ?? ""
            let text = args["text"] as? String ?? ""
            let alertStyleString = args["alertStyle"] as? String ?? ""
            let alertStyle = FlutterPlatformAlertStyle(rawValue: alertStyleString) ?? FlutterPlatformAlertStyle.ok
            let buttons = alertStyle.buttons
            let controller = UIAlertController(title: windowTitle, message: text, preferredStyle: buttons.count > 2 ? .actionSheet : .alert)
            for i in 0..<buttons.count {
                let button = buttons[i]
                let style: UIAlertAction.Style = {
                    switch button {
                    case NSLocalizedString("Cancel", comment: ""):
                        return .cancel
                    case NSLocalizedString("Abort", comment: ""):
                        return .destructive
                    default:
                        return .default
                    }
                }()
                let action = UIAlertAction(title: button, style: style) { action in
                    let actionResult = alertStyle.button(at: i)
                    result(actionResult.rawValue)
                }
                controller.addAction(action)
            }
            let root = UIApplication.shared.windows.first?.rootViewController
            root?.show(controller, sender: nil)
        default:
            result(FlutterMethodNotImplemented)
        }

    }
}
