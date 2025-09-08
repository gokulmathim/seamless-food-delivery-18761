import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../home/home_shell.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailC = TextEditingController();
  final _passwordC = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailC.dispose();
    _passwordC.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final ok = await auth.login(_emailC.text.trim(), _passwordC.text);
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pushReplacementNamed(HomeShell.routeName);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login failed.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final loading = context.select((AuthProvider p) => p.isLoading);
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _emailC,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => v != null && v.contains('@') ? null : 'Enter a valid email',
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passwordC,
                  obscureText: _obscure,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  validator: (v) => v != null && v.length >= 6 ? null : 'Min 6 chars',
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: loading ? null : _submit,
                  child: Text(loading ? 'Signing in...' : 'Sign In'),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(RegisterScreen.routeName);
                  },
                  child: const Text('Create an account'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
