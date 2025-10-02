import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../../../../config/theme/theme_provider.dart';
class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool pushNotifications = false;
  bool locationSharing = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // Sozlamalarni yuklash
  Future<void> _loadSettings() async {
    // Notification permission holatini tekshirish
    final notifStatus = await Permission.notification.status;

    // Location permission holatini tekshirish
    final locationStatus = await Permission.location.status;

    if (mounted) {
      setState(() {
        pushNotifications = notifStatus.isGranted;
        locationSharing = locationStatus.isGranted;
        isLoading = false;
      });
    }
  }

  // Notification permission so'rash
  Future<void> _toggleNotifications(bool value) async {
    if (value) {
      // Permission so'rash
      final status = await Permission.notification.request();

      if (mounted) {
        setState(() {
          pushNotifications = status.isGranted;
        });
      }

      if (status.isPermanentlyDenied) {
        _showSettingsDialog(
          'Bildirishnomalar',
          'Bildirishnomalarni yoqish uchun sozlamalarga o\'ting',
        );
      }
    } else {
      // O'chirish uchun sozlamalarga olib borish
      _showSettingsDialog(
        'Bildirishnomalarni o\'chirish',
        'Bildirishnomalarni butunlay o\'chirish uchun sozlamalarga o\'ting',
      );
    }
  }

  // Location permission so'rash
  Future<void> _toggleLocation(bool value) async {
    if (value) {
      // Avval location service yoqilganligini tekshirish
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        _showLocationServiceDialog();
        return;
      }

      // Permission so'rash
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (mounted) {
        setState(() {
          locationSharing = (permission == LocationPermission.whileInUse ||
              permission == LocationPermission.always);
        });
      }

      if (permission == LocationPermission.deniedForever) {
        _showSettingsDialog(
          'Joylashuv',
          'Joylashuvni yoqish uchun sozlamalarga o\'ting',
        );
      } else if (locationSharing) {
        // Joriy joylashuvni olish (test uchun)
        try {
          Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          );
          print('Lat: ${position.latitude}, Lon: ${position.longitude}');
        } catch (e) {
          print('Location error: $e');
        }
      }
    } else {
      if (mounted) {
        setState(() {
          locationSharing = false;
        });
      }
    }
  }

  // Location service o'chirilgan dialog
  void _showLocationServiceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Joylashuv xizmati o\'chirilgan'),
        content: const Text('Joylashuv xizmatini yoqish uchun sozlamalarga o\'ting'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Bekor qilish'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Geolocator.openLocationSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C5CE7),
              foregroundColor: Colors.white,
            ),
            child: const Text('Sozlamalarga o\'tish'),
          ),
        ],
      ),
    );
  }

  // Sozlamalarga yo'naltirish dialogi
  void _showSettingsDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Bekor qilish'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C5CE7),
              foregroundColor: Colors.white,
            ),
            child: const Text('Sozlamalarga o\'tish'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    if (isLoading) {
      return Scaffold(
        backgroundColor: isDark ? Color(0xFF1A1A1A) : Color(0xFFF5F5F5),
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF6C5CE7),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF5F5F5),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDark ? Colors.white : Colors.black,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Notifications Section
            _buildSectionTitle('Notifications', isDark),
            const SizedBox(height: 8),
            _buildToggleItem(
              icon: Icons.notifications_outlined,
              title: 'Push Notifications',
              value: pushNotifications,
              onChanged: _toggleNotifications,
              isDark: isDark,
            ),

            const SizedBox(height: 24),

            // Privacy Section
            _buildSectionTitle('Privacy', isDark),
            const SizedBox(height: 8),
            _buildToggleItem(
              icon: Icons.location_on_outlined,
              title: 'Location Sharing',
              value: locationSharing,
              onChanged: _toggleLocation,
              isDark: isDark,
            ),
            _buildNavigationItem(
              icon: Icons.shield_outlined,
              title: 'Privacy Policy',
              onTap: () {
                // Privacy Policy sahifasiga o'tish
                print('Privacy Policy tapped');
              },
              isDark: isDark,
            ),

            const SizedBox(height: 24),

            // Appearance Section
            _buildSectionTitle('Appearance', isDark),
            const SizedBox(height: 8),
            _buildToggleItem(
              icon: Icons.dark_mode_outlined,
              title: 'Dark Mode',
              value: isDark,
              onChanged: (value) {
                themeProvider.toggleTheme();
              },
              isDark: isDark,
            ),
            _buildNavigationItem(
              icon: Icons.language_outlined,
              title: 'Language',
              onTap: () {
                // Language sahifasiga o'tish
                print('Language tapped');
              },
              isDark: isDark,
            ),
            _buildNavigationItem(
              icon: Icons.attach_money,
              title: 'Currency',
              onTap: () {
                // Currency sahifasiga o'tish
                print('Currency tapped');
              },
              isDark: isDark,
            ),

            const SizedBox(height: 24),

            // Support Section
            _buildSectionTitle('Support', isDark),
            const SizedBox(height: 8),
            _buildNavigationItem(
              icon: Icons.help_outline,
              title: 'Help Center',
              onTap: () {
                // Help Center sahifasiga o'tish
                print('Help Center tapped');
              },
              isDark: isDark,
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _buildToggleItem({
    required IconData icon,
    required String title,
    required bool value,
    required Function(bool) onChanged,
    required bool isDark,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
            size: 22,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15,
                color: isDark ? Colors.grey[300] : Colors.grey[700],
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Transform.scale(
            scale: 0.85,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.white,
              activeTrackColor: const Color(0xFF6C5CE7),
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: isDark ? Colors.grey[700] : Colors.grey[300],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              size: 22,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  color: isDark ? Colors.grey[300] : Colors.grey[700],
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: isDark ? Colors.grey[600] : Colors.grey[400],
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}