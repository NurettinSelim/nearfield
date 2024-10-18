import 'dart:convert';
import 'package:http/http.dart' as http;

class MercuryoService {
  Future<String> createPaymentSession(String currency, String amount, String walletAddress) async {
    final url = Uri.parse('https://sandbox-api.mrcr.io/v1.6/payments/create');
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer YOUR_API_KEY', // Replace with your API key
        },
        body: jsonEncode({
          "currency": currency, // Adjust based on the currency you want
          "amount": amount, // The amount to pay
          "wallet_address": walletAddress // User's wallet address for payment
        }));

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse['widget_url']; // Assuming this is returned
    } else {
      throw Exception('Failed to create payment session');
    }
  }
}
