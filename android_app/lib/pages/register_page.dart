import 'package:android_app/services/auth_service.dart';
import 'package:android_app/utils/account_validation.dart';
import 'package:android_app/utils/login_validation_error_localizer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:android_app/generated/l10n.dart';
import 'package:android_app/utils/avatar.dart';

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

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? errorUsername;
  String? errorEmail;
  String? errorPassword;
  String? errorConfirmPassword;
  String? errorAvatar;

  String? selectedAvatar;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final predefinedAvatars = [
    'avatar1',
    'avatar2',
    'avatar3',
    'avatar4',
    'avatar5',
    'avatar6',
    'avatar7',
    'avatar8',
    'avatar9',
    'avatar10',
    'avatar11',
    'avatar12',
  ];

  Future<void> signup() async {
    final username = _usernameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    setState(() {
      errorUsername = validateUsername(context, username);
      errorEmail = validateEmail(context, email);
      errorPassword = validatePassword(context, password);
      errorConfirmPassword =
          confirmPassword != password ? S.of(context).password_mismatch : null;
      errorAvatar = selectedAvatar == null ? S.of(context).error_avatar : null;
    });

    if ([
      errorUsername,
      errorEmail,
      errorPassword,
      errorConfirmPassword,
      errorAvatar
    ].any((e) => e != null)) {
      return;
    }

    final authService = ref.read(authServiceProvider);
    final signUpError = await authService.signup(
      username,
      email,
      password,
      avatar: selectedAvatar!,
    );

    if (!signUpError.hasError) {
      if (!mounted) return;
      context.go('/home');
      return;
    }

    setState(() {
      errorUsername = signUpError.usernameError.isNotEmpty
          ? getLocalizedError(signUpError.usernameError, context)
          : null;
      errorEmail =
          signUpError.emailError.isNotEmpty ? signUpError.emailError : null;
      errorPassword = signUpError.passwordError.isNotEmpty
          ? signUpError.passwordError
          : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: lemonTheme,
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: _buildFormCard(context),
                    ),
                  ),
                  Expanded(child: _buildAvatarPicker()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormCard(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 24),
            Text(
              S.of(context).register_title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 32),
            _buildInputField(_usernameController, S.of(context).username_label,
                errorUsername),
            const SizedBox(height: 20),
            _buildInputField(_emailController, S.of(context).email_label,
                errorEmail,
                keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 20),
            _buildInputField(_passwordController, S.of(context).password_label,
                errorPassword,
                obscureText: _obscurePassword,
                toggleObscure: () =>
                    setState(() => _obscurePassword = !_obscurePassword)),
            const SizedBox(height: 20),
            _buildInputField(
                _confirmPasswordController,
                S.of(context).confirm_password_label,
                errorConfirmPassword,
                obscureText: _obscureConfirmPassword,
                toggleObscure: () => setState(
                    () => _obscureConfirmPassword = !_obscureConfirmPassword)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: signup,
                child: Text(
                  S.of(context).signup_button,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(S.of(context).already_have_account),
                GestureDetector(
                  onTap: () => context.go('/login'),
                  child: Text(
                    " ${S.of(context).login_here}",
                    style: const TextStyle(
                        color: Colors.teal, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarPicker() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        height: errorAvatar != null ? 650 : 575,
        child: Card(
          elevation: 6,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  S.of(context).choose_avatar,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.teal, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: predefinedAvatars.map((avatarId) {
                        final isSelected = avatarId == selectedAvatar;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => selectedAvatar = avatarId),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isSelected
                                    ? Colors.teal
                                    : Colors.transparent,
                                width: 3,
                              ),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(4),
                            child: CircleAvatar(
                              radius: 40,
                              backgroundImage:
                                  NetworkImage(getAvatarSource(avatarId, ref)),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                if (errorAvatar != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      errorAvatar!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
    TextEditingController controller,
    String label,
    String? error, {
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    VoidCallback? toggleObscure,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          decoration: InputDecoration(
            labelText: label,
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 18),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    error,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
