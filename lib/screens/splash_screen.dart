import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';

import '../constants/app_constants.dart';
import '../constants/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to onboarding screen after 3 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App logo animation
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.sign_language,
                    size: 80,
                    color: AppColors.primaryColor,
                  ),
                ),
              )
              .animate()
              .scale(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOut,
                begin: const Offset(0.8, 0.8),
                end: const Offset(1, 1),
              )
              .then()
              .shimmer(
                duration: const Duration(milliseconds: 1500),
                color: Colors.white.withOpacity(0.8),
              ),
              
              const SizedBox(height: 40),
              
              // App name
              Text(
                AppStrings.appName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              )
              .animate()
              .fadeIn(
                duration: const Duration(milliseconds: 800),
                delay: const Duration(milliseconds: 400),
              )
              .slideY(
                begin: 0.2,
                end: 0,
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 800),
                delay: const Duration(milliseconds: 400),
              ),
              
              const SizedBox(height: 16),
              
              // App tagline
              Text(
                AppStrings.appTagline,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              )
              .animate()
              .fadeIn(
                duration: const Duration(milliseconds: 800),
                delay: const Duration(milliseconds: 800),
              ),
              
              const SizedBox(height: 80),
              
              // Loading indicator
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 3,
              )
              .animate()
              .fadeIn(
                duration: const Duration(milliseconds: 500),
                delay: const Duration(milliseconds: 1200),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 