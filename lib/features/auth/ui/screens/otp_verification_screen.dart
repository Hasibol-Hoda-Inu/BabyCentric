import 'package:BabyCentric/features/auth/ui/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../application/app_colors.dart';
import '../../../common/ui/widgets/centered_circular_progress_indicator.dart';
import '../../../common/ui/widgets/show_snackbar_message.dart';
import '../controllers/otp_verification_controller.dart';
import '../controllers/sign_in_controller.dart';
import '../controllers/timer_controller.dart';
import '../widgets/app_icon_widget.dart';

class OtpVerificationScreen extends StatefulWidget {
  static const name = "/OtpVerification";
  const OtpVerificationScreen({
    super.key,
    required this.email,
    required this.password,
  });
  final String email;
  final String password;

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final PinInputController _otpController = PinInputController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TimerController _timerController = Get.find<TimerController>();
  final OtpVerificationController _otpVController = Get.find<OtpVerificationController>();
  final SignInController _emailVController = Get.find<SignInController>();

  @override
  void initState() {
    super.initState();
    _timerController.startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 120,),
              const AppLogoWidget(),
              const SizedBox(height: 36,),
              Text("Enter OTP Code", style: Theme.of(context).textTheme.titleLarge ,),
              Text("A 4 digit OTP code has been sent", style: Theme.of(context).textTheme.bodyLarge,),
              const SizedBox(height: 24,),

              Form(
                key: _formKey,
                child: MaterialPinFormField(
                  length: 4,
                  pinController: _otpController,
                  obscureText: false,
                  keyboardType: TextInputType.number,
                  enableAutofill: true,
                  autofillHints: const [AutofillHints.oneTimeCode],
                  theme: MaterialPinTheme(
                    shape: MaterialPinShape.outlined,
                    borderRadius: BorderRadius.circular(5),
                    cellSize: const Size(40, 50),
                    spacing: 8,
                    borderColor: AppColors.themeColor,
                    focusedBorderColor: AppColors.themeColor,
                    filledBorderColor: AppColors.themeColor,
                    completeBorderColor: AppColors.themeColor,
                    fillColor: Colors.transparent,
                    focusedFillColor: Colors.transparent,
                    filledFillColor: Colors.transparent,
                    cursorColor: AppColors.themeColor,
                    entryAnimation: MaterialPinAnimation.fade,
                    animationDuration: const Duration(
                      milliseconds: 300,
                    ),
                  ),
                  validator: (String? value) {
                    if (value == null || value.length != 4) {
                      return 'Enter your OTP';
                    }
                    return null;
                  },
                  onCompleted: (String pin) {
                    debugPrint('OTP entry completed');
                  },
                ),
              ),
              const SizedBox(height: 24,),
              GetBuilder<TimerController>(
                builder: (controller) {
                  return Visibility(
                    visible: _otpVController.inProgress == false,
                    replacement: const CenteredCircularProgressIndicator(),
                    child: ElevatedButton(
                        onPressed: !controller.isButtonActive
                            ? _handleButtonPress : null,
                        child: const Text("Next")),
                  );
                }
              ),
              const SizedBox(height: 24,),
              GetBuilder<TimerController>(
                builder: (controller) {
                  if(controller.remainingTime>0){
                    return RichText(text: TextSpan(
                        text: "This code will expire in ", style: Theme.of(context).textTheme.bodyLarge,
                        children: [
                          TextSpan(
                              text: controller.remainingTime.toString(),
                              style: const TextStyle(color: AppColors.themeColor)
                          )
                        ]
                    ));
                  }else{
                    return const SizedBox.shrink();
                  }
                }
              ),
              GetBuilder<TimerController>(
                builder: (controller) {
                  return Visibility(
                    visible: controller.isButtonActive,
                    replacement: const SizedBox(),
                    child: TextButton(
                      onPressed: (){
                        ///TODO: email send krr api call hbe
                        _resendVerifyEmailAddress();
                      },
                      child: const Text("Resend code"),
                     ),
                  );
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _handleButtonPress(){
    if(_formKey.currentState!.validate()){
      _getOtpVerification();
    }
  }

  Future<void> _getOtpVerification()async {
    final bool isSuccess = await _otpVController.verifyOtp(widget.email, _otpController.text);
    if(isSuccess){
      _timerController.startTimer();
      if(mounted){
        Navigator.pushNamedAndRemoveUntil(context, SignInScreen.name, (predicate)=>false);
      }
    }else{
      if(mounted){
        showSnackBarMessage(context, _otpVController.errorMessage ?? "Something went wrong");
      }
    }
  }

  Future<void> _resendVerifyEmailAddress()async {
    final bool isSuccess = await _emailVController.signIn(widget.email, widget.password);
    if(isSuccess){
      _timerController.startTimer();
    }else{
      if(mounted){
        showSnackBarMessage(context, _emailVController.errorMessage ?? "Something went wrong");
      }
    }
  }

  @override
  void dispose() {
    _otpVController.dispose();
    _timerController.dispose();
    super.dispose();
  }
}
