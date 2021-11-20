#include "include/flutter_platform_alert/flutter_platform_alert_plugin.h"
#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>
#include <map>
#include <memory>
#include <sstream>
#include <windows.h>

namespace {

using flutter::EncodableMap;
using flutter::EncodableValue;

std::wstring
Utf16FromUtf8(const std::string& utf8_string)
{
  if (utf8_string.empty()) {
    return std::wstring();
  }
  int target_length =
    ::MultiByteToWideChar(CP_UTF8,
                          MB_ERR_INVALID_CHARS,
                          utf8_string.data(),
                          static_cast<int>(utf8_string.length()),
                          nullptr,
                          0);
  if (target_length == 0) {
    return std::wstring();
  }
  std::wstring utf16_string;
  utf16_string.resize(target_length);
  int converted_length =
    ::MultiByteToWideChar(CP_UTF8,
                          MB_ERR_INVALID_CHARS,
                          utf8_string.data(),
                          static_cast<int>(utf8_string.length()),
                          utf16_string.data(),
                          target_length);
  if (converted_length == 0) {
    return std::wstring();
  }
  return utf16_string;
}

std::string
GetStringArgument(const flutter::MethodCall<>& method_call, const char* name)
{
  std::string url;
  const auto* arguments = std::get_if<EncodableMap>(method_call.arguments());
  if (arguments) {
    auto url_it = arguments->find(EncodableValue(name));
    if (url_it != arguments->end()) {
      url = std::get<std::string>(url_it->second);
    }
  }
  return url;
}

class FlutterPlatformAlertPlugin : public flutter::Plugin
{
public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows* registrar);

  FlutterPlatformAlertPlugin();

  virtual ~FlutterPlatformAlertPlugin();

private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue>& method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

// static
void
FlutterPlatformAlertPlugin::RegisterWithRegistrar(
  flutter::PluginRegistrarWindows* registrar)
{
  auto channel =
    std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
      registrar->messenger(),
      "flutter_platform_alert",
      &flutter::StandardMethodCodec::GetInstance());

  auto plugin = std::make_unique<FlutterPlatformAlertPlugin>();

  channel->SetMethodCallHandler(
    [plugin_pointer = plugin.get()](const auto& call, auto result) {
      plugin_pointer->HandleMethodCall(call, std::move(result));
    });

  registrar->AddPlugin(std::move(plugin));
}

FlutterPlatformAlertPlugin::FlutterPlatformAlertPlugin() {}

FlutterPlatformAlertPlugin::~FlutterPlatformAlertPlugin() {}

void
FlutterPlatformAlertPlugin::HandleMethodCall(
  const flutter::MethodCall<flutter::EncodableValue>& method_call,
  std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
{
  if (method_call.method_name().compare("playAlertSound") == 0) {
    MessageBeep(MB_ICONASTERISK);
    result->Success();
  } else if (method_call.method_name().compare("showAlert") == 0) {
    std::string windowTitle = GetStringArgument(method_call, "windowTitle");
    std::string text = GetStringArgument(method_call, "text");
    std::string alertStyle = GetStringArgument(method_call, "alertStyle");
    std::string iconStyleString =
      GetStringArgument(method_call, "iconStyleString");

    std::wstring windowTitleUtf16 = Utf16FromUtf8(windowTitle.c_str());
    std::wstring textUtf16 = Utf16FromUtf8(windowTitle.c_str());

    UINT alertType = MB_OK;
    if (alertStyle == "abortRetryIgnore") {
      alertType = MB_ABORTRETRYIGNORE;
    } else if (alertStyle == "cancelTryContinue") {
      alertType = MB_CANCELTRYCONTINUE;
    } else if (alertStyle == "ok") {
      alertType = MB_OK;
    } else if (alertStyle == "okCancel") {
      alertType = MB_OKCANCEL;
    } else if (alertStyle == "retryCancel") {
      alertType = MB_RETRYCANCEL;
    } else if (alertStyle == "yesNo") {
      alertType = MB_YESNO;
    } else if (alertStyle == "yesNoCancel") {
      alertType = MB_YESNOCANCEL;
    }

    UINT iconStyle = 0;
    if (iconStyleString == "exclamation") {
      iconStyle = MB_ICONEXCLAMATION;
    } else if (iconStyleString == "warning") {
      iconStyle = MB_ICONWARNING;
    } else if (iconStyleString == "information") {
      iconStyle = MB_ICONINFORMATION;
    } else if (iconStyleString == "asterisk") {
      iconStyle = MB_ICONASTERISK;
    } else if (iconStyleString == "question") {
      iconStyle = MB_ICONQUESTION;
    } else if (iconStyleString == "stop") {
      iconStyle = MB_ICONSTOP;
    } else if (iconStyleString == "error") {
      iconStyle = MB_ICONERROR;
    } else if (iconStyleString == "hand") {
      iconStyle = MB_ICONHAND;
    }

    int msgboxid = MessageBox(NULL,
                              (LPCWSTR)windowTitleUtf16.c_str(),
                              (LPCWSTR)textUtf16.c_str(),
                              alertType | iconStyle);

    std::string response;
    if (msgboxid == IDABORT) {
      response = "abort";
    } else if (msgboxid == IDCANCEL) {
      response = "cancel";
    } else if (msgboxid == IDCONTINUE) {
      response = "continue";
    } else if (msgboxid == IDIGNORE) {
      response = "ignore";
    } else if (msgboxid == IDNO) {
      response = "no";
    } else if (msgboxid == IDOK) {
      response = "ok";
    } else if (msgboxid == IDRETRY) {
      response = "retry";
    } else if (msgboxid == IDTRYAGAIN) {
      response = "try_again";
    } else if (msgboxid == IDYES) {
      response = "yes";
    }

    result->Success(EncodableValue(response.c_str()));
  } else {
    result->NotImplemented();
  }
}

} // namespace

void
FlutterPlatformAlertPluginRegisterWithRegistrar(
  FlutterDesktopPluginRegistrarRef registrar)
{
  FlutterPlatformAlertPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarManager::GetInstance()
      ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
