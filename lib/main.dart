import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'constants/app_constants.dart';
import 'constants/app_theme.dart';
import 'providers/sign_interpreter_provider.dart';
import 'screens/home_screen.dart';
import 'screens/image_upload_screen.dart';
import 'screens/video_upload_screen.dart';
import 'screens/results_screen.dart';
import 'screens/camera_screen.dart';
import 'screens/history_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';

void main() async {
  // Initialize Flutter binding first
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set system UI settings
  if (Platform.isAndroid) {
    // Set portrait orientation only
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    
    // Set system UI mode
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  } else {
    // Set preferred orientations for iOS
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SignInterpreterProvider()),
      ],
      child: MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.splash,
        routes: {
          AppRoutes.splash: (context) => const SplashScreen(),
          AppRoutes.onboarding: (context) => const OnboardingScreen(),
          AppRoutes.home: (context) => const HomeScreen(),
          AppRoutes.imageUpload: (context) => const ImageUploadScreen(),
          AppRoutes.videoUpload: (context) => const VideoUploadScreen(),
          AppRoutes.results: (context) => const ResultsScreen(),
          AppRoutes.camera: (context) => const CameraScreen(),
          AppRoutes.history: (context) => const HistoryScreen(),
          AppRoutes.settings: (context) => const SettingsScreen(),
          // Add other routes as they are implemented
        },
        onGenerateRoute: (settings) {
          // Handle dynamic routes or routes with parameters
          return null;
        },
      ),
    );
  }
}
