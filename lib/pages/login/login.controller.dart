import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flash_clean/services/supabase.auth.dart';

class LoginController extends GetxController {
  final loginController = TextEditingController();
  final passwordController = TextEditingController();

  final supabaseAuth = SupabaseAuth();

  Future<void> login() async {
    final login = loginController.text.trim();
    final password = passwordController.text.trim();

    if (login.isEmpty || password.isEmpty) {
      Get.snackbar(
        "Message",
        "Please fill in all fields.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
      );

      return;
    }

    final res = await supabaseAuth.signIn(login, password);

    if (res.authResponse == null) {
      Get.snackbar(
        "Message",
        res.message,
        duration: const Duration(seconds: 6),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange[500],
        colorText: Colors.white,
      );

      return;
    }

    Get.snackbar(
      "Message",
      "Login successful! Let's clean up!",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green[400],
      colorText: Colors.white,
    );

    Get.offAllNamed('/home');
  }
}
