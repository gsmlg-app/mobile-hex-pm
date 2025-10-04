import 'dart:async';

import 'package:app_artwork/logo/gsmlg_dev.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_hex_pm/screens/home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  static const name = 'Splash Screen';
  static const path = '/';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    // Schedule navigation after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scheduleNavigation();
    });
  }

  void _scheduleNavigation() {
    _navigationTimer = Timer(const Duration(milliseconds: 1_000), () {
      if (mounted) {
        try {
          // Use GoRouter safely with mounted check
          context.go(HomeScreen.path);
        } catch (e) {
          debugPrint('Navigation error from splash screen: $e');
          // Fallback: try using Navigator if GoRouter fails
          try {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          } catch (fallbackError) {
            debugPrint('Fallback navigation also failed: $fallbackError');
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double w = screenWidth;
    if (screenHeight < screenWidth) {
      w = screenHeight;
    }
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: SizedBox(
          width: w * 0.618,
          height: w * 0.618,
           child: Center(
             child: LogoGSMLGDEV(),
           ),
        ),
      ),
    );
  }
}
