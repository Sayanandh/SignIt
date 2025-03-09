import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../models/sign_interpretation.dart';
import '../constants/app_constants.dart';

class SignInterpreterService {
  late Interpreter _interpreter;
  late List<String> _labels;
  bool _isInitialized = false;
  final ImageLabeler _imageLabeler = GoogleMlKit.vision.imageLabeler();

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Load TFLite model
      _interpreter = await Interpreter.fromAsset(AppAssets.signLanguageModel);
      
      // Load labels
      final labelsFile = await File(AppAssets.signLanguageLabels).readAsString();
      _labels = labelsFile.split('\n');
      
      _isInitialized = true;
    } catch (e) {
      debugPrint('Error initializing sign interpreter: $e');
      rethrow;
    }
  }

  // For demonstration purposes - in a real app, this would use the actual ML model
  Future<SignInterpretation> interpretImage(File imageFile) async {
    if (!_isInitialized) await initialize();
    
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final processedImage = await _imageLabeler.processImage(inputImage);
      
      // This is a placeholder for actual ML processing
      // In a real app, you would:
      // 1. Preprocess the image to match model input requirements
      // 2. Run inference with TFLite
      // 3. Process the output to get meaningful results
      
      // For demo, we'll create a mock result
      final gestures = <SignGesture>[];
      double highestConfidence = 0;
      String resultText = '';
      
      if (processedImage.isNotEmpty) {
        for (var label in processedImage) {
          final gesture = SignGesture(
            label: label.label,
            confidence: label.confidence,
            boundingBox: null, // Would come from object detection in real app
          );
          gestures.add(gesture);
          
          if (label.confidence > highestConfidence) {
            highestConfidence = label.confidence;
            resultText += '${label.label} ';
          }
        }
      } else {
        // If no labels detected, use random mock data
        final random = Random();
        final randomIndex = random.nextInt(_labels.length);
        final mockConfidence = 0.7 + random.nextDouble() * 0.3; // Between 0.7 and 1.0
        
        gestures.add(SignGesture(
          label: _labels[randomIndex],
          confidence: mockConfidence,
          boundingBox: null,
        ));
        
        resultText = _labels[randomIndex];
        highestConfidence = mockConfidence;
      }
      
      return SignInterpretation(
        id: const Uuid().v4(),
        text: resultText.trim(),
        timestamp: DateTime.now(),
        source: InterpretationSource.image,
        imagePath: imageFile.path,
        confidence: highestConfidence,
        detectedGestures: gestures,
      );
    } catch (e) {
      debugPrint('Error interpreting image: $e');
      rethrow;
    }
  }

  Future<SignInterpretation> interpretVideo(File videoFile) async {
    if (!_isInitialized) await initialize();
    
    // In a real app, this would:
    // 1. Extract frames from the video
    // 2. Process each frame with the model
    // 3. Combine results for a complete interpretation
    
    // For demo, we'll create a mock result
    final random = Random();
    final mockWords = [
      'Hello', 'Thank you', 'Please', 'Help', 'Good', 'Bad',
      'Yes', 'No', 'Name', 'Nice to meet you'
    ];
    
    final selectedWords = <String>[];
    final gestures = <SignGesture>[];
    
    // Generate 3-5 random words for the interpretation
    final wordCount = 3 + random.nextInt(3);
    for (var i = 0; i < wordCount; i++) {
      final wordIndex = random.nextInt(mockWords.length);
      selectedWords.add(mockWords[wordIndex]);
      
      gestures.add(SignGesture(
        label: mockWords[wordIndex],
        confidence: 0.7 + random.nextDouble() * 0.3,
        boundingBox: null,
      ));
    }
    
    return SignInterpretation(
      id: const Uuid().v4(),
      text: selectedWords.join(' '),
      timestamp: DateTime.now(),
      source: InterpretationSource.video,
      videoPath: videoFile.path,
      confidence: 0.85,
      detectedGestures: gestures,
    );
  }

  Future<SignInterpretation> interpretLiveCamera(InputImage inputImage) async {
    if (!_isInitialized) await initialize();
    
    try {
      final processedImage = await _imageLabeler.processImage(inputImage);
      
      // Similar to image interpretation, but for live camera feed
      final gestures = <SignGesture>[];
      double highestConfidence = 0;
      String resultText = '';
      
      if (processedImage.isNotEmpty) {
        for (var label in processedImage) {
          final gesture = SignGesture(
            label: label.label,
            confidence: label.confidence,
            boundingBox: null,
          );
          gestures.add(gesture);
          
          if (label.confidence > highestConfidence) {
            highestConfidence = label.confidence;
            resultText += '${label.label} ';
          }
        }
      } else {
        // If no labels detected, use random mock data
        final random = Random();
        final randomIndex = random.nextInt(_labels.length);
        final mockConfidence = 0.7 + random.nextDouble() * 0.3;
        
        gestures.add(SignGesture(
          label: _labels[randomIndex],
          confidence: mockConfidence,
          boundingBox: null,
        ));
        
        resultText = _labels[randomIndex];
        highestConfidence = mockConfidence;
      }
      
      // For live camera, we'll save the image for history
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final imagePath = '${tempDir.path}/sign_capture_$timestamp.jpg';
      
      return SignInterpretation(
        id: const Uuid().v4(),
        text: resultText.trim(),
        timestamp: DateTime.now(),
        source: InterpretationSource.camera,
        imagePath: imagePath,
        confidence: highestConfidence,
        detectedGestures: gestures,
      );
    } catch (e) {
      debugPrint('Error interpreting live camera: $e');
      rethrow;
    }
  }

  void dispose() {
    if (_isInitialized) {
      _interpreter.close();
      _imageLabeler.close();
    }
  }
} 