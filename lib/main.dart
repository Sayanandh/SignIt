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
import 'screens/map_screen.dart';
import 'screens/history_screen.dart';
import 'screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.backgroundColor,
      systemNavigationBarIconBrightness: Brightness.dark,
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
        initialRoute: AppRoutes.home,
        routes: {
          AppRoutes.home: (context) => const HomeScreen(),
          AppRoutes.imageUpload: (context) => const ImageUploadScreen(),
          AppRoutes.videoUpload: (context) => const VideoUploadScreen(),
          AppRoutes.results: (context) => const ResultsScreen(),
          AppRoutes.camera: (context) => const CameraScreen(),
          AppRoutes.map: (context) => const MapScreen(),
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
