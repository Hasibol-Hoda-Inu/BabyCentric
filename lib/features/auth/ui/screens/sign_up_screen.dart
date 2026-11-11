import 'package:BabyCentric/features/auth/ui/screens/sign_in_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/ui/screens/main_bottom_nav_screen.dart';
import '../../../common/ui/widgets/centered_circular_progress_indicator.dart';
import '../../../common/ui/widgets/show_snackbar_message.dart';
import '../../utils/regex_validators.dart';
import '../controllers/sign_up_controller.dart';
import '../widgets/app_icon_widget.dart';
import 'otp_verification_screen.dart';

class SignUpScreen extends StatefulWidget {
  static const String name = "/CompleteProfileScreen";
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _cityTEController = TextEditingController();

  final SignUpController _signUpController = Get.find<SignUpController>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop,__){
        if(didPop)return;
        Navigator.pushNamedAndRemoveUntil(context, MainBottomNavScreen.name, (predicate)=>false);
        },
      child: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const AppLogoWidget(),
                  const SizedBox(height: 24,),
                  Text("Sign up", style: Theme.of(context).textTheme.titleLarge ,),
                  Text("Get started with us with your details", style: Theme.of(context).textTheme.bodyLarge,),
                  const SizedBox(height: 8,),
                  buildAHanAccountMethod(context),
                  const SizedBox(height: 24,),
                  Form(
                      key: _formKey,
                      child: Column(
                        spacing: 24,
                        children: [
                          TextFormField(
                            controller: _firstNameTEController,
                            validator: (value){
                              if(value == null || value.isEmpty){
                                return "Enter your first name";
                              }
                              return null;
                            },
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            decoration: const InputDecoration(
                                hintText: 'First name'
                            ),
                          ),
                          TextFormField(
                            controller: _lastNameTEController,
                            validator: (value){
                              if(value == null || value.isEmpty){
                                return "Enter your last name";
                              }
                              return null;
                            },
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            decoration: const InputDecoration(
                                hintText: 'Last name'
                            ),
                          ),
                          TextFormField(
                            controller: _emailTEController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value){
                              if(value == null || value.isEmpty){
                                return "Enter your email";
                              }else if(!value.isValidEmail()){
                                return "Enter a valid email";
                              }
                              return null;
                            },
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            decoration: const InputDecoration(
                                hintText: 'Email'
                            ),
                          ),
                          TextFormField(
                            controller: _passwordTEController,
                            validator: (value){
                              if((value == null || value.isEmpty) || value.length < 6){
                                return "Enter a password min 6 characters";
                              }
                              return null;
                            },
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            decoration: const InputDecoration(
                                hintText: 'Password'
                            ),
                          ),
                          TextFormField(
                            controller: _mobileTEController,
                            keyboardType: TextInputType.phone,
                            validator: (value){
                              if(value == null || value.isEmpty){
                                return "Enter your mobile number";
                              }else if(!value.isValidBangladeshiMobile()){
                                return "Enter a valid mobile number";
                              }
                              return null;
                            },
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            decoration: const InputDecoration(
                                hintText: 'NO.'
                            ),
                          ),
                          TextFormField(
                            controller: _cityTEController,
                            validator: (value){
                              if(value == null || value.isEmpty){
                                return "Enter your city";
                              }
                              return null;
                            },
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            decoration: const InputDecoration(
                                hintText: 'City'
                            ),
                          ),
                        ],
                      ),
                  ),
                  const SizedBox(height: 24,),
                  GetBuilder<SignUpController>(
                    builder: (controller) {
                      if(controller.inProgress){
                        return const CenteredCircularProgressIndicator();
                      }
                      return ElevatedButton(
                          onPressed: (){
                            _onTapNextScreen();
                          },
                          child: const Text("Complete"),
                      );
                    }
                  ),
                  const SizedBox(height: 24,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAHanAccountMethod(BuildContext context) {
    return RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyLarge, // Inherit default text style
              children: <TextSpan>[
                const TextSpan(text: 'Already have an account? '),
                TextSpan(
                  text: 'Sign in',
                  style: const TextStyle(
                    color: Colors.blue, // Customize sign-in text color
                    fontWeight: FontWeight.bold, // Make it bolder
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = onSignInTap, // Attach the onTap callback
                ),
              ],
            ),
          );
  }

  void onSignInTap(){
    Navigator.pushNamedAndRemoveUntil(context, SignInScreen.name, (predicate)=>false);
  }

  void _onTapNextScreen(){
    if(_formKey.currentState!.validate()){
      _createProfile();
    }
  }

  Future<void> _createProfile()async {
    final bool isSuccess = await Get.find<SignUpController>().signUp(
        _firstNameTEController.text.trim(),
        _lastNameTEController.text.trim(),
        _emailTEController.text.trim(),
        _passwordTEController.text,
        _cityTEController.text.trim(),
        _mobileTEController.text.trim()

    );
    if(isSuccess){
      if(mounted){
        Navigator.pushNamedAndRemoveUntil(
            context, OtpVerificationScreen.name,
            arguments: {
              "email": _emailTEController.text.trim(),
              "password": _passwordTEController.text
            },
                (predicate)=>false
        );
      }
    }else{
      if(mounted){
        showSnackBarMessage(context, _signUpController.errorMessage ?? "Something went wrong");
      }
    }
  }

  @override
  void dispose() {
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _emailTEController.dispose();
    _passwordTEController.dispose();
    _cityTEController.dispose();
    _mobileTEController.dispose();
    super.dispose();
  }
}
