import 'package:flash_clean/pages/home/home.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

bool isHomeControllerRegistered() {
  try {
    return Get.isRegistered<HomeController>();
  } catch (e) {
    return false;
  }
}

class FlashCleanAppBar extends StatelessWidget implements PreferredSizeWidget {
  FlashCleanAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      titleSpacing: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: CircleAvatar(
          backgroundColor: Colors.grey,
          child: const Icon(Icons.person, color: Colors.white, size: 30),
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Flash',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          const Icon(Icons.flash_on, color: Colors.orange, size: 35),
          const Text(
            'Clean',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      actions: [
        if (isHomeControllerRegistered())
          GetBuilder<HomeController>(
            init: Get.find<HomeController>(),
            builder: (controller) => GestureDetector(
              onTap: controller.goToStore,
              child: Row(
                children: [
                  const Icon(
                    Icons.monetization_on,
                    color: Colors.orange,
                    size: 30,
                  ),
                  const SizedBox(width: 4),
                  Obx(
                    () => Text(
                      controller.cashLabel(),
                      style: TextStyle(color: Colors.black, fontSize: 23),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
              ),
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
