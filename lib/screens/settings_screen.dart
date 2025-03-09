import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../constants/app_constants.dart';
import '../constants/app_theme.dart';
import '../widgets/custom_app_bar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _appVersion = '';
  bool _isDarkMode = false;
  bool _isNotificationsEnabled = true;
  String _selectedLanguage = 'English';

  @override
  void initState() {
    super.initState();
    _loadAppInfo();
  }

  Future<void> _loadAppInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _appVersion = '${packageInfo.version} (${packageInfo.buildNumber})';
      });
    } catch (e) {
      debugPrint('Error loading app info: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: AppStrings.settingsTitle,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader('Appearance'),
          _buildSettingItem(
            icon: Icons.dark_mode,
            title: AppStrings.themeSettings,
            subtitle: _isDarkMode ? 'Dark Mode' : 'Light Mode',
            trailing: Switch(
              value: _isDarkMode,
              onChanged: (value) {
                setState(() {
                  _isDarkMode = value;
                });
                // TODO: Implement theme switching
              },
              activeColor: AppColors.primaryColor,
            ),
          ),
          _buildSettingItem(
            icon: Icons.language,
            title: AppStrings.languageSettings,
            subtitle: _selectedLanguage,
            onTap: _showLanguageDialog,
          ),
          const Divider(),
          _buildSectionHeader('Notifications'),
          _buildSettingItem(
            icon: Icons.notifications,
            title: AppStrings.notificationSettings,
            subtitle: _isNotificationsEnabled ? 'Enabled' : 'Disabled',
            trailing: Switch(
              value: _isNotificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _isNotificationsEnabled = value;
                });
                // TODO: Implement notification settings
              },
              activeColor: AppColors.primaryColor,
            ),
          ),
          const Divider(),
          _buildSectionHeader('Account'),
          _buildSettingItem(
            icon: Icons.person,
            title: AppStrings.accountSettings,
            subtitle: 'Manage your account',
            onTap: () {
              // TODO: Implement account settings
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Account settings not implemented yet'),
                ),
              );
            },
          ),
          const Divider(),
          _buildSectionHeader('About'),
          _buildSettingItem(
            icon: Icons.info,
            title: AppStrings.aboutApp,
            subtitle: 'Version $_appVersion',
            onTap: _showAboutDialog,
          ),
          _buildSettingItem(
            icon: Icons.privacy_tip,
            title: AppStrings.privacyPolicy,
            onTap: () {
              // TODO: Implement privacy policy
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Privacy policy not implemented yet'),
                ),
              );
            },
          ),
          _buildSettingItem(
            icon: Icons.description,
            title: AppStrings.termsOfService,
            onTap: () {
              // TODO: Implement terms of service
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Terms of service not implemented yet'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8, left: 16),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppColors.primaryColor,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: AppColors.textPrimaryColor,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondaryColor,
              ),
            )
          : null,
      trailing: trailing ??
          (onTap != null
              ? const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.textLightColor,
                )
              : null),
      onTap: onTap,
    );
  }

  void _showLanguageDialog() {
    final languages = ['English', 'Spanish', 'French', 'German', 'Chinese'];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: languages.length,
            itemBuilder: (context, index) {
              final language = languages[index];
              return RadioListTile<String>(
                title: Text(language),
                value: language,
                groupValue: _selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value!;
                  });
                  Navigator.pop(context);
                  // TODO: Implement language switching
                },
                activeColor: AppColors.primaryColor,
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AboutDialog(
        applicationName: AppStrings.appName,
        applicationVersion: _appVersion,
        applicationIcon: Image.asset(
          AppAssets.appLogo,
          width: 50,
          height: 50,
        ),
        applicationLegalese: '© 2023 SignIt Team',
        children: [
          const SizedBox(height: 16),
          Text(
            AppStrings.appTagline,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'SignIt is a modern sign language interpretation system designed to bridge communication gaps between the deaf and hearing communities.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
} 