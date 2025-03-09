import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../constants/app_theme.dart';

class FeatureCard extends StatelessWidget {
  final String title;
  final String iconPath;
  final Color? color;
  final VoidCallback onTap;
  final IconData fallbackIcon;

  const FeatureCard({
    super.key,
    required this.title,
    required this.iconPath,
    this.color,
    required this.onTap,
    this.fallbackIcon = Icons.star,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = color ?? AppColors.primaryColor;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: cardColor.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              splashColor: cardColor.withOpacity(0.1),
              highlightColor: cardColor.withOpacity(0.05),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: cardColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          fallbackIcon,
                          size: 24,
                          color: cardColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      title,
                      style: TextStyle(
                        color: AppColors.textPrimaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      )
      .animate()
      .fadeIn(duration: const Duration(milliseconds: 300))
      .slideY(
        begin: 0.1,
        end: 0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      ),
    );
  }
  
  Widget _buildIcon(Color cardColor) {
    try {
      return SvgPicture.asset(
        iconPath,
        width: 28,
        height: 28,
        colorFilter: ColorFilter.mode(
          cardColor,
          BlendMode.srcIn,
        ),
        placeholderBuilder: (context) => Icon(
          fallbackIcon,
          size: 28,
          color: cardColor,
        ),
      );
    } catch (e) {
      // Fallback to icon if SVG loading fails
      return Icon(
        _getIconForTitle(),
        size: 28,
        color: cardColor,
      );
    }
  }
  
  IconData _getIconForTitle() {
    switch (title.toLowerCase()) {
      case 'live camera':
        return Icons.camera_alt;
      case 'upload image':
        return Icons.image;
      case 'upload video':
        return Icons.videocam;
      case 'history':
        return Icons.history;
      case 'settings':
        return Icons.settings;
      default:
        return fallbackIcon;
    }
  }
} 