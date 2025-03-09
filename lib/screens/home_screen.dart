import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_constants.dart';
import '../constants/app_theme.dart';
import '../providers/sign_interpreter_provider.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/feature_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            CustomSliverAppBar(
              title: AppStrings.appName,
              showBackButton: false,
              expandedHeight: 180,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: kToolbarHeight),
                      Text(
                        AppStrings.appTagline,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppStrings.homeTitle,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppColors.textPrimaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.9,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildListDelegate([
                  FeatureCard(
                    title: AppStrings.cameraOption,
                    iconPath: AppAssets.cameraIcon,
                    color: AppColors.primaryColor,
                    onTap: () => Navigator.pushNamed(context, AppRoutes.camera),
                  ),
                  FeatureCard(
                    title: AppStrings.imageOption,
                    iconPath: AppAssets.imageIcon,
                    color: AppColors.secondaryColor,
                    onTap: () => Navigator.pushNamed(context, AppRoutes.imageUpload),
                  ),
                  FeatureCard(
                    title: AppStrings.videoOption,
                    iconPath: AppAssets.videoIcon,
                    color: const Color(0xFFFF8A65),
                    onTap: () => Navigator.pushNamed(context, AppRoutes.videoUpload),
                  ),
                  FeatureCard(
                    title: AppStrings.mapOption,
                    iconPath: AppAssets.mapIcon,
                    color: const Color(0xFF4CAF50),
                    onTap: () => Navigator.pushNamed(context, AppRoutes.map),
                  ),
                  FeatureCard(
                    title: AppStrings.historyOption,
                    iconPath: AppAssets.historyIcon,
                    color: const Color(0xFF9C27B0),
                    onTap: () => Navigator.pushNamed(context, AppRoutes.history),
                  ),
                  FeatureCard(
                    title: AppStrings.settingsOption,
                    iconPath: AppAssets.settingsIcon,
                    color: const Color(0xFF607D8B),
                    onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 