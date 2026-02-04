import 'package:shared_preferences/shared_preferences.dart';

/// Utility class for handling local storage using SharedPreferences
class SharedPrefUtils {
  static SharedPreferences? _prefs;

  // Keys
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyUserId = 'user_id';
  static const String keyUserEmail = 'user_email';
  static const String keyUserName = 'user_name';
  static const String keyUserPhoto = 'user_photo';
  static const String keyThemeMode = 'theme_mode';
  static const String keyOnboardingComplete = 'onboarding_complete';

  /// Initialize SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Get SharedPreferences instance
  static SharedPreferences get instance {
    if (_prefs == null) {
      throw Exception('SharedPreferences not initialized. Call init() first.');
    }
    return _prefs!;
  }

  // Generic methods

  /// Save string value
  static Future<bool> setString(String key, String value) async {
    return await instance.setString(key, value);
  }

  /// Get string value
  static String? getString(String key) {
    return instance.getString(key);
  }

  /// Save int value
  static Future<bool> setInt(String key, int value) async {
    return await instance.setInt(key, value);
  }

  /// Get int value
  static int? getInt(String key) {
    return instance.getInt(key);
  }

  /// Save bool value
  static Future<bool> setBool(String key, bool value) async {
    return await instance.setBool(key, value);
  }

  /// Get bool value
  static bool? getBool(String key) {
    return instance.getBool(key);
  }

  /// Save double value
  static Future<bool> setDouble(String key, double value) async {
    return await instance.setDouble(key, value);
  }

  /// Get double value
  static double? getDouble(String key) {
    return instance.getDouble(key);
  }

  /// Save string list
  static Future<bool> setStringList(String key, List<String> value) async {
    return await instance.setStringList(key, value);
  }

  /// Get string list
  static List<String>? getStringList(String key) {
    return instance.getStringList(key);
  }

  /// Remove specific key
  static Future<bool> remove(String key) async {
    return await instance.remove(key);
  }

  /// Clear all data
  static Future<bool> clear() async {
    return await instance.clear();
  }

  /// Check if key exists
  static bool containsKey(String key) {
    return instance.containsKey(key);
  }

  // App-specific methods

  /// Check if user is logged in
  static bool get isLoggedIn {
    return getBool(keyIsLoggedIn) ?? false;
  }

  /// Set login status
  static Future<bool> setLoggedIn(bool value) async {
    return await setBool(keyIsLoggedIn, value);
  }

  /// Get current user ID
  static String? get currentUserId {
    return getString(keyUserId);
  }

  /// Set current user ID
  static Future<bool> setUserId(String userId) async {
    return await setString(keyUserId, userId);
  }

  /// Get user email
  static String? get userEmail {
    return getString(keyUserEmail);
  }

  /// Set user email
  static Future<bool> setUserEmail(String email) async {
    return await setString(keyUserEmail, email);
  }

  /// Get user name
  static String? get userName {
    return getString(keyUserName);
  }

  /// Set user name
  static Future<bool> setUserName(String name) async {
    return await setString(keyUserName, name);
  }

  /// Get user photo URL
  static String? get userPhoto {
    return getString(keyUserPhoto);
  }

  /// Set user photo URL
  static Future<bool> setUserPhoto(String photoUrl) async {
    return await setString(keyUserPhoto, photoUrl);
  }

  /// Check if onboarding is complete
  static bool get isOnboardingComplete {
    return getBool(keyOnboardingComplete) ?? false;
  }

  /// Set onboarding complete
  static Future<bool> setOnboardingComplete(bool value) async {
    return await setBool(keyOnboardingComplete, value);
  }

  /// Save user session
  static Future<void> saveUserSession({
    required String userId,
    required String email,
    required String name,
    String? photoUrl,
  }) async {
    await setLoggedIn(true);
    await setUserId(userId);
    await setUserEmail(email);
    await setUserName(name);
    if (photoUrl != null) {
      await setUserPhoto(photoUrl);
    }
  }

  /// Clear user session
  static Future<void> clearUserSession() async {
    await remove(keyIsLoggedIn);
    await remove(keyUserId);
    await remove(keyUserEmail);
    await remove(keyUserName);
    await remove(keyUserPhoto);
  }
}
