import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/app_theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;
  final Widget? leading;
  final double elevation;
  final Color? backgroundColor;
  final bool centerTitle;
  final double height;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.actions,
    this.leading,
    this.elevation = 0,
    this.backgroundColor,
    this.centerTitle = true,
    this.height = kToolbarHeight + 16,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          color: AppColors.textPrimaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? AppColors.backgroundColor,
      elevation: elevation,
      automaticallyImplyLeading: showBackButton,
      leading: !showBackButton
          ? null
          : leading ??
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: AppColors.primaryColor,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
      actions: actions,
      toolbarHeight: height,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class CustomSliverAppBar extends StatelessWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;
  final Widget? leading;
  final double expandedHeight;
  final Widget? flexibleSpace;
  final Color? backgroundColor;
  final bool centerTitle;
  final bool pinned;
  final bool floating;

  const CustomSliverAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.actions,
    this.leading,
    this.expandedHeight = 200,
    this.flexibleSpace,
    this.backgroundColor,
    this.centerTitle = true,
    this.pinned = true,
    this.floating = false,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(
        title,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          color: AppColors.textPrimaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? AppColors.backgroundColor,
      elevation: 0,
      automaticallyImplyLeading: showBackButton,
      leading: !showBackButton
          ? null
          : leading ??
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: AppColors.primaryColor,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
      actions: actions,
      expandedHeight: expandedHeight,
      flexibleSpace: flexibleSpace,
      pinned: pinned,
      floating: floating,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
    );
  }
} 