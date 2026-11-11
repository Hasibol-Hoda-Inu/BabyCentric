import 'package:BabyCentric/features/common/ui/screens/main_bottom_nav_screen.dart';
import 'package:flutter/material.dart';


import '../../../../application/app_colors.dart';
import '../widgets/app_icon_widget.dart';

class SplashScreen extends StatefulWidget {
  static const name = "/";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _goToEmailVerificationScreen();
  }

  Future<void> _goToEmailVerificationScreen()async {
    await Future.delayed(const Duration(seconds: 2));
    if(mounted){
      Navigator.pushReplacementNamed(context, MainBottomNavScreen.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Spacer(),
              AppLogoWidget(),
              Spacer(),
              CircularProgressIndicator(color: AppColors.themeColor,),
              SizedBox(height: 20,),
              Text("Version: 1.0.0"),
            ],
          ),
        ),
      ),
    );
  }
}


