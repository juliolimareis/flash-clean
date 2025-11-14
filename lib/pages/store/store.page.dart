import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flash_clean/pages/store/store.controller.dart';
import 'package:flash_clean/pages/home/components/home-appbar.component.dart';

class StorePage extends StatelessWidget {
  final controller = Get.put(StoreController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FlashCleanAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: .78,
          children: [
            _StoreItem(
              title: "Killua",
              price: 10,
              imagePath: "assets/images/sides/side_01.png",
            ),
            _StoreItem(
              title: "RR",
              price: 10,
              imagePath:
                  "assets/images/cards_backgrounds/cards_backgrounds_01.jpg",
            ),
            // _StoreItem(
            //   title: "DBZ",
            //   price: 10,
            //   imagePath: "assets/images/icon/app_icon.png",
            // ),
            // _StoreItem(
            //   title: "YGO",
            //   price: 10,
            //   imagePath:
            //       "assets/images/cards_backgrounds/cards_backgrounds_01.jpg",
            // ),
            // _StoreItem(
            //   title: "Diamo",
            //   price: 10,
            //   imagePath:
            //       "assets/images/cards_backgrounds/cards_backgrounds_01.jpg",
            // ),
            // _StoreItem(
            //   title: "K. Thu",
            //   price: 10,
            //   imagePath:
            //       "assets/images/cards_backgrounds/cards_backgrounds_01.jpg",
            // ),
          ],
        ),
      ),
    );
  }
}

/// -----------------------------------------------------------------------
/// COMPONENTE DE ITEM
/// -----------------------------------------------------------------------
class _StoreItem extends StatelessWidget {
  final String title;
  final int price;
  final String imagePath;

  final controller = Get.find<StoreController>();

  _StoreItem({
    required this.title,
    required this.price,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isSelected = (controller.selectedItem.value == title);

      return Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.green : Colors.black12,
            width: isSelected ? 3 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Expanded(child: Image.asset(imagePath, fit: BoxFit.contain)),
            SizedBox(height: 6),
            Text(title, style: TextStyle(fontSize: 16)),
            SizedBox(height: 4),
            Text("💰 $price"),
            SizedBox(height: 4),
            ElevatedButton(
              onPressed: () => controller.buyItem(title),
              style: ElevatedButton.styleFrom(
                backgroundColor: isSelected
                    ? Colors.green
                    : Colors.amber.shade200,
                foregroundColor: Colors.black,
              ),
              child: Text(isSelected ? "Selecionado" : "Buy"),
            ),
            SizedBox(height: 8),
          ],
        ),
      );
    });
  }
}
