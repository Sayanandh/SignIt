import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:share_plus/share_plus.dart';
import 'package:image_picker/image_picker.dart';

import '../constants/app_constants.dart';
import '../constants/app_theme.dart';
import '../models/sign_interpretation.dart';
import '../providers/sign_interpreter_provider.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  bool _isSaving = false;
  bool _isSaved = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SignInterpreterProvider>(context);
    final interpretation = provider.currentInterpretation;

    if (interpretation == null) {
      // If no interpretation is available, navigate back
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop();
      });
      return const SizedBox.shrink();
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: AppStrings.resultsTitle,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildResultCard(interpretation),
              const SizedBox(height: 20),
              _buildActionButtons(interpretation),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard(SignInterpretation interpretation) {
    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _getSourceIcon(interpretation.source),
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _getSourceText(interpretation.source),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondaryColor,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLightColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${(interpretation.confidence * 100).toStringAsFixed(0)}% Confidence',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Interpretation:',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.textPrimaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        interpretation.text,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppColors.textPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (interpretation.detectedGestures != null &&
                          interpretation.detectedGestures!.isNotEmpty) ...[
                        Text(
                          'Detected Gestures:',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.textPrimaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...interpretation.detectedGestures!.map(
                          (gesture) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    gesture.label,
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ),
                                Text(
                                  '${(gesture.confidence * 100).toStringAsFixed(0)}%',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textSecondaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      if (interpretation.imagePath != null) ...[
                        Text(
                          'Source Image:',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.textPrimaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(interpretation.imagePath!),
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ).animate().fadeIn(duration: const Duration(milliseconds: 300)).slideY(
            begin: 0.1,
            end: 0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          ),
    );
  }

  Widget _buildActionButtons(SignInterpretation interpretation) {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            text: AppStrings.copyText,
            icon: Icons.copy,
            type: ButtonType.outline,
            onPressed: () => _copyToClipboard(interpretation.text),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: CustomButton(
            text: AppStrings.shareText,
            icon: Icons.share,
            type: ButtonType.outline,
            onPressed: () => _shareInterpretation(interpretation),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: CustomButton(
            text: _isSaved ? 'Saved' : AppStrings.saveToHistory,
            icon: _isSaved ? Icons.check : Icons.save,
            isLoading: _isSaving,
            onPressed: _isSaved ? () {} : () => _saveToHistory(interpretation),
          ),
        ),
      ],
    );
  }

  IconData _getSourceIcon(InterpretationSource source) {
    switch (source) {
      case InterpretationSource.camera:
        return Icons.camera_alt;
      case InterpretationSource.image:
        return Icons.image;
      case InterpretationSource.video:
        return Icons.videocam;
    }
  }

  String _getSourceText(InterpretationSource source) {
    switch (source) {
      case InterpretationSource.camera:
        return 'Live Camera';
      case InterpretationSource.image:
        return 'Image Upload';
      case InterpretationSource.video:
        return 'Video Upload';
    }
  }

  Future<void> _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Text copied to clipboard'),
        backgroundColor: AppColors.successColor,
      ),
    );
  }

  Future<void> _shareInterpretation(SignInterpretation interpretation) async {
    final text = 'Sign Language Interpretation: ${interpretation.text}';
    
    if (interpretation.imagePath != null) {
      await Share.shareXFiles(
        [XFile(interpretation.imagePath!)],
        text: text,
      );
    } else {
      await Share.share(text);
    }
  }

  Future<void> _saveToHistory(SignInterpretation interpretation) async {
    setState(() {
      _isSaving = true;
    });
    
    try {
      final provider = Provider.of<SignInterpreterProvider>(context, listen: false);
      await provider.saveToHistory(interpretation);
      
      if (!mounted) return;
      
      setState(() {
        _isSaving = false;
        _isSaved = true;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Saved to history'),
          backgroundColor: AppColors.successColor,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        _isSaving = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save to history'),
          backgroundColor: AppColors.errorColor,
        ),
      );
    }
  }
} 