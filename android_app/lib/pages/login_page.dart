import 'package:android_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:android_app/generated/l10n.dart';
import 'package:android_app/utils/login_validation_error_localizer.dart';

final ThemeData lemonTheme = ThemeData(
  useMaterial3: false,
  fontFamily: 'Roboto',
  colorScheme: ColorScheme.light(
    primary: Colors.teal,
    secondary: Colors.lime[600]!,
    error: Colors.green[700]!,
    surface: const Color(0xFFDFFFDE),
  ),
  scaffoldBackgroundColor: const Color(0xFFDFFFDE),
  textTheme: const TextTheme().apply(
    fontFamily: 'Roboto',
    bodyColor: Colors.black87,
    displayColor: Colors.black,
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Colors.teal,
    selectionColor: Colors.tealAccent,
    selectionHandleColor: Colors.teal,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Colors.teal,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      textStyle: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    filled: true,
    fillColor: Colors.white,
  ),
);



class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _error;
  bool _obscurePassword = true;

  Future<void> _login() async {
    setState(() {
      _error = null;
    });
    final authService = ref.read(authServiceProvider);
    final result = await authService.login(
      _usernameController.text,
      _passwordController.text,
    );

    if (!mounted) return;

    if (result.isEmpty) {
      context.go('/home');
    } else {
      setState(() => _error = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: lemonTheme,
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Card(
                margin: const EdgeInsets.all(20),
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 24),
                      Text(
                        S.of(context).login_title,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 32),
                      _buildInputField(
                        controller: _usernameController,
                        label: S.of(context).username_label,
                      ),
                      const SizedBox(height: 20),
                      _buildPasswordField(),
                      const SizedBox(height: 24),
                      _buildLoginButton(),
                      if (_error != null) _buildErrorWidget(),
                      const SizedBox(height: 16),
                      _buildRegistrationLink(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.teal, width: 2),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: S.of(context).password_label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.teal, width: 2),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          S.of(context).login_button,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
  if (_error == null) return const SizedBox.shrink();

  final errorText = getLocalizedError(_error!, context);

  return Padding(
    padding: const EdgeInsets.only(top: 12),
    child: Row(
      children: [
        const Icon(Icons.error_outline, color: Colors.red, size: 18),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            errorText,
            style: const TextStyle(color: Colors.red, fontSize: 14),
          ),
        ),
      ],
    ),
  );
}

  Widget _buildRegistrationLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(S.of(context).no_account),
        GestureDetector(
          onTap: () => context.go('/register'),
          child: Text(
            " ${S.of(context).create_account}",
            style: const TextStyle(
                color: Colors.teal, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
