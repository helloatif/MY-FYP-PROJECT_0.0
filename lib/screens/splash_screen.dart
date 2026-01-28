import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    // Show native splash for 500ms only (fast)
    await Future.delayed(const Duration(milliseconds: 500), () {});

    if (!mounted) return;

    try {
      // Firebase is already initialized in main(), safe to use now
      final user = FirebaseAuth.instance.currentUser;
      print('🔍 Splash: Checking user... user=$user');

      if (user != null) {
        // Reload user to get latest verification status (fast check)
        await user.reload();
        final refreshedUser = FirebaseAuth.instance.currentUser;
        print(
          '🔍 Splash: Refreshed user, emailVerified=${refreshedUser?.emailVerified}',
        );

        if (refreshedUser != null && refreshedUser.emailVerified) {
          // User is verified - check if language was already selected
          final prefs = await SharedPreferences.getInstance();
          final languageSelected =
              prefs.getBool('languageSelected_${refreshedUser.uid}') ?? false;
          print('🔍 Splash: Language selected=$languageSelected');

          if (languageSelected) {
            // Language was already selected before - go straight to home
            print('✅ Splash: Navigating to /home');
            if (mounted) Navigator.of(context).pushReplacementNamed('/home');
          } else {
            // First time login - show language selection
            print('✅ Splash: Navigating to /language-selection');
            if (mounted)
              Navigator.of(context).pushReplacementNamed('/language-selection');
          }
        } else if (refreshedUser != null && !refreshedUser.emailVerified) {
          // User exists but NOT verified - send to verification screen
          print(
            '✅ Splash: User not verified, navigating to /email-verification',
          );
          if (mounted)
            Navigator.of(context).pushReplacementNamed('/email-verification');
        } else {
          // No user - go to login
          print('✅ Splash: No user logged in, navigating to /login');
          if (mounted) Navigator.of(context).pushReplacementNamed('/login');
        }
      } else {
        // No user logged in - go to login screen
        print('✅ Splash: No user, navigating to /login');
        if (mounted) Navigator.of(context).pushReplacementNamed('/login');
      }
    } catch (e) {
      print('❌ Splash Error: $e');
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }

    // Safety timeout - if navigation hasn't happened after 3 seconds, force go to login
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        print('⚠️ Splash: Navigation timeout, forcing /login');
        Navigator.of(context).pushReplacementNamed('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show loading screen while checking auth state and navigating
    // Native splash was already shown for 500ms before this
    return Scaffold(
      backgroundColor: const Color(0xFF4CAF50), // Primary green
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 3,
            ),
            const SizedBox(height: 24),
            Text(
              'Loading...',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
