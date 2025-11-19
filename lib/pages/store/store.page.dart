import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flash_clean/pages/store/store.controller.dart';
import 'package:flash_clean/@core/item/entities/Item.entity.dart';
import 'package:flash_clean/pages/home/components/home-appbar.component.dart';

class StorePage extends StatelessWidget {
  final controller = Get.put(StoreController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: FlashCleanAppBar(),
        body: TabBarView(
          children: [
            _buildItemGrid(controller.skinItems),
            _buildItemGrid(controller.sideItems),
          ],
        ),
      ),
    );
  }

  Widget _buildItemGrid(RxList<ItemEntity> items) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Obx(
        () => items.isEmpty
            ? Center(
                child: CircularProgressIndicator(color: Colors.orangeAccent),
              )
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: .78,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return StoreItem(item: items[index]);
                },
              ),
      ),
    );
  }
}

class StoreItem extends StatelessWidget {
  final ItemEntity item;

  final controller = Get.find<StoreController>();

  StoreItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isSelected = (controller.selectedItem.value?.id == item.id);
      bool isOwned = controller.userHaveThisItem(item);
      bool hasCache = controller.hasCash(item);
      bool isActive = controller.isItemActive(item);

      return Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.green : Colors.black12,
            width: isSelected ? 3 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () => controller.selectItem(item),
          child: Column(
            children: [
              Expanded(child: Image.asset(item.imageUrl, fit: BoxFit.contain)),
              SizedBox(height: 6),
              Text(item.title, style: TextStyle(fontSize: 16)),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.type_specimen, size: 20, color: Colors.green),
                  SizedBox(width: 4),
                  Text("${item.getTypeName().toUpperCase()}"),
                ],
              ),
              SizedBox(height: 4),
              Text(
                "💰 ${item.price}",
                style: TextStyle(
                  fontSize: 17,
                  color: hasCache ? Colors.black : Colors.black87,
                ),
              ),

              SizedBox(height: 4),

              Visibility(
                visible: !isOwned,
                child: ElevatedButton(
                  onPressed: () {
                    if (hasCache) {
                      controller.selectItem(item);
                      onDialogItem();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: hasCache
                        ? Colors.orangeAccent
                        : Colors.grey.shade400,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text(
                    "Buy",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Visibility(
                visible: isOwned && !isActive,
                child: ElevatedButton(
                  onPressed: () {
                    controller.activeItem(item, true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text(
                    "Active",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Visibility(
                visible: isOwned && isActive,
                child: ElevatedButton(
                  onPressed: () {
                    controller.activeItem(item, false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text(
                    "Activated",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 5),
            ],
          ),
        ),
      );
    });
  }

  void onDialogItem() {
    final item = controller.selectedItem.value;
    if (item == null) return;

    Get.dialog(
      AlertDialog(
        title: Text('Confirm purchase', textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(item.imageUrl, height: 100, fit: BoxFit.contain),
            SizedBox(height: 16),
            Text(
              item.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.type_specimen, size: 24, color: Colors.green),
                SizedBox(width: 4),
                Text(
                  "${item.getTypeName().toUpperCase()}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text("💰 ${item.price}", style: TextStyle(fontSize: 20)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 18),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.buyItem();
            },
            child: Text('Confirm'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
