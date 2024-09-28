// welcome_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_nfc_hce/flutter_nfc_hce.dart';
import 'package:go_router/go_router.dart';
import 'package:nearfield/ui/neon_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void navigate(String role) {
      context.push('/$role');
    }

    final flutterNfcHcePlugin = FlutterNfcHce();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo.png'),
              const SizedBox(height: 20),
              NeonButton(
                onPressed: () async {
                  // navigate('customer');

//getPlatformVersion
                  var platformVersion =
                      await flutterNfcHcePlugin.getPlatformVersion();

//isNfcHceSupported
                  bool? isNfcHceSupported =
                      await flutterNfcHcePlugin.isNfcHceSupported();

//isSecureNfcEnabled
                  bool? isSecureNfcEnabled =
                      await flutterNfcHcePlugin.isSecureNfcEnabled();

//isNfcEnabled
                  bool? isNfcEnabled = await flutterNfcHcePlugin.isNfcEnabled();

                  print('platformVersion: $platformVersion');
                  print('isNfcHceSupported: $isNfcHceSupported');
                  print('isSecureNfcEnabled: $isSecureNfcEnabled');
                  print('isNfcEnabled: $isNfcEnabled');

//nfc content
                  var content = "https://www.google.com";

//start nfc hce
                  await flutterNfcHcePlugin.startNfcHce(content,
                      mimeType: 'application/json', persistMessage: true);

//stop nfc hce
                  // await flutterNfcHcePlugin.stopNfcHce();
                },
                text: "Customer",
              ),
              const SizedBox(height: 20),
              NeonButton(
                onPressed: () {
                  // navigate('merchant');
                  flutterNfcHcePlugin.stopNfcHce();
                },
                text: "Merchant",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
