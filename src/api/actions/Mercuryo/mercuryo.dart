import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> createPaymentSession() async {
  final url = Uri.parse('https://sandbox-api.mrcr.io/v1.6/payments/create');
  final response = await http.post(url, headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer YOUR_API_KEY', // Replace with your API key
  }, body: jsonEncode({
    "currency": "usd",  // Adjust based on the currency you want
    "amount": "100",    // The amount to pay
    "wallet_address": "USER_WALLET_ADDRESS"  // User's wallet address for payment
  }));

  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    return jsonResponse['widget_url'];  // Assuming this is returned
  } else {
    throw Exception('Failed to create payment session');
  }
}