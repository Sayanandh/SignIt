import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constants/app_constants.dart';
import '../constants/app_theme.dart';
import '../providers/sign_interpreter_provider.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with WidgetsBindingObserver {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool _isProcessing = false;
  bool _isFrontCamera = true;
  int _cameraIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    final status = await Permission.camera.request();
    if (status != PermissionStatus.granted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppStrings.errorNoCamera),
            backgroundColor: AppColors.errorColor,
          ),
        );
      }
      return;
    }

    _cameras = await availableCameras();
    if (_cameras == null || _cameras!.isEmpty) {
      return;
    }

    // Start with front camera
    _cameraIndex = _cameras!.indexWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
    );
    if (_cameraIndex == -1) {
      _cameraIndex = 0; // Default to first camera if front camera not found
    }

    await _setupCamera();
  }

  Future<void> _setupCamera() async {
    if (_cameras == null || _cameras!.isEmpty) return;

    if (_cameraController != null) {
      await _cameraController!.dispose();
    }

    _cameraController = CameraController(
      _cameras![_cameraIndex],
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    try {
      await _cameraController!.initialize();
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
          _isFrontCamera = _cameras![_cameraIndex].lensDirection == CameraLensDirection.front;
        });
      }
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  Future<void> _switchCamera() async {
    if (_cameras == null || _cameras!.length <= 1) return;

    _cameraIndex = (_cameraIndex + 1) % _cameras!.length;
    await _setupCamera();
  }

  Future<void> _captureAndProcess() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final imageFile = await _cameraController!.takePicture();
      final inputImage = InputImage.fromFilePath(imageFile.path);
      
      final provider = Provider.of<SignInterpreterProvider>(context, listen: false);
      await provider.interpretLiveCamera(inputImage);
      
      if (!mounted) return;
      
      Navigator.pushNamed(context, AppRoutes.results);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppStrings.errorGeneric),
            backgroundColor: AppColors.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(
        title: AppStrings.cameraTitle,
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _isCameraInitialized
                  ? _buildCameraPreview()
                  : _buildLoadingIndicator(),
            ),
            _buildBottomControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraPreview() {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    final scale = 1 / (_cameraController!.value.aspectRatio * deviceRatio);

    return Stack(
      alignment: Alignment.center,
      children: [
        Transform.scale(
          scale: scale,
          child: Center(
            child: CameraPreview(_cameraController!),
          ),
        ),
        Positioned(
          top: 20,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                AppStrings.cameraInstructions,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        if (_isProcessing)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.primaryColor,
      ),
    );
  }

  Widget _buildBottomControls() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: _switchCamera,
            icon: const Icon(
              Icons.flip_camera_ios,
              color: Colors.white,
              size: 30,
            ),
          ),
          GestureDetector(
            onTap: _captureAndProcess,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
              ),
              child: Center(
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 30), // For balance
        ],
      ),
    );
  }
} 