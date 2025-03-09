class AppStrings {
  // App name
  static const String appName = 'SignIt';
  static const String appTagline = 'Breaking barriers through sign language';
  
  // Onboarding
  static const String onboardingTitle1 = 'Welcome to SignIt';
  static const String onboardingDesc1 = 'A modern sign language interpretation system designed to bridge communication gaps.';
  
  static const String onboardingTitle2 = 'Multiple Input Methods';
  static const String onboardingDesc2 = 'Upload images, videos, or use real-time camera feed to interpret sign language.';
  
  static const String onboardingTitle3 = 'Accurate Translations';
  static const String onboardingDesc3 = 'Our advanced AI model provides accurate and fast sign language translations.';
  
  static const String getStarted = 'Get Started';
  static const String next = 'Next';
  static const String skip = 'Skip';
  
  // Home Screen
  static const String homeTitle = 'How would you like to interpret?';
  static const String cameraOption = 'Live Camera';
  static const String imageOption = 'Upload Image';
  static const String videoOption = 'Upload Video';
  static const String mapOption = 'Sign Language Map';
  static const String historyOption = 'History';
  static const String settingsOption = 'Settings';
  
  // Camera Screen
  static const String cameraTitle = 'Live Interpretation';
  static const String cameraInstructions = 'Point your camera at sign language gestures';
  static const String captureButton = 'Capture';
  static const String switchCameraButton = 'Switch Camera';
  
  // Image Upload
  static const String imageUploadTitle = 'Image Interpretation';
  static const String imageUploadInstructions = 'Upload an image containing sign language gestures';
  static const String selectImage = 'Select Image';
  static const String takePhoto = 'Take Photo';
  
  // Video Upload
  static const String videoUploadTitle = 'Video Interpretation';
  static const String videoUploadInstructions = 'Upload a video containing sign language gestures';
  static const String selectVideo = 'Select Video';
  static const String recordVideo = 'Record Video';
  
  // Map Screen
  static const String mapTitle = 'Sign Language Map';
  static const String mapInstructions = 'Explore sign language resources near you';
  
  // Results Screen
  static const String resultsTitle = 'Interpretation Results';
  static const String copyText = 'Copy Text';
  static const String shareText = 'Share';
  static const String saveToHistory = 'Save to History';
  
  // Settings
  static const String settingsTitle = 'Settings';
  static const String languageSettings = 'Language';
  static const String themeSettings = 'Theme';
  static const String notificationSettings = 'Notifications';
  static const String accountSettings = 'Account';
  static const String aboutApp = 'About SignIt';
  static const String privacyPolicy = 'Privacy Policy';
  static const String termsOfService = 'Terms of Service';
  
  // Error Messages
  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String errorNoInternet = 'No internet connection. Please check your connection and try again.';
  static const String errorNoCamera = 'Camera access denied. Please enable camera permissions in settings.';
  static const String errorNoGallery = 'Gallery access denied. Please enable storage permissions in settings.';
  static const String errorNoLocation = 'Location access denied. Please enable location permissions in settings.';
  static const String errorNoSignDetected = 'No sign language gestures detected. Please try again.';
}

class AppAssets {
  // Base paths
  static const String imagePath = 'assets/images/';
  static const String iconPath = 'assets/icons/';
  static const String animationPath = 'assets/animations/';
  static const String modelPath = 'assets/ml_models/';
  
  // Onboarding images
  static const String onboarding1 = '${imagePath}onboarding_1.png';
  static const String onboarding2 = '${imagePath}onboarding_2.png';
  static const String onboarding3 = '${imagePath}onboarding_3.png';
  
  // Logo
  static const String appLogo = '${imagePath}logo.png';
  static const String appLogoWhite = '${imagePath}logo_white.png';
  
  // Feature icons
  static const String cameraIcon = '${iconPath}camera_icon.svg';
  static const String imageIcon = '${iconPath}image_icon.svg';
  static const String videoIcon = '${iconPath}video_icon.svg';
  static const String mapIcon = '${iconPath}map_icon.svg';
  static const String historyIcon = '${iconPath}history_icon.svg';
  static const String settingsIcon = '${iconPath}settings_icon.svg';
  
  // Animations
  static const String loadingAnimation = '${animationPath}loading.json';
  static const String successAnimation = '${animationPath}success.json';
  static const String errorAnimation = '${animationPath}error.json';
  
  // ML Models
  static const String signLanguageModel = '${modelPath}sign_language_model.tflite';
  static const String signLanguageLabels = '${modelPath}sign_language_labels.txt';
}

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String camera = '/camera';
  static const String imageUpload = '/image-upload';
  static const String videoUpload = '/video-upload';
  static const String map = '/map';
  static const String results = '/results';
  static const String history = '/history';
  static const String settings = '/settings';
} 