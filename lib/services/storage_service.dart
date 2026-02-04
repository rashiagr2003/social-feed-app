import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class LocalStorageService {
  /// Save image to local app directory
  /// Returns the saved file path, or null if failed
  Future<String?> saveImage(File image) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = '${timestamp}_${path.basename(image.path)}';
      final newFile = await image.copy(path.join(dir.path, fileName));
      return newFile.path;
    } catch (e) {
      // Handle errors (e.g., permissions, disk full)
      print('Error saving image: $e');
      return null;
    }
  }

  Future<bool> deleteImage(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false; // file not found
    } catch (e) {
      // Handle errors (e.g., permissions)
      print('Error deleting image: $e');
      return false;
    }
  }

  /// Check if a file exists
  Future<bool> fileExists(String filePath) async {
    try {
      final file = File(filePath);
      return await file.exists();
    } catch (e) {
      print('Error checking file existence: $e');
      return false;
    }
  }

  /// Get app documents directory path
  Future<String> getAppDirPath() async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }
}
