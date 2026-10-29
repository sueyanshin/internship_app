import 'package:flutter/material.dart';
import 'package:job_app/core/theme/app_colors.dart';
import 'package:job_app/screens/login_screen.dart';
import 'package:job_app/screens/main_screen.dart';
import 'package:job_app/screens/providers/app_auth_provider.dart';
import 'package:job_app/widgets/app_button.dart';
import 'package:job_app/widgets/app_text_field.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          SizedBox(
            height: 200,
            child: Image.asset(
              'assets/images/sign_up_banner.jpeg',
              fit: .cover,
            ),
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
                  // Name
                  AppTextField(
                    controller: _nameController,
                    labelText: "Full Name",
                    hintText: "Enter your full name",
                    isPassword: false,
                    prefixIcon: Icons.person_outline_rounded,
                    keyboardType: .name,
                    textInputAction: .next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

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

                  // Phone Number
                  AppTextField(
                    controller: _phoneController,
                    labelText: 'Phone Number',
                    extraLabelText: '(Optional)',
                    hintText: '+959123456789',
                    isPassword: false,
                    keyboardType: .phone,
                    textInputAction: .next,
                    prefixIcon: Icons.phone_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Password
                  AppTextField(
                    controller: _passwordController,
                    labelText: 'Password',
                    hintText: 'Create a password',
                    keyboardType: .visiblePassword,
                    textInputAction: .next,
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
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Confirm Password
                  AppTextField(
                    controller: _confirmPasswordController,
                    labelText: 'Confirm Password',
                    hintText: 'Re-enter your password',
                    keyboardType: .visiblePassword,
                    textInputAction: .done,
                    isPassword: !_isConfirmPasswordVisible,
                    prefixIcon: Icons.lock_outline_rounded,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
                        });
                      },
                      icon: Icon(
                        _isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter confirm password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Consumer<AppAuthProvider>(
                    builder: (context, provider, child) {
                      return AppButton(
                        title: provider.isLoading
                            ? 'Creating account...'
                            : 'Create Account →',
                        onPressed: provider.isLoading
                            ? null
                            : () async {
                                if (!_formKey.currentState!.validate()) return;

                                final error = await provider.signUp(
                                  _emailController.text.trim(),
                                  _passwordController.text.trim(),
                                );
                                if (!context.mounted) return;

                                if (error != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(error.toString())),
                                  );
                                } else {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MainScreen(),
                                    ),
                                  );
                                }
                              },
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  LabelWithDivider(label: 'Or sign up with'),
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
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: .center,
                    children: [
                      Text('Already have an account?'),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Login',
                          style: theme.textTheme.bodySmall!.copyWith(
                            color: AppColors.primary,
                            fontWeight: .w700,
                          ),
                        ),
                      ),
                    ],
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
