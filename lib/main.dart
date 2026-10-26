import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/firebase_options.dart';
import 'package:first_app/screens/auth_screen.dart';
import 'package:first_app/screens/splash_screen.dart';
import 'package:first_app/screens/grocery_home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FreshMart Grocery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: const Color(0xFF1E824C),
          primary: const Color(0xFF2ECC71),
          surface: const Color(0xFF1A261E),
        ),
        scaffoldBackgroundColor: const Color(0xFF101912),
        cardColor: const Color(0xFF1F2D24),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF142017),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: const Color(0xFF142017),
          indicatorColor: const Color(0xFF1E824C).withValues(alpha: 0.3),
        ),
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          // Still waiting for auth status
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }

          // User is authenticated → launch Grocery Booking App
          if (snapshot.hasData) {
            return const GroceryHomeScreen();
          }

          // Not authenticated → launch Login & Signup Page
          return const AuthScreen();
        },
      ),
    );
  }
}