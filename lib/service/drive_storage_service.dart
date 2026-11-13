import 'dart:io';

import 'package:googleapis/drive/v3.dart' as drive;

class DriveStorageService {
  Future<Map<String, String>> uploadProfileImage({
    required drive.DriveApi driveApi,
    required File imageFile,
    required String userId,
  }) async {
    final driveFile = drive.File()
      ..name = 'profile_${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg'
      ..mimeType = 'image/jpeg';
    final fileLength = await imageFile.length();
    final media = drive.Media(imageFile.openRead(), fileLength);
    final uploadedFile = await driveApi.files.create(
      driveFile,
      uploadMedia: media,
      $fields: 'id',
    );

    final fileId = uploadedFile.id;
    if (fileId == null) {
      throw Exception("Google drive did not return a file ID");
    }

    final permission = drive.Permission()
      ..type = 'anyone'
      ..role = 'reader';
    await driveApi.permissions.create(permission, fileId);

    final profileUrl =
        'https://lh3.googleusercontent.com/d/$fileId=w500?authuser=0';

    return {'fileId': fileId, 'profileUrl': profileUrl};
  }
}
