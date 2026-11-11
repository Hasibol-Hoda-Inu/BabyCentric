import 'package:BabyCentric/features/common/ui/controllers/main_bottom_nav_controller.dart';
import 'package:BabyCentric/features/common/ui/screens/main_bottom_nav_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThankYouScreen extends StatelessWidget {
  static const String name = "/thank-you-screen";

  const ThankYouScreen({super.key, this.orderId});
  final String? orderId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Pure white background for lightness
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(
            32.0,
          ), // Generous padding around content
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_outline, // A classic checkmark icon
                size: 80.0,
                color: Colors.green, // Positive green color
              ),
              const SizedBox(height: 32.0),
              const Text(
                "Thank You!",
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold, // Deep, sophisticated grey
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),
              Text(
                "Your payment was successful and your order is being processed.",
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48.0),
              ElevatedButton(
                onPressed: () {
                  _onPop();
                },
                child: const Text("Continue Shopping"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onPop() {
    Get.find<MainBottomNavController>().backToHome();
    Get.offNamed(MainBottomNavScreen.name);
  }
}
