import 'package:flutter/material.dart';
import 'package:job_app/core/theme/app_colors.dart';
import 'package:job_app/screens/providers/app_auth_provider.dart';
import 'package:job_app/screens/signup_screen.dart';
import 'package:job_app/widgets/app_button.dart';
import 'package:job_app/widgets/app_text_field.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: ListView(
        children: [
          SizedBox(
            height: 200,
            child: Image.asset('assets/images/login_banner.jpeg', fit: .cover),
          ),
          Form(
            key: _formKey,
            child: Container(
              margin: .only(left: 20, right: 20, bottom: 20),
              padding: .all(20),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: .circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: .stretch,

                children: [
                  // Email Address
                  AppTextField(
                    controller: _emailController,
                    labelText: 'Email Address',
                    hintText: 'example@domain.com',
                    isPassword: false,
                    keyboardType: .emailAddress,
                    textInputAction: .next,
                    prefixIcon: Icons.email_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  // Password
                  AppTextField(
                    controller: _passwordController,
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    keyboardType: .visiblePassword,
                    textInputAction: .done,
                    isPassword: !_isPasswordVisible,
                    prefixIcon: Icons.lock_outline_rounded,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColors.textSecondary,
                      ),
                    ),

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Checkbox(
                        value: true,
                        onChanged: (value) {},
                        activeColor: AppColors.primaryLight,
                      ),
                      Expanded(
                        child: Text(
                          'Rememeber me',
                          style: theme.textTheme.labelMedium!.copyWith(
                            fontWeight: .w400,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      Text(
                        'Forgot password?',
                        style: theme.textTheme.labelMedium!.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Consumer<AppAuthProvider>(
                    builder: (context, provider, child) {
                      return AppButton(
                        title: provider.isLoading
                            ? "Logging in..."
                            : 'Log in →',
                        onPressed: provider.isLoading == true
                            ? null
                            : () async {
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }
                                final error = await provider.signIn(
                                  _emailController.text.trim(),
                                  _passwordController.text.trim(),
                                );

                                if (!context.mounted) return;

                                if (error != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(error.toString())),
                                  );
                                }
                              },
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  LabelWithDivider(label: 'Or continue with'),
                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      AppIconButton(
                        imageIconUrl: 'assets/images/google-logo.jpg',
                        title: 'Google',
                      ),
                      const SizedBox(width: 10),
                      AppIconButton(
                        imageIconUrl: 'assets/images/apple-logo.png',
                        title: "Apple",
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: .all(16),
                    decoration: BoxDecoration(
                      borderRadius: .circular(12),
                      color: Colors.blue.shade100.withValues(alpha: 0.4),
                    ),
                    child: Row(
                      crossAxisAlignment: .start,
                      children: [
                        Icon(Icons.school, color: AppColors.primary, size: 35),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: .start,
                          children: [
                            Text(
                              'New to InternHub?',
                              style: theme.textTheme.titleSmall!.copyWith(
                                fontWeight: .w600,
                              ),
                            ),
                            const SizedBox(height: 10),

                            Text(
                              'Join our community and discover \nexciting internship opportunities.',
                              style: theme.textTheme.bodySmall!.copyWith(
                                fontWeight: .w300,
                              ),
                            ),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => SignUpScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'Create an Account →',
                                style: theme.textTheme.labelMedium!.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LabelWithDivider extends StatelessWidget {
  const new({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(child: Divider(height: 1, thickness: 0.8, endIndent: 10)),
        Text(
          label,
          style: theme.textTheme.bodySmall!.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Expanded(child: Divider(height: 1, thickness: 0.8, indent: 10)),
      ],
    );
  }
}

class AppIconButton extends StatelessWidget {
  const new({super.key, required this.imageIconUrl, required this.title});

  final String imageIconUrl;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          padding: .all(14),
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: .circular(12)),
        ),
        child: Row(
          mainAxisAlignment: .center,
          crossAxisAlignment: .center,
          children: [
            Image.asset(imageIconUrl, width: 20),
            const SizedBox(width: 4),
            Text(title),
          ],
        ),
      ),
    );
  }
}
