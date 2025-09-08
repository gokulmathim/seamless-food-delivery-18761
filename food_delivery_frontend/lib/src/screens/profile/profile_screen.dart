import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../navigation/app_router.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  static const routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(auth.user?.name ?? 'Guest'),
            subtitle: Text(auth.user?.email ?? 'Sign in for a better experience'),
            trailing: auth.isAuthenticated
                ? TextButton(
                    onPressed: () => context.read<AuthProvider>().logout(),
                    child: const Text('Logout'),
                  )
                : TextButton(
                    onPressed: () => Navigator.of(context).pushNamed(LoginScreen.routeName),
                    child: const Text('Login'),
                  ),
          ),
          const Divider(),
          const _SectionTitle('Payments'),
          ListTile(
            leading: const Icon(Icons.credit_card),
            title: const Text('Manage payment methods'),
            subtitle: const Text('Placeholder - integrate with payment provider in backend'),
            onTap: () {},
          ),
          const Divider(),
          const _SectionTitle('Settings'),
          SwitchListTile(
            value: true,
            onChanged: (_) {},
            title: const Text('Order notifications'),
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help & Support'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy Policy'),
            onTap: () {},
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'App Routing: ${AppRouter.initialRoute}',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withAlpha(150)),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }
}
