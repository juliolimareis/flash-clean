import "package:flash_clean/@core/common/entities/entity.dart";

class UserItemEntity extends Entity {
  String userId;
  String itemId;
  bool isActive;
  int? expirationDays;

  UserItemEntity({
    super.id,
    super.createdAt,
    required this.userId,
    required this.itemId,
    this.isActive = false,
    this.expirationDays = 0,
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

  get isExpired {
    if (expirationDays == null) {
      return false;
    }

    final now = DateTime.now();
    final expirationDate = createdAt.add(Duration(days: expirationDays!));

    return now.isAfter(expirationDate);
  }

  factory UserItemEntity.fromMap(Map<String, dynamic> map) {
    return UserItemEntity(
      id: map['id'],
      userId: map['userId'],
      itemId: map['itemId'],
      createdAt: map['createdAt'],
      isActive: map['isActive'],
      expirationDays: map['expirationDays'],
    );
  }
}
