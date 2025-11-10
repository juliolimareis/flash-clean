import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuth {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<SupabaseAuthResponse> signIn(String email, String password) async {
    String message = "";

    try {
      final AuthResponse response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      return SupabaseAuthResponse(
        message: 'Login bem-sucedido!',
        authResponse: response,
      );
    } on AuthException catch (e) {
      message = _getFriendlyError(e.message);
    } catch (e) {
      print('Erro inesperado: $e');
    }

    return SupabaseAuthResponse(message: message);
  }

  String _getFriendlyError(String message) {
    if (message.contains('Invalid login credentials')) {
      return 'Invalid login credentials';
    }

    if (message.contains('Email not confirmed')) {
      return 'Email not confirmed';
    }

    return 'An unknown error occurred';
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  User? getCurrentUser() {
    return _supabase.auth.currentUser;
  }

  bool isLoggedIn() {
    return _supabase.auth.currentUser != null;
  }
}

class SupabaseAuthResponse {
  late final String message;
  late final AuthResponse? authResponse;

  SupabaseAuthResponse({required this.message, this.authResponse});
}
