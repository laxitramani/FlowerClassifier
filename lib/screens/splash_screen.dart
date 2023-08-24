import 'package:flower_classifier/screens/home_screen.dart';
import 'package:flower_classifier/utils/assets.dart';
import 'package:flower_classifier/utils/colors.dart';
import 'package:flower_classifier/utils/size_config.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 2),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor,
            AppColors.primaryColorDark,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: AppColors.transparent,
        body: Center(
          child: Hero(
            tag: "logo",
            child: Image.asset(
              AppAssets.appLogo,
              height: getProportionateScreenHeight(350),
              width: getProportionateScreenHeight(350),
            ),
          ),
        ),
      ),
    );
  }
}
