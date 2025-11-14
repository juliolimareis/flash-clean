import 'package:flash_clean/@core/common/entities/entity.dart';

class UserItemEntity extends Entity {
  final String userId;
  final String itemId;
  final bool isActive;

  UserItemEntity({
    super.id,
    super.createdAt,
    super.updatedAt,
    required this.userId,
    required this.itemId,
    this.isActive = false,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'itemId': itemId,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory UserItemEntity.fromMap(Map<String, dynamic> map) {
    return UserItemEntity(
      id: map['id'],
      userId: map['userId'],
      itemId: map['itemId'],
    );
  }
}
