import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const SwifitApp());
}

class SwifitApp extends StatelessWidget {
  const SwifitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SWIFIT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: const OnboardingScreen(),
    );
  }
}
