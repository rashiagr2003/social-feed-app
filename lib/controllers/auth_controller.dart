import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user_model.dart';
import '../utils/sharred_pref_service.dart';

class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  AuthController() : super(AuthState()) {
    _checkAuthStatus();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  void _checkAuthStatus() {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      final user = _mapFirebaseUser(firebaseUser);
      state = state.copyWith(user: user, isAuthenticated: true);
    }
  }

  // 🔹 Email / Password Login
  Future<void> signIn(String email, String password) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = _mapFirebaseUser(result.user!);
      await _saveSession(user);

      state = state.copyWith(
        user: user,
        isAuthenticated: true,
        isLoading: false,
      );
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    }
  }

  Future<void> signUp(String email, String password, String name) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await result.user!.updateDisplayName(name);

      // Map Firebase user to your UserModel
      final user = _mapFirebaseUser(result.user!);

      // Save user session locally
      await _saveSession(user);

      // ✅ Update state with authenticated user
      state = state.copyWith(
        user: user,
        isAuthenticated: true,
        isLoading: false,
      );
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    }
  }

  // 🔹 Google Sign In
  Future<void> signInWithGoogle() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        state = state.copyWith(isLoading: false);
        return;
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final result = await _auth.signInWithCredential(credential);

      final user = _mapFirebaseUser(result.user!);
      await _saveSession(user);

      state = state.copyWith(
        user: user,
        isAuthenticated: true,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Google sign-in failed');
    }
  }

  // 🔹 Logout
  Future<void> signOut() async {
    try {
      state = state.copyWith(isLoading: true);

      await _auth.signOut();
      await _googleSignIn.signOut();
      await SharedPrefUtils.clearUserSession();

      state = AuthState();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // 🔹 Helpers
  UserModel _mapFirebaseUser(User user) {
    return UserModel(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? 'User',
      photoUrl: user.photoURL,
      username:
          '@${(user.displayName ?? 'user').toLowerCase().replaceAll(' ', '')}',
    );
  }

  Future<void> _saveSession(UserModel user) async {
    await SharedPrefUtils.saveUserSession(
      userId: user.id,
      email: user.email,
      name: user.name,
      photoUrl: user.photoUrl,
    );
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) => AuthController(),
);

final currentUserProvider = Provider<UserModel?>(
  (ref) => ref.watch(authControllerProvider).user,
);

final isAuthenticatedProvider = Provider<bool>(
  (ref) => ref.watch(authControllerProvider).isAuthenticated,
);
