import "package:flash_clean/@core/common/entities/entity.dart";

// ignore: constant_identifier_names
enum ItemType { WALLPAPER, SKIN, ARTEFACT }

class ItemEntity extends Entity {
  int price;
  int ticket;
  String desc;
  String title;
  ItemType type;
  String imageUrl;
  int expireDays;

  ItemEntity({
    super.id,
    super.updatedAt,
    required this.type,
    required this.desc,
    required this.price,
    required this.title,
    required this.ticket,
    required this.imageUrl,
    required this.expireDays,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "desc": desc,
      "title": title,
      "price": price,
      "ticket": ticket,
      "type": itemTypeToInt(type),
      "imageUrl": imageUrl,
      "expireDays": expireDays,
      "createdAt": createdAt.toIso8601String(),
    };
  }

  factory ItemEntity.fromMap(Map<String, dynamic> map) {
    return ItemEntity(
      id: map['id'],
      title: map['title'],
      desc: map['desc'],
      price: map['price'],
      ticket: map['ticket'],
      type: itemTypeFromInt(map['type']),
      imageUrl: map['imageUrl'],
      expireDays: map['expireDays'],
      updatedAt: map['createdAt'],
    );
  }

  int itemTypeToInt(ItemType type) {
    return type.index;
  }

  static ItemType itemTypeFromInt(int value) {
    return ItemType.values[value];
  }
}
