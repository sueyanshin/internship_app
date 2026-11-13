import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:job_app/screens/providers/app_auth_provider.dart';
import 'package:job_app/widgets/app_button.dart';
import 'package:job_app/widgets/app_text_field.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppAuthProvider>().fetchUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AppAuthProvider>().userProfile;
    _emailController.text = user!.email.toString();
    _phoneController.text = user.phone.toString();
    _nameController.text = user.name.toString();

    return Scaffold(
      appBar: AppBar(title: Text('Edit profile')),
      body: SingleChildScrollView(
        padding: .symmetric(horizontal: 16, vertical: 8),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Consumer<AppAuthProvider>(
                builder: (context, provider, child) {
                  final hasPickedImage = provider.pickedImage != null;
                  final hasNetworkImage =
                      user.profileUrl != null && user.profileUrl!.isNotEmpty;

                  return GestureDetector(
                    onTap: () {
                      provider.pickImage();
                    },
                    child: CircleAvatar(
                      radius: 80,
                      child: ClipOval(
                        child: SizedBox(
                          width: 160,
                          height: 160,
                          child: hasPickedImage
                              ? Image.file(
                                  File(provider.pickedImage!.path),
                                  fit: BoxFit.cover,
                                )
                              : hasNetworkImage
                              ? CachedNetworkImage(
                                  imageUrl: user.profileUrl!,
                                  fit: BoxFit.cover,
                                  httpHeaders: const {
                                    "User-Agent": "Mozilla/5.0",
                                  },
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) {
                                    debugPrint("Image load error: $error");
                                    return const Icon(
                                      Icons.add_a_photo,
                                      size: 40,
                                    );
                                  },
                                )
                              : const Icon(Icons.add_a_photo, size: 40),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
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
                isEnabled: false,
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
              Consumer<AppAuthProvider>(
                builder: (context, provider, child) {
                  return SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      title: provider.isLoading && provider.isImageUploading
                          ? 'Saving...'
                          : 'Save',
                      onPressed: provider.isLoading
                          ? null
                          : () async {
                              if (!_formKey.currentState!.validate()) return;

                              await provider.updateUserProfile(
                                user.uid,
                                _nameController.text,
                                _phoneController.text,
                                user.email,
                              );
                              await provider.saveImage();

                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
