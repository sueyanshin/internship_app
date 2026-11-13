import 'dart:io';

import 'package:flutter/material.dart';
import 'package:job_app/screens/providers/app_auth_provider.dart';
import 'package:job_app/widgets/app_button.dart';
import 'package:provider/provider.dart';

class UploadProfileImageScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: // Profile Image
      Consumer<AppAuthProvider>(
        builder: (context, provider, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: .center,
              crossAxisAlignment: .stretch,
              children: [
                GestureDetector(
                  onTap: () {
                    provider.pickImage();
                  },
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: provider.pickedImage != null
                        ? FileImage(File(provider.pickedImage!.path))
                        : null,
                    child: provider.pickedImage == null
                        ? Icon(Icons.add_a_photo)
                        : null,
                  ),
                ),
                const SizedBox(height: 40),
                AppButton(
                  title: provider.isImageUploading ? 'Uploading...' : 'Upload',
                  onPressed: () async {
                    provider.isImageUploading
                        ? null
                        : await provider.saveImage();
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
