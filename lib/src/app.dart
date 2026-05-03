import 'package:flutter/material.dart';
import 'package:iteco_test_zadanie/src/presentation/views/feed_screen.dart';
import 'package:iteco_test_zadanie/src/presentation/views/onboarding_screen.dart';
import 'package:iteco_test_zadanie/src/presentation/views/splash_screen.dart';

class ItecoApp extends StatelessWidget {
  const ItecoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Iteco Test',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (_) => const SplashScreen(),
        OnboardingScreen.routeName: (_) => const OnboardingScreen(),
        FeedScreen.routeName: (_) => const FeedScreen(),
      },
    );
  }
}
