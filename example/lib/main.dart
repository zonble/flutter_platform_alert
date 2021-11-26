// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(title: const Text('Flutter Platform Alert')),
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: () async {
                              await FlutterPlatformAlert.playAlertSound();
                            },
                            child: const Text('Play Alert Sound (Default)')),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: () async {
                              await FlutterPlatformAlert.playAlertSound(
                                iconStyle: IconStyle.exclamation,
                              );
                            },
                            child:
                                const Text('Play Alert Sound (exclamation)')),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: () async {
                              await FlutterPlatformAlert.playAlertSound(
                                iconStyle: IconStyle.error,
                              );
                            },
                            child: const Text('Play Alert Sound (error)')),
                      ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: () async {
                              final result =
                                  await FlutterPlatformAlert.showAlert(
                                windowTitle: '白日依山盡 黃河入海流',
                                text: '芋頭西米露 保力達蠻牛',
                                iconStyle: IconStyle.exclamation,
                                alertStyle: AlertButtonStyle.abortRetryIgnore,
                                options: FlutterPlatformAlertOption(
                                    preferMessageBoxOnWindows: true),
                              );
                              print(result);
                            },
                            child: const Text('Show non-ascii characters')),
                      ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: () async {
                              final result =
                                  await FlutterPlatformAlert.showAlert(
                                windowTitle: 'This ia title',
                                text: 'This is body',
                                iconStyle: IconStyle.information,
                              );
                              print(result);
                            },
                            child: const Text('Show information style')),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: () async {
                              final result =
                                  await FlutterPlatformAlert.showAlert(
                                windowTitle: 'This ia title',
                                text: 'This is body',
                                iconStyle: IconStyle.warning,
                              );
                              print(result);
                            },
                            child: const Text('Show warning style')),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: () async {
                              final result =
                                  await FlutterPlatformAlert.showAlert(
                                windowTitle: 'This ia title',
                                text: 'This is body',
                                iconStyle: IconStyle.error,
                              );
                              print(result);
                            },
                            child: const Text('Show error style')),
                      ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: () async {
                              final result =
                                  await FlutterPlatformAlert.showAlert(
                                      windowTitle: 'This ia title',
                                      text: 'This is body');
                              print(result);
                            },
                            child: const Text('Show OK')),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: () async {
                              final result =
                                  await FlutterPlatformAlert.showAlert(
                                      windowTitle: 'This ia title',
                                      text: 'This is body',
                                      alertStyle: AlertButtonStyle.okCancel);
                              print(result);
                            },
                            child: const Text('Show OK Cancel')),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: () async {
                              final result =
                                  await FlutterPlatformAlert.showAlert(
                                      windowTitle: 'This ia title',
                                      text: 'This is body',
                                      alertStyle:
                                          AlertButtonStyle.abortRetryIgnore);
                              print(result);
                            },
                            child: const Text('Show Abort Retry Ignore')),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: () async {
                              final result =
                                  await FlutterPlatformAlert.showAlert(
                                      windowTitle: 'This ia title',
                                      text: 'This is body',
                                      alertStyle:
                                          AlertButtonStyle.cancelTryContinue);
                              print(result);
                            },
                            child: const Text('Show Cancel Try Continue')),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: () async {
                              final result =
                                  await FlutterPlatformAlert.showAlert(
                                      windowTitle: 'This ia title',
                                      text: 'This is body',
                                      alertStyle: AlertButtonStyle.retryCancel);
                              print(result);
                            },
                            child: const Text('Show Retry Cancel')),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: () async {
                              final result =
                                  await FlutterPlatformAlert.showAlert(
                                      windowTitle: 'This ia title',
                                      text: 'This is body',
                                      alertStyle: AlertButtonStyle.yesNo);
                              print(result);
                            },
                            child: const Text('Show Yes No')),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: () async {
                              final result =
                                  await FlutterPlatformAlert.showAlert(
                                      windowTitle: 'This ia title',
                                      text: 'This is body',
                                      alertStyle: AlertButtonStyle.yesNoCancel);
                              print(result);
                            },
                            child: const Text('Show Yes No Cancel')),
                      ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: () async {
                              final result =
                                  await FlutterPlatformAlert.showCustomAlert(
                                windowTitle: 'This ia title',
                                text: 'This is body',
                                positiveButtonTitle: "Positive",
                                negativeButtonTitle: "Negative",
                                neutralButtonTitle: "Neutral",
                                options: FlutterPlatformAlertOption(
                                    additionalWindowTitleOnWindows:
                                        'Window title',
                                    showAsLinksOnWindows: true),
                              );
                              print(result);
                            },
                            child: const Text('Show Yes No Cancel')),
                      ),
                    ]),
              ),
            )));
  }
}
