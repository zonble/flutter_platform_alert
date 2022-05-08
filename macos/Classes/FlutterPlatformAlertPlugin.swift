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
  case tryAgainButton = "try_again"
  case yesButton = "yes"
}

fileprivate enum CustomAlertButton: String {
  case positiveButton = "positive_button"
  case negativeButton = "negative_button"
  case neutralButton = "neutral_button"
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
        case .error, .hand, .stop:
            return .critical
        case .exclamation, .warning, .question, .none:
            return .warning
        case .information, .asterisk:
            return .informational
        }

    }
}

public class FlutterPlatformAlertPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_platform_alert", binaryMessenger: registrar.messenger)
        let instance = FlutterPlatformAlertPlugin(registrar)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    private var registrar: FlutterPluginRegistrar!;
    
    public init(_ registrar: FlutterPluginRegistrar) {
        super.init()
        self.registrar = registrar
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "playAlertSound":
            NSSound.beep()
            result(nil)

        case "showAlert":
            guard let args = call.arguments as? [AnyHashable:Any] else {
                result(FlutterError(code: "-100", message: "No arguments", details: "The arguments object is nil"))
                return
            }
            let windowTitle = args["windowTitle"] as? String ?? ""
            let text = args["text"] as? String ?? ""
            let alertStyleString = args["alertStyle"] as? String ?? ""
            let alertStyle = FlutterPlatformAlertStyle(rawValue: alertStyleString) ?? FlutterPlatformAlertStyle.ok
            let iconStyleString = args["iconStyle"] as? String ?? ""
            let iconStyle = FlutterPlatformIconStyle(rawValue: iconStyleString) ?? FlutterPlatformIconStyle.none
            let runAsSheet = (args["position"] as? Int ?? 0) == 0

            let alert = NSAlert()
            alert.messageText = windowTitle
            alert.informativeText = text

            let buttons = alertStyle.buttons
            for button in buttons {
                alert.addButton(withTitle: button)
            }
            alert.alertStyle = iconStyle.alertStyle
            
            NSApp.activate(ignoringOtherApps: true)
            let window = self.registrar.view?.window
            if runAsSheet,
               let window = window,
               window.isVisible,
               !window.isMiniaturized {
                alert.beginSheetModal(for: window) { response in
                    let alertButton = alertStyle.handle(response: response)
                    result(alertButton.rawValue)
                }
            } else {
                let modalResponse = alert.runModal()
                let alertButton = alertStyle.handle(response: modalResponse)
                result(alertButton.rawValue)
            }

        case "showCustomAlert":
            guard let args = call.arguments as? [AnyHashable:Any] else {
                result(FlutterError(code: "-100", message: "No arguments", details: "The arguments object is nil"))
                return
            }
            let windowTitle = args["windowTitle"] as? String ?? ""
            let text = args["text"] as? String ?? ""
            let iconStyleString = args["iconStyle"] as? String ?? ""
            let iconStyle = FlutterPlatformIconStyle(rawValue: iconStyleString) ?? FlutterPlatformIconStyle.none
            let runAsSheet = (args["position"] as? Int ?? 0) == 0
            let base64Icon = args["base64Icon"] as? String

            let alert = NSAlert()
            alert.messageText = windowTitle
            alert.informativeText = text
            alert.alertStyle = iconStyle.alertStyle

            if let base64Icon = base64Icon,
               let data = Data(base64Encoded: base64Icon),
               let image = NSImage(data: data) {
                alert.icon = image
            }

            var index = 0
            var buttons = [CustomAlertButton]()

            if let positiveButton = args["positiveButtonTitle"] as? String,
               positiveButton.isEmpty == false {
                buttons.append(.positiveButton)
                alert.addButton(withTitle: positiveButton)
                index += 1
            }
            if let neutralButton = args["neutralButtonTitle"] as? String,
               neutralButton.isEmpty == false {
                buttons.append(.neutralButton)
                alert.addButton(withTitle: neutralButton)
                index += 1
            }
            if let negativeButton = args["negativeButtonTitle"] as? String,
               negativeButton.isEmpty == false {
                buttons.append(.negativeButton)
                alert.addButton(withTitle: negativeButton)
                index += 1
            }
            if buttons.isEmpty {
                buttons.append(.positiveButton)
                alert.addButton(withTitle: NSLocalizedString("OK", comment: ""))
            }

            func response(with modalResponse: NSApplication.ModalResponse) {
                let map:[NSApplication.ModalResponse:Int] = [
                    .alertFirstButtonReturn: 0,
                    .alertSecondButtonReturn: 1,
                    .alertThirdButtonReturn: 2,
                ]
                if let index = map[modalResponse] {
                    let alertButton = buttons[index]
                    result(alertButton.rawValue)
                } else {
                    result(nil)
                }
            }

            NSApp.activate(ignoringOtherApps: true)
            let window = self.registrar.view?.window
            if runAsSheet,
               let window = window,
               window.isVisible,
               !window.isMiniaturized {
                alert.beginSheetModal(for: window) { modalResponse in
                    response(with: modalResponse)
                }
            } else {
                let modalResponse = alert.runModal()
                response(with: modalResponse)
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
