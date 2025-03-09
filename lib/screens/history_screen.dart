import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

import '../constants/app_constants.dart';
import '../constants/app_theme.dart';
import '../models/sign_interpretation.dart';
import '../providers/sign_interpreter_provider.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: AppStrings.historyOption,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _showClearHistoryDialog(context),
          ),
        ],
      ),
      body: Consumer<SignInterpreterProvider>(
        builder: (context, provider, child) {
          if (provider.history.isEmpty) {
            return _buildEmptyState();
          }
          
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.history.length,
            itemBuilder: (context, index) {
              final interpretation = provider.history[index];
              return _buildHistoryItem(context, interpretation, index);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 80,
            color: AppColors.textLightColor,
          ),
          const SizedBox(height: 16),
          Text(
            'No interpretation history yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your sign language interpretations will appear here',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textLightColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(BuildContext context, SignInterpretation interpretation, int index) {
    final dateFormat = DateFormat('MMM d, yyyy • h:mm a');
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: InkWell(
        onTap: () => _showInterpretationDetails(context, interpretation),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _getSourceIcon(interpretation.source),
                    color: AppColors.primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _getSourceText(interpretation.source),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondaryColor,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    dateFormat.format(interpretation.timestamp),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textLightColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                interpretation.text,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.textPrimaryColor,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLightColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${(interpretation.confidence * 100).toStringAsFixed(0)}% Confidence',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: AppColors.errorColor,
                      size: 20,
                    ),
                    onPressed: () => _deleteHistoryItem(context, interpretation.id),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              if (interpretation.imagePath != null) ...[
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(interpretation.imagePath!),
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 120,
                        width: double.infinity,
                        color: AppColors.surfaceColor,
                        child: const Center(
                          child: Icon(
                            Icons.broken_image,
                            color: AppColors.textLightColor,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: const Duration(milliseconds: 300)).slideY(
          begin: 0.1,
          end: 0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          delay: Duration(milliseconds: index * 50),
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

  void _showInterpretationDetails(BuildContext context, SignInterpretation interpretation) {
    final provider = Provider.of<SignInterpreterProvider>(context, listen: false);
    provider.currentInterpretation = interpretation;
    Navigator.pushNamed(context, AppRoutes.results);
  }

  void _deleteHistoryItem(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: const Text('Are you sure you want to delete this interpretation?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final provider = Provider.of<SignInterpreterProvider>(context, listen: false);
              provider.removeFromHistory(id);
              Navigator.pop(context);
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Item deleted'),
                  backgroundColor: AppColors.successColor,
                ),
              );
            },
            child: const Text('Delete'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.errorColor,
            ),
          ),
        ],
      ),
    );
  }

  void _showClearHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear History'),
        content: const Text('Are you sure you want to clear all interpretation history?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final provider = Provider.of<SignInterpreterProvider>(context, listen: false);
              provider.clearHistory();
              Navigator.pop(context);
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('History cleared'),
                  backgroundColor: AppColors.successColor,
                ),
              );
            },
            child: const Text('Clear'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.errorColor,
            ),
          ),
        ],
      ),
    );
  }
} 