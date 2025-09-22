import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:housell/core/dp/dp_injection.dart';

import '../../../../../config/service/local_service.dart';
import '../../../../../core/dio/dio_client.dart';

// 8. Splash Screen - Go Router bilan

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkTokenAndNavigate();
  }

  Future<void> _checkTokenAndNavigate() async {
    // Kichik loading uchun
    await Future.delayed(Duration(seconds: 2));

    try {
      final storage = GetIt.I<SecureStorageService>();

      // Tokenlar mavjudligini tekshirish
      final token = await storage.getToken();

      if (mounted) {
        // Widget hali ham mavjudligini tekshirish
        if (token != null && token.isNotEmpty) {
          print('Tokenlar mavjud - Home sahifasiga yo\'naltirish');
          context.go('/home');
        } else {
          print('Tokenlar mavjud emas - Login sahifasiga yo\'naltirish');
          context.go('/login');
        }
      }
    } catch (e) {
      print('Splash screen xatosi: $e');
      // Xato bo'lsa login sahifasiga
      if (mounted) {
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo yoki nomi
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(Icons.mobile_friendly, size: 80, color: Colors.blue),
            ),

            SizedBox(height: 30),

            Text(
              'MyApp',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                letterSpacing: 1.2,
              ),
            ),

            SizedBox(height: 10),

            Text(
              'Yuklanmoqda...',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),

            SizedBox(height: 40),

            // Loading indicator
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              strokeWidth: 3.0,
            ),
          ],
        ),
      ),
    );
  }
}
