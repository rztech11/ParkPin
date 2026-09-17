import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ImageHelper {
  static final ImagePicker _picker = ImagePicker();

  /// Take a photo using device camera and save to app document directory
  static Future<String?> capturePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1080,
      );
      if (photo == null) return null;
      return await _persistImageLocally(photo);
    } catch (e) {
      return null;
    }
  }

  /// Pick image from gallery and save to app document directory
  static Future<String?> pickFromGallery() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1080,
      );
      if (photo == null) return null;
      return await _persistImageLocally(photo);
    } catch (e) {
      return null;
    }
  }

  /// Copy image to permanent app documents directory
  static Future<String> _persistImageLocally(XFile imageFile) async {
    final appDir = await getApplicationDocumentsDirectory();
    final parkingPhotosDir = Directory(p.join(appDir.path, 'parking_photos'));
    if (!await parkingPhotosDir.exists()) {
      await parkingPhotosDir.create(recursive: true);
    }

    final String fileName = 'parking_${DateTime.now().millisecondsSinceEpoch}${p.extension(imageFile.path).isNotEmpty ? p.extension(imageFile.path) : '.jpg'}';
    final String targetPath = p.join(parkingPhotosDir.path, fileName);
    final File savedFile = await File(imageFile.path).copy(targetPath);
    return savedFile.path;
  }

  /// Delete image from disk when history record is deleted
  static Future<void> deleteImage(String? path) async {
    if (path == null || path.isEmpty) return;
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {}
  }
}
