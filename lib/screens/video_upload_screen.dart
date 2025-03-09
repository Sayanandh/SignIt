import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';

import '../constants/app_constants.dart';
import '../constants/app_theme.dart';
import '../providers/sign_interpreter_provider.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';

class VideoUploadScreen extends StatefulWidget {
  const VideoUploadScreen({super.key});

  @override
  State<VideoUploadScreen> createState() => _VideoUploadScreenState();
}

class _VideoUploadScreenState extends State<VideoUploadScreen> {
  File? _selectedVideo;
  bool _isProcessing = false;
  VideoPlayerController? _videoController;
  bool _isPlaying = false;

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _pickVideo(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedVideo = await picker.pickVideo(
        source: source,
        maxDuration: const Duration(seconds: 30),
      );

      if (pickedVideo != null) {
        _videoController?.dispose();
        
        final videoFile = File(pickedVideo.path);
        final controller = VideoPlayerController.file(videoFile);
        await controller.initialize();
        
        setState(() {
          _selectedVideo = videoFile;
          _videoController = controller;
          _isPlaying = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            source == ImageSource.camera
                ? AppStrings.errorNoCamera
                : AppStrings.errorNoGallery,
          ),
          backgroundColor: AppColors.errorColor,
        ),
      );
    }
  }

  Future<void> _processVideo() async {
    if (_selectedVideo == null) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final provider = Provider.of<SignInterpreterProvider>(context, listen: false);
      await provider.interpretVideo(_selectedVideo!);
      
      if (!mounted) return;
      
      Navigator.pushNamed(context, AppRoutes.results);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppStrings.errorGeneric),
          backgroundColor: AppColors.errorColor,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _togglePlayPause() {
    if (_videoController == null) return;
    
    setState(() {
      if (_videoController!.value.isPlaying) {
        _videoController!.pause();
        _isPlaying = false;
      } else {
        _videoController!.play();
        _isPlaying = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: AppStrings.videoUploadTitle,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppStrings.videoUploadInstructions,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Expanded(
                child: _selectedVideo == null
                    ? _buildPlaceholder()
                    : _buildVideoPreview(),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: AppStrings.recordVideo,
                      icon: Icons.videocam,
                      type: ButtonType.outline,
                      onPressed: () => _pickVideo(ImageSource.camera),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomButton(
                      text: AppStrings.selectVideo,
                      icon: Icons.video_library,
                      onPressed: () => _pickVideo(ImageSource.gallery),
                    ),
                  ),
                ],
              ),
              if (_selectedVideo != null) ...[
                const SizedBox(height: 16),
                CustomButton(
                  text: AppStrings.resultsTitle,
                  icon: Icons.translate,
                  isLoading: _isProcessing,
                  isFullWidth: true,
                  onPressed: _processVideo,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primaryLightColor.withOpacity(0.3),
          width: 2,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            AppAssets.loadingAnimation,
            width: 150,
            height: 150,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 20),
          Text(
            'Select or record a video of sign language gestures',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPreview() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AspectRatio(
              aspectRatio: _videoController!.value.aspectRatio,
              child: VideoPlayer(_videoController!),
            ),
            IconButton(
              onPressed: _togglePlayPause,
              icon: Icon(
                _isPlaying ? Icons.pause_circle : Icons.play_circle,
                size: 60,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 