import 'dart:io';
import 'package:flutter/foundation.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/sign_interpretation.dart';
import '../services/sign_interpreter_service.dart';

class SignInterpreterProvider with ChangeNotifier {
  final SignInterpreterService _service = SignInterpreterService();
  final List<SignInterpretation> _history = [];
  SignInterpretation? _currentInterpretation;
  bool _isLoading = false;
  bool _isInitialized = false;

  List<SignInterpretation> get history => _history;
  SignInterpretation? get currentInterpretation => _currentInterpretation;
  bool get isLoading => _isLoading;
  
  set currentInterpretation(SignInterpretation? interpretation) {
    _currentInterpretation = interpretation;
    notifyListeners();
  }

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    _setLoading(true);
    try {
      await _service.initialize();
      await _loadHistory();
      _isInitialized = true;
    } catch (e) {
      debugPrint('Error initializing sign interpreter provider: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> interpretImage(File imageFile) async {
    if (!_isInitialized) await initialize();
    
    _setLoading(true);
    try {
      final interpretation = await _service.interpretImage(imageFile);
      _currentInterpretation = interpretation;
      notifyListeners();
    } catch (e) {
      debugPrint('Error interpreting image: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> interpretVideo(File videoFile) async {
    if (!_isInitialized) await initialize();
    
    _setLoading(true);
    try {
      final interpretation = await _service.interpretVideo(videoFile);
      _currentInterpretation = interpretation;
      notifyListeners();
    } catch (e) {
      debugPrint('Error interpreting video: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> interpretLiveCamera(dynamic inputImage) async {
    if (!_isInitialized) await initialize();
    
    _setLoading(true);
    try {
      final interpretation = await _service.interpretLiveCamera(inputImage);
      _currentInterpretation = interpretation;
      notifyListeners();
    } catch (e) {
      debugPrint('Error interpreting live camera: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> saveToHistory(SignInterpretation interpretation) async {
    _history.insert(0, interpretation);
    await _saveHistory();
    notifyListeners();
  }

  Future<void> clearHistory() async {
    _history.clear();
    await _saveHistory();
    notifyListeners();
  }

  Future<void> removeFromHistory(String id) async {
    _history.removeWhere((item) => item.id == id);
    await _saveHistory();
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> _loadHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getStringList('sign_interpretation_history') ?? [];
      
      _history.clear();
      for (var json in historyJson) {
        try {
          final map = jsonDecode(json) as Map<String, dynamic>;
          _history.add(SignInterpretation.fromJson(map));
        } catch (e) {
          debugPrint('Error parsing history item: $e');
        }
      }
    } catch (e) {
      debugPrint('Error loading history: $e');
    }
  }

  Future<void> _saveHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = _history.map((item) => jsonEncode(item.toJson())).toList();
      await prefs.setStringList('sign_interpretation_history', historyJson);
    } catch (e) {
      debugPrint('Error saving history: $e');
    }
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }
} 