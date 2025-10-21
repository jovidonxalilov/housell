import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:housell/config/theme/app_colors.dart';
import 'package:housell/core/extensions/widget_extension.dart';
import 'package:housell/core/widgets/w_custom_app_bar.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/widgets/app_image.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/w__container.dart';
import '../../../../../core/widgets/w_langue_selector.dart';

import 'package:flutter/material.dart';

// Settings Provider
class SettingsProvider extends ChangeNotifier {
  bool _pushNotifications = true;
  bool _locationSharing = true;

  bool get pushNotifications => _pushNotifications;
  bool get locationSharing => _locationSharing;

  void togglePushNotifications(bool value) {
    _pushNotifications = value;
    notifyListeners();
  }

  void toggleLocationSharing(bool value) {
    _locationSharing = value;
    notifyListeners();
  }
}

// Settings Page
class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final SettingsProvider settings = SettingsProvider();

  void _showLanguageBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (modalContext) => ContainerW(
        color: AppColors.backgroundP,
        height: 250.h,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Divider(
              thickness: 4,
              indent: 54,
              endIndent: 54,
              color: AppColors.skyBase,
            ),
            SizedBox(height: 20.h),
            WLanguageSelector(
              initialLanguageCode: context.locale.languageCode,
              onLanguageChanged: (Locale locale) {
                Navigator.pop(modalContext);
              },
            ),
          ],
        ).paddingOnly(left: 110, right: 110, top: 8),
      ),
    );
  }
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: AppText(
          text: 'login',
          fontSize: 18,
          fontWeight: 600,
          color: Colors.black,
        ),
        content: const AppText(
          text: 'Are you sure you want to logout?',
          fontSize: 16,
          color: Colors.black87,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const AppText(text: 'Cancel', color: Colors.blue),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Logout logic bu yerda
            },
            child: const AppText(text: 'Logout', color: Colors.red),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: AppText(
          text: 'Delete Account',
          fontSize: 18,
          fontWeight: 600,
          color: Colors.black,
        ),
        content: const AppText(
          text:
          'Are you sure you want to delete your account? This action cannot be undone.',
          fontSize: 16,
          color: Colors.black87,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const AppText(text: 'Cancel', color: Colors.blue),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Delete account logic bu yerda
            },
            child: const AppText(text: 'Delete', color: Colors.red),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: settings,
      builder: (context, _) {
        return Scaffold(
          extendBodyBehindAppBar: false,
          backgroundColor: AppColors.backgroundP,
          appBar: WCustomAppBar(
            title: AppText(
              text: "settings",
              fontSize: 18,
              fontWeight: 400,
              color: AppColors.lightIcon,
            ),
            leading: AppImage(
              path: AppAssets.arrowChevronLeft,
              onTap: () => context.pop(),
              size: 24,
            ),
            showLeadingAutomatically: true,
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Notifications Section
              _buildSectionHeader('Notifications'),
              const SizedBox(height: 8),
              ContainerW(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                // padding: const EdgeInsets.all(16),
                child: _buildSwitchTile(
                  icon: Icons.notifications_outlined,
                  title: 'Push Notifications',
                  value: settings.pushNotifications,
                  onChanged: (value) {
                    setState(() {
                      settings.togglePushNotifications(value);
                    });
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Privacy Section
              _buildSectionHeader('Privacy'),
              const SizedBox(height: 8),
              ContainerW(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: _buildSwitchTile(
                        icon: Icons.location_on_outlined,
                        title: 'Location Sharing',
                        value: settings.locationSharing,
                        onChanged: (value) {
                          setState(() {
                            settings.toggleLocationSharing(value);
                          });
                        },
                      ),
                    ),
                    const Divider(height: 1, color: Colors.black12),
                    _buildNavigationTile(
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy Policy',
                      onTap: () {
                        // Privacy Policy sahifasiga o'tish
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Appearance Section
              _buildSectionHeader('Appearance'),
              const SizedBox(height: 8),
              ContainerW(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  children: [
                    _buildNavigationTile(
                      icon: Icons.language_outlined,
                      title: 'Language',
                      onTap: _showLanguageBottomSheet,
                    ),
                    const Divider(height: 1, color: Colors.black12),
                    _buildNavigationTile(
                      icon: Icons.currency_exchange_outlined,
                      title: 'Currency',
                      onTap: () {
                        // Currency sahifasiga o'tish
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Support Section
              _buildSectionHeader('Support'),
              const SizedBox(height: 8),
              ContainerW(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  children: [
                    _buildNavigationTile(
                      icon: Icons.help_outline,
                      title: 'Help Center',
                      onTap: () {
                        // Help Center sahifasiga o'tish
                      },
                    ),
                    const Divider(height: 1, color: Colors.black12),
                    _buildNavigationTile(
                      icon: Icons.support_agent_outlined,
                      title: 'Contact Support',
                      onTap: () {
                        // Contact Support sahifasiga o'tish
                      },
                    ),
                    const Divider(height: 1, color: Colors.black12),
                    _buildNavigationTile(
                      icon: Icons.star_outline,
                      title: 'Rate App',
                      onTap: () {
                        // App Store/Play Store ga o'tish
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Logout Button
              InkWell(
                onTap: _showLogoutDialog,
                child: ContainerW(
                  color: const Color(0xFFFFE5E5),
                  borderRadius: BorderRadius.circular(12),
                  // padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, color: Colors.red[400], size: 20),
                      const SizedBox(width: 8),
                      AppText(
                        text: 'Logout',
                        fontSize: 16,
                        fontWeight: 600,
                        color: Colors.red[400],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Delete Account Button
              InkWell(
                onTap: _showDeleteAccountDialog,
                child: ContainerW(
                  color: const Color(0xFFFFE5E5),
                  borderRadius: BorderRadius.circular(12),
                  // padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.delete_outline,
                          color: Colors.red[400], size: 20),
                      const SizedBox(width: 8),
                      AppText(
                        text: 'Delete Account',
                        fontSize: 16,
                        fontWeight: 600,
                        color: Colors.red[400],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: AppText(
        text: title,
        fontSize: 13,
        fontWeight: 600,
        color: Colors.black54,
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.black54, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: AppText(
            text: title,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.blue,
        ),
      ],
    );
  }

  Widget _buildNavigationTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: Colors.black54, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: AppText(
                text: title,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            if (subtitle != null) ...[
              AppText(
                text: subtitle,
                fontSize: 14,
                color: Colors.black54,
              ),
              const SizedBox(width: 4),
            ],
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.black26,
            ),
          ],
        ),
      ),
    );
  }
}
