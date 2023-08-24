import 'package:flower_classifier/screens/splash_screen.dart';
import 'package:flower_classifier/utils/colors.dart';
import 'package:flower_classifier/utils/size_config.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: AppColors.primaryColor,
        primaryColorDark: AppColors.primaryColorDark,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primaryColor,
          centerTitle: false,
          titleTextStyle: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: AppColors.white),
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: AppColors.primaryColor,
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
