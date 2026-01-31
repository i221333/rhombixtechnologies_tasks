import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/provider.dart';
import '../utils/theme.dart'; // Assuming your theme is here

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final provider = context.read<AppProvider>();
    final success = await provider.login(_usernameController.text.trim());

    if (!mounted) return;
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login failed. Please try again.')),
      );
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          // 1. Background "Spotlight" Decor
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    theme.colorScheme.primary.withOpacity(0.2),
                    theme.colorScheme.primary.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 2. Modern Logo Branding
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: Icon(
                          Icons.auto_awesome_mosaic_rounded,
                          size: 64,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // 3. Gradient Title
                      ShaderMask(
                        shaderCallback: (bounds) => AppTheme.gradients['midnight']!.createShader(bounds),
                        child: Text(
                          'ART LAB',
                          style: theme.textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1.5,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        'Join the global digital gallery.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white60,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 54),

                      // 4. Clean Input Field
                      TextFormField(
                        controller: _usernameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Enter username',
                          prefixIcon: Icon(Icons.alternate_email_rounded,
                              color: theme.colorScheme.primary.withOpacity(0.7)),
                        ),
                        validator: (value) => (value == null || value.trim().isEmpty)
                            ? 'Please enter a username' : null,
                      ),
                      const SizedBox(height: 24),

                      // 5. Gradient Action Button
                      Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: AppTheme.gradients['midnight'],
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                            height: 24, width: 24,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                              : const Text(
                            'Explore Gallery',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                      Text(
                        'Instant Creative Access • Powered by ArtLab',
                        style: theme.textTheme.bodySmall?.copyWith(color: Colors.white38),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}