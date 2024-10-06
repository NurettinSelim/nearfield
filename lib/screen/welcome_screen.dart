// welcome_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_nfc_hce/flutter_nfc_hce.dart';
import 'package:qr_flutter/qr_flutter.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final flutterNfcHcePlugin = FlutterNfcHce();
  final _formKey = GlobalKey<FormState>();
  String _recipient = '';
  String _amount = '';
  bool _isNfcHceRunning = false;
  String _solflareUrl = '';

  Future<void> _startNfcHce() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    // Construct the Solflare deep link URL
    String baseUrl = 'solflare:';
    Uri solflareUri = Uri.parse(baseUrl).replace(queryParameters: {
      'recipient': _recipient,
      'amount': _amount,
      'label': 'Merchant Payment',
      'message': 'Payment for goods or services',
    });

    String content = solflareUri.toString();

    // Update the URL for QR code display
    setState(() {
      _solflareUrl = content;
    });

    // NFC HCE code remains the same
    try {
      await flutterNfcHcePlugin.startNfcHce(
        content,
        mimeType: 'text/uri-list',
        persistMessage: true,
      );
      setState(() {
        _isNfcHceRunning = true;
      });
      _showMessage('Your phone is now acting as an NFC tag. Customer can tap to pay.');
    } catch (e) {
      print('NFC HCE Error: $e');
      _showMessage('Failed to start NFC HCE.');
    }
  }

  Future<void> _stopNfcHce() async {
    try {
      await flutterNfcHcePlugin.stopNfcHce();
      setState(() {
        _isNfcHceRunning = false;
      });
      _showMessage('NFC HCE stopped.');
    } catch (e) {
      print('Error stopping NFC HCE: $e');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    if (_isNfcHceRunning) {
      flutterNfcHcePlugin.stopNfcHce();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build the UI
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Receive Solana Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children: [
                Image.asset('assets/logo.png'),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Your Wallet Address',
                    hintText: 'Enter your wallet address',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your wallet address';
                    }
                    // Add additional validation for wallet address if necessary
                    return null;
                  },
                  onSaved: (value) {
                    _recipient = value!;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Amount to Receive (SOL)',
                    hintText: 'Enter amount',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _amount = value!;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isNfcHceRunning ? null : _startNfcHce,
                  child: const Text('Start NFC Payment'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isNfcHceRunning ? _stopNfcHce : null,
                  child: const Text('Stop NFC Payment'),
                ),
                const SizedBox(height: 20),
                if (_solflareUrl.isNotEmpty)
                  Column(
                    children: [
                      const Text(
                        'Scan the QR code below to pay with Solflare Wallet:',
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        color: Colors.white,
                        child: QrImageView(
                          data: _solflareUrl,
                          size: 200.0,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Solflare Deep Link URL:',
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 5),
                      SelectableText(
                        _solflareUrl,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
