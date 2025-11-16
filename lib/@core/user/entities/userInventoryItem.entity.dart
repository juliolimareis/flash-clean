import "package:flash_clean/@core/item/entities/Item.entity.dart";
import "package:flash_clean/@core/item/entities/userItem.entity.dart";

class UserInventoryItemEntity extends UserItemEntity {
  ItemEntity item;

  UserInventoryItemEntity({
    super.id,
    super.createdAt,
    super.isActive,
    super.expirationDays = 0,
    required this.item,
    required super.userId,
    required super.itemId,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "userId": userId,
      "itemId": itemId,
      "isActive": isActive,
      "expirationDays": expirationDays,
      "createdAt": createdAt.toIso8601String(),
    };
  }

  factory UserInventoryItemEntity.fromMap(Map<String, dynamic> map) {
    return UserInventoryItemEntity(
      id: map['id'],
      userId: map['userId'],
      itemId: map['itemId'],
      createdAt: map['createdAt'],
      isActive: map['isActive'] ?? false,
      item: ItemEntity.fromMap(map['item']),
      expirationDays: map['expirationDays'],
    );
  }
}
