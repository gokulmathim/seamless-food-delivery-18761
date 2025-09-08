import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/login_screen.dart';
import '../home/home_shell.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/ui_helpers.dart';

class OnboardingScreen extends StatelessWidget {
  static const routeName = '/onboarding';
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isAuthed = context.select((AuthProvider p) => p.isAuthenticated);

    if (isAuthed) {
      // Defer navigation to post-frame to avoid analyzer warnings and async context pitfalls
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!Navigator.of(context).mounted) return;
        Navigator.of(context).pushReplacementNamed(HomeShell.routeName);
      });
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [scheme.primary.withAlpha(30), scheme.secondary.withAlpha(24)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                GlassCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Column(
                    children: [
                      Text(
                        'Seamless Food',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: scheme.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Browse restaurants, order your favorites, and track deliveries in real time.',
                        style: TextStyle(color: scheme.onSurface.withAlpha(190)),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                AnimatedTap(
                  onTap: () => Navigator.of(context).pushReplacementNamed(LoginScreen.routeName),
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pushReplacementNamed(LoginScreen.routeName),
                    child: const Text('Get Started'),
                  ),
                ),
                const SizedBox(height: 8),
                AnimatedTap(
                  onTap: () => Navigator.of(context).pushReplacementNamed(HomeShell.routeName),
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pushReplacementNamed(HomeShell.routeName),
                    child: const Text('Continue as Guest'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
