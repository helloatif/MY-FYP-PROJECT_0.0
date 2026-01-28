import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'firebase_options.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/auth/email_verification_screen.dart';
import 'screens/home_screen.dart';
import 'screens/learning/ai_assistant_screen.dart';
import 'screens/learning/language_selection_screen.dart';
import 'providers/user_provider.dart';
import 'providers/learning_provider.dart';
import 'providers/gamification_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/adaptive_learning_provider.dart';
import 'services/adaptive_quiz_service.dart';
import 'themes/app_theme.dart';

// Global flag for language selection
const String _languageSelectedKey = 'language_selected_flag';

// Global variable to store initial theme preference
bool _initialDarkMode = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load theme preference BEFORE app starts (prevents flicker)
  try {
    final prefs = await SharedPreferences.getInstance();
    _initialDarkMode = prefs.getBool('isDarkMode') ?? false;
    print('✓ Theme preference loaded: isDarkMode=$_initialDarkMode');
  } catch (e) {
    print('⚠ Could not load theme preference: $e');
  }

  // Initialize Firebase and WAIT for it to complete
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Set Firebase Auth persistence to LOCAL for web
    // Mobile (Android/iOS) uses LOCAL persistence by default
    if (kIsWeb) {
      await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
    }
    print('✓ Firebase initialized successfully - users will stay logged in');
  } catch (e) {
    print('✗ Firebase initialization error: $e');
  }

  // Start app after Firebase is ready
  runApp(const MyApp());
}

// Helper function to determine initial screen based on auth state
Future<Widget> _determineInitialScreen() async {
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    await user.reload();
    final refreshedUser = FirebaseAuth.instance.currentUser;

    if (refreshedUser != null && refreshedUser.emailVerified) {
      // First check SharedPreferences (fastest, local)
      try {
        final prefs = await SharedPreferences.getInstance();
        final localFlag = prefs.getString(
          '${_languageSelectedKey}_${refreshedUser.uid}',
        );

        if (localFlag != null && localFlag.isNotEmpty) {
          print(
            '✅ Auth: Language found in local storage ("$localFlag"), going to home',
          );
          return const HomeScreen();
        }
      } catch (e) {
        print('⚠️ Auth: Error reading local storage: $e');
      }

      // Fallback to Firestore check
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(refreshedUser.uid)
            .get();

        final selectedLanguage = doc.data()?['selectedLanguage'] as String?;
        print('🔍 Auth: Checking Firestore for ${refreshedUser.uid}');
        print('🔍 Auth: Document exists = ${doc.exists}');
        print('🔍 Auth: Language = "$selectedLanguage"');

        if (selectedLanguage != null && selectedLanguage.isNotEmpty) {
          // Save to local storage for next time
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(
            '${_languageSelectedKey}_${refreshedUser.uid}',
            selectedLanguage,
          );
          print('✅ Auth: Language found ("$selectedLanguage"), going to home');
          return const HomeScreen();
        } else {
          print('✅ Auth: No language, going to selection');
          return const LanguageSelectionScreen();
        }
      } catch (e) {
        print('⚠️ Auth Error reading language: $e');
        return const LanguageSelectionScreen();
      }
    } else if (refreshedUser != null && !refreshedUser.emailVerified) {
      print('✅ Auth: Email not verified, going to verification');
      return const EmailVerificationScreen();
    }
  }

  print('✅ Auth: No user logged in, going to login');
  return const LoginScreen();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => LearningProvider()),
        ChangeNotifierProvider(create: (_) => GamificationProvider()),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(initialDarkMode: _initialDarkMode),
        ),
        ChangeNotifierProvider(create: (_) => AdaptiveQuizService()),
        ChangeNotifierProvider(create: (_) => AdaptiveLearningProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Urdu Punjabi Tutor',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            home: _AuthGate(),
            onGenerateRoute: (settings) {
              // Add page transitions to all routes
              Widget page;
              switch (settings.name) {
                case '/login':
                  page = const LoginScreen();
                  break;
                case '/signup':
                  page = const SignupScreen();
                  break;
                case '/email-verification':
                  page = const EmailVerificationScreen();
                  break;
                case '/language-selection':
                  page = const LanguageSelectionScreen();
                  break;
                case '/home':
                  page = const HomeScreen();
                  break;
                case '/ai-assistant':
                  page = const AIAssistantScreen();
                  break;
                default:
                  page = const LoginScreen();
              }

              return PageRouteBuilder(
                settings: settings,
                pageBuilder: (context, animation, secondaryAnimation) => page,
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0);
                      const end = Offset.zero;
                      const curve = Curves.easeInOutCubic;

                      var tween = Tween(
                        begin: begin,
                        end: end,
                      ).chain(CurveTween(curve: curve));
                      var offsetAnimation = animation.drive(tween);

                      return SlideTransition(
                        position: offsetAnimation,
                        child: FadeTransition(opacity: animation, child: child),
                      );
                    },
                transitionDuration: const Duration(milliseconds: 400),
              );
            },
            routes: {
              '/login': (context) => const LoginScreen(),
              '/signup': (context) => const SignupScreen(),
              '/email-verification': (context) =>
                  const EmailVerificationScreen(),
              '/language-selection': (context) =>
                  const LanguageSelectionScreen(),
              '/home': (context) => const HomeScreen(),
              '/ai-assistant': (context) => const AIAssistantScreen(),
            },
          );
        },
      ),
    );
  }
}

// Auth gate widget that shows appropriate screen based on auth state
class _AuthGate extends StatefulWidget {
  const _AuthGate();

  @override
  State<_AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<_AuthGate> {
  late Future<Widget> _initialScreenFuture;
  bool _providersLoaded = false;

  @override
  void initState() {
    super.initState();
    _initialScreenFuture = _determineInitialScreen();
  }

  Future<void> _loadProviders() async {
    if (_providersLoaded) return;
    _providersLoaded = true;

    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.emailVerified) {
      // Load user provider data
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.loadUserFromFirebase();

      // Load gamification data
      final gamificationProvider = Provider.of<GamificationProvider>(
        context,
        listen: false,
      );
      await gamificationProvider.loadFromFirestore();

      debugPrint('✓ Providers loaded on app start');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _initialScreenFuture,
      builder: (context, snapshot) {
        // No loading screen - just return the target screen immediately
        // Native splash will show during the brief wait
        if (snapshot.hasData) {
          // Load providers when we have the screen ready
          _loadProviders();
          return snapshot.data!;
        }

        if (snapshot.hasError) {
          return const LoginScreen();
        }

        // While waiting, show login screen (better than blank/green screen)
        return const LoginScreen();
      },
    );
  }
}
