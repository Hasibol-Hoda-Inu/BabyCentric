import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'application/app.dart';
import 'features/checkout/serivices/stripe_payment_gateway/key_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = publishable_key;
  await Stripe.instance.applySettings();
  runApp(const BabyCentric());
}
