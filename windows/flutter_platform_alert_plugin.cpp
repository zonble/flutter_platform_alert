#include "include/flutter_platform_alert/flutter_platform_alert_plugin.h"

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>
#include <map>
#include <memory>
#include <sstream>
#include <windows.h>

#include <CommCtrl.h>
#pragma comment(lib, "comctl32.lib")
#pragma comment( \
    linker,      \
    "/manifestdependency:\"type='win32' name='Microsoft.Windows.Common-Controls' version='6.0.0.0' processorArchitecture='*' publicKeyToken='6595b64144ccf1df' language='*'\"")

namespace {

using flutter::EncodableMap;
using flutter::EncodableValue;

std::wstring
Utf16FromUtf8(const std::string& utf8_string)
{
    if (utf8_string.empty()) {
        return std::wstring();
    }
    int target_length = ::MultiByteToWideChar(CP_UTF8,
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
    int converted_length = ::MultiByteToWideChar(CP_UTF8,
        MB_ERR_INVALID_CHARS,
        utf8_string.data(),
        static_cast<int>(utf8_string.length()),
        (LPWSTR)utf16_string.data(),
        target_length);
    if (converted_length == 0) {
        return std::wstring();
    }
    return utf16_string;
}

template <typename T>
T GetValue(const flutter::MethodCall<>& method_call, const char* name)
{
    T argument {};
    const auto* arguments = std::get_if<EncodableMap>(method_call.arguments());
    if (arguments) {
        auto it = arguments->find(EncodableValue(name));
        if (it != arguments->end()) {
            argument = std::get<T>(it->second);
        }
    }
    return argument;
}

std::string GetString(const flutter::MethodCall<>& method_call, const char* name)
{
    return GetValue<std::string>(method_call, name);
}

bool GetBool(const flutter::MethodCall<>& method_call, const char* name)
{
    return GetValue<bool>(method_call, name);
}

bool GetInt(const flutter::MethodCall<>& method_call, const char* name)
{
    return GetValue<int>(method_call, name);
}

class FlutterPlatformAlertPlugin : public flutter::Plugin {
public:
    static void RegisterWithRegistrar(flutter::PluginRegistrarWindows* registrar);

    FlutterPlatformAlertPlugin();

    virtual ~FlutterPlatformAlertPlugin();

private:
    // Called when a method is called on this plugin's channel from Dart.
    void HandleMethodCall(
        const flutter::MethodCall<flutter::EncodableValue>& method_call,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

    // Shows an alert using MessageBox API.
    std::string ShowWithMessageBox(std::wstring windowTitleUtf16,
        std::wstring textUtf16,
        std::string alertStyleString,
        std::string iconStyleString,
        int windowPosition);

    // Shows an alert using TaskDialogIndirect API.
    std::string ShowWithTaskDialogIndirect(std::wstring windowTitleUtf16,
        std::wstring textUtf16,
        std::string alertStyleString,
        std::string iconStyleString,
        std::wstring additionalWindowTitle,
        int windowPosition);

    std::string StringFromMessageBoxID(int msgboxid);
    int IconTypeFromString(std::string string);

    // Show an alert with custom buttons.
    std::string ShowWithCustomButtons(std::wstring windowTitleUtf16,
        std::wstring textUtf16,
        std::string iconStyleString,
        std::wstring positiveButton,
        std::wstring negativeButton,
        std::wstring neutralButton,
        std::wstring additionalWindowTitle,
        bool showAsLinks,
        int windowPosition,
        std::wstring iconPath);

    // A reference of the registrar in order to access the root window.
    flutter::PluginRegistrarWindows* registrar_;
};

// static
void FlutterPlatformAlertPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows* registrar)
{
    auto channel = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
        registrar->messenger(),
        "flutter_platform_alert",
        &flutter::StandardMethodCodec::GetInstance());

    auto plugin = std::make_unique<FlutterPlatformAlertPlugin>();

    channel->SetMethodCallHandler(
        [plugin_pointer = plugin.get()](const auto& call, auto result) {
            plugin_pointer->HandleMethodCall(call, std::move(result));
        });

    plugin->registrar_ = registrar;
    registrar->AddPlugin(std::move(plugin));
}

FlutterPlatformAlertPlugin::FlutterPlatformAlertPlugin() { }

FlutterPlatformAlertPlugin::~FlutterPlatformAlertPlugin() { }

static const int CUSTOM_POSITIVE = 101;
static const int CUSTOM_NUETRAL = 102;
static const int CUSTOM_NEGATIVE = 103;

std::string
FlutterPlatformAlertPlugin::StringFromMessageBoxID(int msgboxid)
{
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
    } else if (msgboxid == CUSTOM_POSITIVE) {
        response = "positive_button";
    } else if (msgboxid == CUSTOM_NEGATIVE) {
        response = "negative_button";
    } else if (msgboxid == CUSTOM_NUETRAL) {
        response = "neutral_button";
    }

    return response;
}

int FlutterPlatformAlertPlugin::IconTypeFromString(std::string iconStyleString)
{
    int iconStyle = 0;
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

    return iconStyle;
}

std::string
FlutterPlatformAlertPlugin::ShowWithMessageBox(std::wstring windowTitleUtf16,
    std::wstring textUtf16,
    std::string alertStyleString,
    std::string iconStyleString,
    int windowPosition)
{
    UINT alertType = MB_OK;
    if (alertStyleString == "abortRetryIgnore") {
        alertType = MB_ABORTRETRYIGNORE;
    } else if (alertStyleString == "cancelTryContinue") {
        alertType = MB_CANCELTRYCONTINUE;
    } else if (alertStyleString == "ok") {
        alertType = MB_OK;
    } else if (alertStyleString == "okCancel") {
        alertType = MB_OKCANCEL;
    } else if (alertStyleString == "retryCancel") {
        alertType = MB_RETRYCANCEL;
    } else if (alertStyleString == "yesNo") {
        alertType = MB_YESNO;
    } else if (alertStyleString == "yesNoCancel") {
        alertType = MB_YESNOCANCEL;
    }

    UINT iconStyle = IconTypeFromString(iconStyleString);
    auto hwnd = registrar_->GetView()->GetNativeWindow();
    WINDOWPLACEMENT placement = { 0 };
    GetWindowPlacement(hwnd, &placement);
    bool windowIsHidden = placement.rcNormalPosition.top == 0 && placement.rcNormalPosition.bottom == 0 && placement.rcNormalPosition.left == 0 && placement.rcNormalPosition.right == 0;

    if (windowIsHidden || windowPosition == 1) {
        hwnd = NULL;
    }

    int msgboxid = MessageBox(hwnd,
        (LPCWSTR)textUtf16.c_str(),
        (LPCWSTR)windowTitleUtf16.c_str(),
        alertType | iconStyle);

    return StringFromMessageBoxID(msgboxid);
}

std::string
FlutterPlatformAlertPlugin::ShowWithTaskDialogIndirect(
    std::wstring windowTitle,
    std::wstring text,
    std::string alertStyle,
    std::string iconStyle,
    std::wstring additionalWindowTitle,
    int windowPosition)
{

    TASKDIALOGCONFIG config = { 0 };
    config.cbSize = sizeof(config);
    config.pszMainInstruction = windowTitle.c_str();
    config.pszContent = text.c_str();
    config.dwFlags = TDF_POSITION_RELATIVE_TO_WINDOW;

    if (!additionalWindowTitle.empty()) {
        config.pszWindowTitle = additionalWindowTitle.c_str();
    }

    if (alertStyle == "abortRetryIgnore") {
        const TASKDIALOG_BUTTON buttons[] = {
            { IDABORT, L"Abort" },
            { IDRETRY, L"Retry" },
            { IDIGNORE, L"Ignore" },
        };
        config.pButtons = buttons;
        config.cButtons = ARRAYSIZE(buttons);
    } else if (alertStyle == "cancelTryContinue") {
        const TASKDIALOG_BUTTON buttons[] = {
            { IDTRYAGAIN, L"Try Again" },
            { IDCONTINUE, L"Continue" },
        };
        config.pButtons = buttons;
        config.cButtons = ARRAYSIZE(buttons);
        config.dwCommonButtons = TDCBF_CANCEL_BUTTON;
    } else if (alertStyle == "ok") {
        config.dwCommonButtons = TDCBF_OK_BUTTON;
    } else if (alertStyle == "okCancel") {
        config.dwCommonButtons = TDCBF_OK_BUTTON | TDCBF_CANCEL_BUTTON;
    } else if (alertStyle == "retryCancel") {
        config.dwCommonButtons = TDCBF_RETRY_BUTTON | TDCBF_CANCEL_BUTTON;
    } else if (alertStyle == "yesNo") {
        config.dwCommonButtons = TDCBF_YES_BUTTON | TDCBF_NO_BUTTON | TDCBF_NO_BUTTON;
    } else if (alertStyle == "yesNoCancel") {
        config.dwCommonButtons = TDCBF_YES_BUTTON | TDCBF_NO_BUTTON | TDCBF_NO_BUTTON;
    }

    if (iconStyle == "error" || iconStyle == "hand" || iconStyle == "stop") {
        config.pszMainIcon = TD_ERROR_ICON;
    } else if (iconStyle == "exclamation" || iconStyle == "warning") {
        config.pszMainIcon = TD_WARNING_ICON;
    } else if (iconStyle == "information" || iconStyle == "asterisk" || iconStyle == "question") {
        config.pszMainIcon = TD_INFORMATION_ICON;
    }

    auto hwnd = registrar_->GetView()->GetNativeWindow();
    WINDOWPLACEMENT placement = { 0 };
    GetWindowPlacement(hwnd, &placement);
    bool windowIsHidden = placement.rcNormalPosition.top == 0 && placement.rcNormalPosition.bottom == 0 && placement.rcNormalPosition.left == 0 && placement.rcNormalPosition.right == 0;

    if (windowIsHidden || windowPosition == 1) {
        hwnd = NULL;
    }

    config.hwndParent = hwnd;

    int nButtonPressed = 0;
    TaskDialogIndirect(&config, &nButtonPressed, NULL, NULL);
    return StringFromMessageBoxID(nButtonPressed);
}

std::string
FlutterPlatformAlertPlugin::ShowWithCustomButtons(
    std::wstring windowTitleUtf16,
    std::wstring textUtf16,
    std::string iconStyleString,
    std::wstring positiveButton,
    std::wstring negativeButton,
    std::wstring neutralButton,
    std::wstring additionalWindowTitle,
    bool showAsLinks,
    int windowPosition,
    std::wstring iconPath)
{
    TASKDIALOGCONFIG config = { 0 };
    config.cbSize = sizeof(config);
    config.pszMainInstruction = windowTitleUtf16.c_str();
    config.pszContent = textUtf16.c_str();
    TASKDIALOG_FLAGS flags = TDF_POSITION_RELATIVE_TO_WINDOW;
    if (showAsLinks) {
        flags |= TDF_USE_COMMAND_LINKS;
    }
    config.dwFlags = flags;
    if (!additionalWindowTitle.empty()) {
        config.pszWindowTitle = additionalWindowTitle.c_str();
    }

    TASKDIALOG_BUTTON buttons[3];

    int count = 0;
    if (!positiveButton.empty()) {
        buttons[count] = { CUSTOM_POSITIVE, positiveButton.c_str() };
        count++;
    }
    if (!neutralButton.empty()) {
        buttons[count] = { CUSTOM_NUETRAL, neutralButton.c_str() };
        count++;
    }
    if (!negativeButton.empty()) {
        buttons[count] = { CUSTOM_NEGATIVE, negativeButton.c_str() };
        count++;
    }

    if (count) {
        config.pButtons = buttons;
        config.cButtons = count;
    } else {
        config.dwCommonButtons = TDCBF_OK_BUTTON;
    }

    if (!iconPath.empty()) {
        config.dwFlags |= TDF_USE_HICON_MAIN;
        HICON hIcon = (HICON)LoadImage(nullptr, (LPCWSTR)(iconPath.c_str()), IMAGE_ICON,
            GetSystemMetrics(SM_CXSMICON), GetSystemMetrics(SM_CYSMICON), LR_LOADFROMFILE);
        config.hMainIcon = hIcon;
    } else if (iconStyleString == "error" || iconStyleString == "hand" || iconStyleString == "stop") {
        config.pszMainIcon = TD_ERROR_ICON;
    } else if (iconStyleString == "exclamation" || iconStyleString == "warning") {
        config.pszMainIcon = TD_WARNING_ICON;
    } else if (iconStyleString == "information" || iconStyleString == "asterisk" || iconStyleString == "question") {
        config.pszMainIcon = TD_INFORMATION_ICON;
    }

    auto hwnd = registrar_->GetView()->GetNativeWindow();

    WINDOWPLACEMENT placement = { 0 };
    GetWindowPlacement(hwnd, &placement);
    bool windowIsHidden = placement.rcNormalPosition.top == 0 && placement.rcNormalPosition.bottom == 0 && placement.rcNormalPosition.left == 0 && placement.rcNormalPosition.right == 0;

    if (windowIsHidden || windowPosition == 1) {
        hwnd = NULL;
    }
    config.hwndParent = hwnd;

    int nButtonPressed = 0;
    TaskDialogIndirect(&config, &nButtonPressed, NULL, NULL);
    return StringFromMessageBoxID(nButtonPressed);
}

void FlutterPlatformAlertPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue>& method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
{
    if (method_call.method_name().compare("playAlertSound") == 0) {
        std::string iconStyleString = GetString(method_call, "iconStyle");
        UINT iconStyle = IconTypeFromString(iconStyleString);
        MessageBeep(iconStyle);
        result->Success();
    } else if (method_call.method_name().compare("showAlert") == 0) {
        auto windowTitle = GetString(method_call, "windowTitle");
        auto text = GetString(method_call, "text");
        auto alertStyleString = GetString(method_call, "alertStyle");
        auto iconStyleString = GetString(method_call, "iconStyle");
        bool preferMessageBox = GetBool(method_call, "preferMessageBox");
        std::string additionalWindowTitle = GetString(method_call, "additionalWindowTitle");

        auto windowTitleUtf16 = Utf16FromUtf8(windowTitle.c_str());
        auto textUtf16 = Utf16FromUtf8(text.c_str());
        auto additionalWindowTitleUtf16 = Utf16FromUtf8(additionalWindowTitle.c_str());

        std::string response;

        int windowPosition = GetInt(method_call, "position");

        if (preferMessageBox) {
            response = ShowWithMessageBox(
                windowTitleUtf16, textUtf16, alertStyleString, iconStyleString, windowPosition);
        } else {
            response = ShowWithTaskDialogIndirect(windowTitleUtf16,
                textUtf16,
                alertStyleString,
                iconStyleString,
                additionalWindowTitleUtf16, windowPosition);
        }
        result->Success(EncodableValue(response.c_str()));

    } else if (method_call.method_name().compare("showCustomAlert") == 0) {
        auto windowTitle = GetString(method_call, "windowTitle");
        auto text = GetString(method_call, "text");
        auto iconStyleString = GetString(method_call, "iconStyle");
        auto positiveButton = GetString(method_call, "positiveButtonTitle");
        auto negativeButton = GetString(method_call, "negativeButtonTitle");
        auto neutralButton = GetString(method_call, "neutralButtonTitle");
        auto additionalWindowTitle = GetString(method_call, "additionalWindowTitle");
        auto iconPath = GetString(method_call, "iconPath");
        bool showAsLinksOnWindows = GetBool(method_call, "showAsLinksOnWindows");
        int windowPosition = GetInt(method_call, "position");

        auto windowTitleUtf16 = Utf16FromUtf8(windowTitle.c_str());
        auto textUtf16 = Utf16FromUtf8(text.c_str());
        auto positiveButtonUtf16 = Utf16FromUtf8(positiveButton.c_str());
        auto negativeButtonUtf16 = Utf16FromUtf8(negativeButton.c_str());
        auto neutralButtonUtf16 = Utf16FromUtf8(neutralButton.c_str());
        auto additionalWindowTitleUtf16 = Utf16FromUtf8(additionalWindowTitle.c_str());
        auto iconPathUtf16 = Utf16FromUtf8(iconPath.c_str());

        std::string response = ShowWithCustomButtons(windowTitleUtf16,
            textUtf16,
            iconStyleString,
            positiveButtonUtf16,
            negativeButtonUtf16,
            neutralButtonUtf16,
            additionalWindowTitleUtf16,
            showAsLinksOnWindows,
            windowPosition,
            iconPathUtf16);
        result->Success(EncodableValue(response.c_str()));
    } else {
        result->NotImplemented();
    }
}

} // namespace

void FlutterPlatformAlertPluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar)
{
    FlutterPlatformAlertPlugin::RegisterWithRegistrar(
        flutter::PluginRegistrarManager::GetInstance()
            ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
