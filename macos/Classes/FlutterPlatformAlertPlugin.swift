import Cocoa
import FlutterMacOS

fileprivate enum AlerButton: String {
  case abortButton = "abort"
  case cancelButton = "cancel"
  case continueButton = "continue"
  case ignoreButton = "ignore"
  case noButton = "no"
  case okButton = "ok"
  case retryButton = "retry"
  case tryAgainButton = "tryAgain"
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
            return [NSLocalizedString("Ok", comment: "")]
        case .okCancel:
            return [NSLocalizedString("Ok", comment: ""),
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

    func handle(response: NSApplication.ModalResponse) -> AlerButton {
        switch self {
        case .abortRetryIgnore:
            switch response {
            case .alertFirstButtonReturn:
                return .abortButton
            case .alertSecondButtonReturn:
                return .retryButton
            case .alertThirdButtonReturn:
                return .ignoreButton
            default:
                return .okButton
            }
        case .cancelTryContinue:
            switch response {
            case .alertFirstButtonReturn:
                return .cancelButton
            case .alertSecondButtonReturn:
                return .tryAgainButton
            case .alertThirdButtonReturn:
                return .continueButton
            default:
                return .okButton
            }
        case .ok:
            return .okButton
        case .okCancel:
            switch response {
            case .alertSecondButtonReturn:
                return .cancelButton
            default:
                return .okButton
            }
        case .retryCancel:
            switch response {
            case .alertSecondButtonReturn:
                return .cancelButton
            default:
                return .retryButton
            }
        case .yesNo:
            switch response {
            case .alertSecondButtonReturn:
                return .noButton
            default:
                return .yesButton
            }
        case .yesNoCancel:
            switch response {
            case .alertSecondButtonReturn:
                return .noButton
            case .alertThirdButtonReturn:
                return .cancelButton
            default:
                return .yesButton
            }
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

    var alertStyle: NSAlert.Style {
        switch self {
        case .exclamation, .error:
            return .critical
        case .warning, .asterisk, .question, .stop, .none:
            return .warning
        case .information, .hand:
            return .informational
        }

    }
}

public class FlutterPlatformAlertPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_platform_alert", binaryMessenger: registrar.messenger)
        let instance = FlutterPlatformAlertPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "playAlertSound":
            NSSound.beep()
            result(nil)
        case "showAlert":
            guard let args = call.arguments as? [AnyHashable:Any] else {
                result(nil)
                return
            }
            let windowTitle = args["windowTitle"] as? String ?? ""
            let text = args["text"] as? String ?? ""
            let alertStyleString = args["alertStyle"] as? String ?? ""
            let alertStyle = FlutterPlatformAlertStyle(rawValue: alertStyleString) ?? FlutterPlatformAlertStyle.ok
            let iconStyleString = args["iconStyleString"] as? String ?? ""
            let iconStyle = FlutterPlatformIconStyle(rawValue: iconStyleString) ?? FlutterPlatformIconStyle.none

            let alert = NSAlert()
            alert.messageText = windowTitle
            alert.informativeText = text

            let buttons = alertStyle.buttons
            for button in buttons {
                alert.addButton(withTitle: button)
            }
            alert.alertStyle = iconStyle.alertStyle
            let modalResponse = alert.runModal()
            let alertButton = alertStyle.handle(response: modalResponse)
            result(alertButton.rawValue)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
