import 'package:BabyCentric/features/auth/ui/screens/sign_up_screen.dart';
import 'package:BabyCentric/features/auth/utils/regex_validators.dart';
import 'package:BabyCentric/features/cart/ui/controllers/cart_list_controller.dart';
import 'package:BabyCentric/features/checkout/serivices/stripe_payment_gateway/stripe_payment_gateway.dart';
import 'package:BabyCentric/features/checkout/ui/controllers/create_order_controller.dart';
import 'package:BabyCentric/features/checkout/ui/screens/thank_you_screen.dart';
import 'package:BabyCentric/features/common/ui/controllers/auth_controller.dart';
import 'package:BabyCentric/features/common/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:BabyCentric/features/common/ui/widgets/show_snackbar_message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../auth/ui/widgets/app_icon_widget.dart';

class CheckoutScreen extends StatefulWidget {
  static const String name = "/checkout-screen";
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

enum RadioSelection { option1, option2, none }

class _CheckoutScreenState extends State<CheckoutScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameTEController = TextEditingController();
  final TextEditingController _shippingAddressTEController =
      TextEditingController();
  final TextEditingController _cityTEController = TextEditingController();
  final TextEditingController _postCodeTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final CreateOrderController _createOrderController =
      Get.find<CreateOrderController>();
  final CartListController _cartListController = Get.find<CartListController>();
  final StripePaymentGateway _stripePayment = Get.find<StripePaymentGateway>();
  final AuthController _auth = Get.find<AuthController>();
  RadioSelection _selectedRadio = RadioSelection.none;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const AppLogoWidget(),
                const SizedBox(height: 24),
                Form(
                  key: _formKey,
                  child: Column(
                    spacing: 12,
                    children: [
                      TextFormField(
                        controller: _fullNameTEController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter your full name";
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                          hintText: 'Full Name',
                        ),
                      ),
                      TextFormField(
                        controller: _shippingAddressTEController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Shipping Address";
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(hintText: 'Address'),
                      ),
                      Row(
                        spacing: 12,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _cityTEController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "City";
                                }
                                return null;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: const InputDecoration(
                                hintText: 'City',
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _postCodeTEController,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Post Code";
                                }
                                return null;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: const InputDecoration(
                                hintText: 'Post Code',
                              ),
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        controller: _mobileTEController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter your mobile number";
                          } else if (!value.isValidBangladeshiMobile()) {
                            return "Enter a valid mobile number";
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(hintText: 'NO.'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      RadioListTile<RadioSelection>(
                        title: const Text("Cash on delivery"),
                        value: RadioSelection.option1,
                        groupValue: _selectedRadio,
                        onChanged: (RadioSelection? value) {
                          setState(() {
                            _selectedRadio = value!;
                          });
                        },
                      ),
                      RadioListTile<RadioSelection>(
                        title: const Text('Cart payment'),
                        value: RadioSelection.option2,
                        groupValue: _selectedRadio,
                        onChanged: (RadioSelection? value) {
                          setState(() {
                            _selectedRadio = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ), // Spacing between radio buttons and button
                _buildButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTapCODCheckout() {
    if (_formKey.currentState!.validate()) {
      _createOrder();
    }
  }

  void _onTapStripeCheckout() {
    if (_formKey.currentState!.validate()) {
      _payment();
    }
  }

  void _payment() {
    String amount = _cartListController.totalPrice.toString();
    _stripePayment.makePayment(amount);
  }

  Future<void> _createOrder() async {
    bool loggedIn = await _auth.isUserLoggedIn();
    if (loggedIn) {
      bool result = await _createOrderController.postCreateOrder(
        _auth.accessToken!,
        _fullNameTEController.text.trim(),
        _shippingAddressTEController.text.trim(),
        _cityTEController.text.trim(),
        _postCodeTEController.text.trim(),
        _mobileTEController.text.trim(),
      );
      if (result && mounted) {
        _clearUserInput();
        Navigator.pushNamedAndRemoveUntil(
          context,
          ThankYouScreen.name,
          (predicate) => false,
        );
        // showSnackBarMessage(context, "order Created Successfully");
      } else {
        if (mounted) {
          showSnackBarMessage(
            context,
            _createOrderController.errorMessage ??
                "Something went wrong, please try again",
            false,
          );
        }
      }
    } else {
      if (mounted) {
        Navigator.pushNamed(context, SignUpScreen.name);
      }
    }
  }

  void _clearUserInput() {
    _fullNameTEController.clear();
    _shippingAddressTEController.clear();
    _cityTEController.clear();
    _postCodeTEController.clear();
    _mobileTEController.clear();
  }

  Widget _buildButton() {
    switch (_selectedRadio) {
      case RadioSelection.option1:
        return GetBuilder<CreateOrderController>(
          builder: (controller) {
            if (controller.inProgress) {
              return const CenteredCircularProgressIndicator();
            }
            return ElevatedButton(
              onPressed: () {
                _onTapCODCheckout();
              },
              child: Text("Pay \$${_cartListController.totalPrice}"),
            );
          },
        );
      case RadioSelection.option2:
        return GetBuilder<StripePaymentGateway>(
          builder: (controller) {
            if (controller.inProgress) {
              return const CenteredCircularProgressIndicator();
            }
            return ElevatedButton(
              onPressed: () {
                _onTapStripeCheckout();
              },
              child: Text("Pay \$${_cartListController.totalPrice}"),
            );
          },
        );
      case RadioSelection.none:
        return Container();
    }
  }

  @override
  void dispose() {
    _fullNameTEController.dispose();
    _shippingAddressTEController.dispose();
    _cityTEController.dispose();
    _postCodeTEController.dispose();
    _mobileTEController.dispose();
    super.dispose();
  }
}
