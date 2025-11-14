import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flash_clean/pages/home/home.page.dart';
import 'package:flash_clean/services/supabase.auth.dart';
import 'package:flash_clean/pages/login/login.page.dart';

class InitPage extends StatefulWidget {
  const InitPage({super.key});

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Animação simples de pulsar o ícone do raio
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    Future.delayed(const Duration(seconds: 1), () {
      if (SupabaseAuth().isLoggedIn()) {
        Get.off(() => HomePage());
      } else {
        Get.off(() => LoginPage());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Flash",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                ScaleTransition(
                  scale: _animation,
                  child: const Icon(
                    Icons.bolt,
                    color: Color(0xFFFFA260),
                    size: 36,
                  ),
                ),
                const Text(
                  "Clean",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              "loading ...",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
