import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../navigation/app_router.dart';
import '../auth/login_screen.dart';
import '../home/home_shell.dart';
import '../../providers/auth_provider.dart';

class OnboardingScreen extends StatelessWidget {
  static const routeName = '/onboarding';
  OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isAuthed = context.select((AuthProvider p) => p.isAuthenticated);
    if (isAuthed) {
      Future.microtask(() => Navigator.of(context).pushReplacementNamed(HomeShell.routeName));
    }
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              const Text(
                'Seamless Food',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Browse restaurants, order your favorites, and track deliveries in real time.',
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withAlpha(190)),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              FilledButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
                },
                child: const Text('Get Started'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(HomeShell.routeName);
                },
                child: const Text('Continue as Guest'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
