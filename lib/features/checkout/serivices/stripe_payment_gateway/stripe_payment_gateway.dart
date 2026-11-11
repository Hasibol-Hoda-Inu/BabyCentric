import 'dart:convert';
import 'dart:developer';

import 'package:BabyCentric/features/checkout/serivices/stripe_payment_gateway/key_constants.dart';
import 'package:BabyCentric/features/checkout/ui/screens/thank_you_screen.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';

class StripePaymentGateway extends GetxController {
  String secret_key = s_key; // TODO: Replace with your secret key
  Map<String, dynamic>? paymentIntent;
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  Future<void> makePayment(String amount) async {
    try {
      paymentIntent = await createPaymentIntent(amount, 'USD');

      if (paymentIntent == null || paymentIntent!['client_secret'] == null) {
        log('Error creating Payment Intent or client secret is missing.');
        return;
      }
      _inProgress = true;
      update();
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          merchantDisplayName: 'The Coder Brain',
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          customFlow: true, // Keep customFlow: true as in your original code
          googlePay: const PaymentSheetGooglePay(
            merchantCountryCode: 'PK',
            currencyCode: 'USD',
            testEnv: true, // Keep testEnv: true for testing, remember to set to false for production
          ),
        ),
      );
      _inProgress = false;
      update();
      await displayPaymentSheet();
    } catch (e) {
      log('Error during payment process: ${e.toString()}');
      // Handle error appropriately, e.g., show error message to user
    }
  }

  Future<Map<String, dynamic>?> createPaymentIntent(
    String amount,
    String currency,
  ) async {
    try {
      Map<String, dynamic> body = {
        'currency': currency,
        'amount': (int.parse(amount) * 100).toString(), // Amount in cents
        'payment_method_types[]': 'card',
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $secret_key',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        log(
          'Failed to create Payment Intent. Status Code: ${response.statusCode}, Body: ${response.body}',
        );
        return null; // Indicate failure
      }
    } catch (e) {
      log('Error creating Payment Intent: ${e.toString()}');
      return null; // Indicate failure on exception
    }
  }

  Future<void> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();

      ///TODO: Consider adding success handling here, e.g., update UI, navigate to success screen

      Get.offNamed(ThankYouScreen.name);

      log(
        'Payment Sheet presented and payment completed successfully (if user completed it).',
      );
      paymentIntent = null;
    } catch (e) {
      log('Stripe Platform Exception: ${e.toString()}');
    }
  }
}
