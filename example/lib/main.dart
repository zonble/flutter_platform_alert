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
                            child: const Text('Play Alert Sound')),
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
                                iconStyle: IconStyle.exclamation,
                              );
                              print(result);
                            },
                            child: const Text('Show exclamation style')),
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
                                iconStyle: IconStyle.information,
                              );
                              print(result);
                            },
                            child: const Text('Show information style')),
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
                                      alertStyle: AlertStyle.okCancel);
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
                                      alertStyle: AlertStyle.abortRetryIgnore);
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
                                      alertStyle: AlertStyle.cancelTryContinue);
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
                                      alertStyle: AlertStyle.retryCancel);
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
                                      alertStyle: AlertStyle.yesNo);
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
                                      alertStyle: AlertStyle.yesNoCancel);
                              print(result);
                            },
                            child: const Text('Show Yes No Cancel')),
                      ),
                    ]),
              ),
            )));
  }
}
