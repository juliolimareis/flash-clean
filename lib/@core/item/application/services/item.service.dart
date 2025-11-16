import 'package:flash_clean/@core/item/entities/Item.entity.dart';
import 'package:flash_clean/@core/item/infra/item.repository.dart';
import 'package:flash_clean/@core/item/entities/userItem.entity.dart';
import 'package:flash_clean/@core/item/infra/userItem.repository.dart';
import 'package:flash_clean/@core/common/infra/drvers/supabase.database.driver.dart';
import 'package:flash_clean/@core/user/entities/userInventoryItem.entity.dart';

class ItemService {
  late final ItemRepository _itemRepository;
  late final UserItemRepository _userItemRepository;

  ItemService({
    required ItemRepository itemRepository,
    required UserItemRepository userItemRepository,
  }) {
    _userItemRepository = userItemRepository;
    _itemRepository = itemRepository;
  }

  Future<ItemEntity?> getItemById(String id) async {
    return _itemRepository.fetchById(id);
  }

  Future<List<UserInventoryItemEntity>> getUserItemsInventory(
    String userId,
  ) async {
    final inventoryItems = <UserInventoryItemEntity>[];

    final userItems = await _userItemRepository.fetch(
      FindOptions(
        where: [
          FilterCondition(field: 'userId', operator: 'eq', value: userId),
        ],
      ),
    );

    for (UserItemEntity userItem in userItems) {
      final item = await this.getItemById(userItem.itemId);

      if (item != null) {
        inventoryItems.add(
          UserInventoryItemEntity.fromMap({
            ...userItem.toMap(),
            "item": item.toMap(),
          }),
        );
      }
    }

    return inventoryItems;
  }

  Future<List<ItemEntity>> getStoreItems() async {
    return _itemRepository.fetch(
      FindOptions(
        where: [
          FilterCondition(
            field: 'isAvailableInStore',
            operator: 'eq',
            value: true,
          ),
        ],
      ),
    );
  }

  Future<void> updateItem(ItemEntity user) async {
    return _itemRepository.update(user);
  }

  Future<void> updateUserItem(UserItemEntity userItem) async {
    return _userItemRepository.update(userItem);
  }

  Future<UserItemEntity> addUserItem(UserItemEntity userItem) async {
    return _userItemRepository.create(userItem);
  }

  Future<void> removeUserItem(String id) async {
    return _userItemRepository.remove(id);
  }
}
