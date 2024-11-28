import AVFoundation
import Flutter
import UIKit

private enum AlerButton: String {
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

private enum CustomAlertButton: String {
  case positiveButton = "positive_button"
  case negativeButton = "negative_button"
  case neutralButton = "neutral_button"
}

private enum FlutterPlatformAlertStyle: String {
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
      return [
        NSLocalizedString("Abort", comment: ""),
        NSLocalizedString("Retry", comment: ""),
        NSLocalizedString("Ignore", comment: ""),
      ]
    case .cancelTryContinue:
      return [
        NSLocalizedString("Cancel", comment: ""),
        NSLocalizedString("Try Again", comment: ""),
        NSLocalizedString("Continue", comment: ""),
      ]
    case .ok:
      return [NSLocalizedString("OK", comment: "")]
    case .okCancel:
      return [
        NSLocalizedString("OK", comment: ""),
        NSLocalizedString("Cancel", comment: ""),
      ]
    case .retryCancel:
      return [
        NSLocalizedString("Retry", comment: ""),
        NSLocalizedString("Cancel", comment: ""),
      ]
    case .yesNo:
      return [
        NSLocalizedString("Yes", comment: ""),
        NSLocalizedString("No", comment: ""),
      ]
    case .yesNoCancel:
      return [
        NSLocalizedString("Yes", comment: ""),
        NSLocalizedString("No", comment: ""),
        NSLocalizedString("Cancel", comment: ""),
      ]
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

private enum FlutterPlatformIconStyle: String {
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

public class FlutterPlatformAlertPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "flutter_platform_alert", binaryMessenger: registrar.messenger())
    let instance = FlutterPlatformAlertPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {

    func style(forButtonTitle button: String) -> UIAlertAction.Style {
      switch button {
      case NSLocalizedString("Cancel", comment: ""):
        return .cancel
      case NSLocalizedString("Abort", comment: ""):
        return .destructive
      default:
        return .default
      }
    }

    func style(forButtonStyle style: String?) -> UIAlertAction.Style {
      switch style {
      case "cancel":
        return .cancel
      case "destructive":
        return .destructive
      default:
        return .default
      }
    }

    func alertStyle(forStyle style: String?) -> UIAlertController.Style {
      switch style {
      case "actionSheet":
        return .actionSheet
      default:
        return .alert
      }
    }

    switch call.method {
    case "playAlertSound":
      let systemSoundID: SystemSoundID = 4095
      AudioServicesPlaySystemSound(systemSoundID)
      result(true)
    case "showAlert":
      guard let root = UIApplication.shared.windows.first?.rootViewController else {
        result(FlutterError(code: "-101", message: "No root view", details: "The root view is nil"))
        return
      }
      guard let args = call.arguments as? [AnyHashable: Any] else {
        result(
          FlutterError(
            code: "-100", message: "No arguments", details: "The arguments object is nil"))
        return
      }
      let windowTitle = args["windowTitle"] as? String ?? ""
      let text = args["text"] as? String ?? ""
      let alertStyleString = args["alertStyle"] as? String ?? ""
      let alertStyle =
        FlutterPlatformAlertStyle(rawValue: alertStyleString) ?? FlutterPlatformAlertStyle.ok
      let buttons = alertStyle.buttons
      let preferredStyle: UIAlertController.Style = alertStyle(forStyle: args["iosAlertStyle"] as? String)
      let controller = UIAlertController(
        title: windowTitle, message: text, preferredStyle: preferredStyle)
      for i in 0..<buttons.count {
        let button = buttons[i]
        let buttonStyle = style(forButtonTitle: button)
        let action = UIAlertAction(title: button, style: buttonStyle) { action in
          let actionResult = alertStyle.button(at: i)
          result(actionResult.rawValue)
        }
        controller.addAction(action)
      }
      root.present(controller, animated: true)

    case "showCustomAlert":
      guard let root = UIApplication.shared.windows.first?.rootViewController else {
        result(FlutterError(code: "-101", message: "No root view", details: "The root view is nil"))
        return
      }
      guard let args = call.arguments as? [AnyHashable: Any] else {
        result(
          FlutterError(
            code: "-100", message: "No arguments", details: "The arguments object is nil"))
        return
      }
      let windowTitle = args["windowTitle"] as? String ?? ""
      let text = args["text"] as? String ?? ""

      var actions = [UIAlertAction]()
      if let positiveButton = args["positiveButtonTitle"] as? String,
        positiveButton.isEmpty == false
      {
        let buttonStyle = style(forButtonStyle: args["positiveButtonStyle"] as? String)
        actions.append(
          UIAlertAction(title: positiveButton, style: buttonStyle) { action in
            result(CustomAlertButton.positiveButton.rawValue)
          })
      }
      if let neutralButton = args["neutralButtonTitle"] as? String,
        neutralButton.isEmpty == false
      {
        let buttonStyle = style(forButtonStyle: args["neutralButtonStyle"] as? String)
        actions.append(
          UIAlertAction(title: neutralButton, style: buttonStyle) { action in
            result(CustomAlertButton.neutralButton.rawValue)
          })
      }
      if let negativeButton = args["negativeButtonTitle"] as? String,
        negativeButton.isEmpty == false
      {
        let buttonStyle = style(forButtonStyle: args["negativeButtonStyle"] as? String)
        actions.append(
          UIAlertAction(title: negativeButton, style: buttonStyle) { action in
            result(CustomAlertButton.negativeButton.rawValue)
          })
      }
      let preferredStyle: UIAlertController.Style = alertStyle(forStyle: args["iosAlertStyle"] as? String)
      let controller = UIAlertController(
        title: windowTitle, message: text, preferredStyle: preferredStyle)
      for action in actions {
        controller.addAction(action)
      }
      root.present(controller, animated: true)

    default:
      result(FlutterMethodNotImplemented)
    }

  }

}
