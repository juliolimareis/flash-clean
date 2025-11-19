import "package:flash_clean/@core/common/entities/entity.dart";

// ignore: constant_identifier_names
enum ItemType { SKIN, SIDE, ARTEFACT, PROFILE }

class ItemEntity extends Entity {
  int price;
  int ticket;
  String desc;
  String title;
  int discount;
  ItemType type;
  String imageUrl;
  int expirationDays;
  bool isAvailableInStore;

  ItemEntity({
    super.id,
    super.createdAt,
    required this.type,
    required this.desc,
    required this.price,
    required this.title,
    required this.ticket,
    required this.imageUrl,
    required this.expirationDays,
    this.discount = 0,
    this.isAvailableInStore = false,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "desc": desc,
      "title": title,
      "price": price,
      "ticket": ticket,
      "discount": discount,
      "imageUrl": imageUrl,
      "type": itemTypeToInt(type),
      "expirationDays": expirationDays,
      "isAvailableInStore": isAvailableInStore,
      "createdAt": createdAt.toIso8601String(),
    };
  }

  factory ItemEntity.fromMap(Map<String, dynamic> map) {
    return ItemEntity(
      id: map['id'],
      title: map['title'],
      desc: map['desc'],
      price: map['price'],
      ticket: map['ticket'] ?? 0,
      imageUrl: map['imageUrl'],
      createdAt: map['createdAt'],
      discount: map['discount'] ?? 0,
      type: itemTypeFromInt(map['type']),
      expirationDays: map['expirationDays'],
      isAvailableInStore: map['isAvailableInStore'],
    );
  }

  int itemTypeToInt(ItemType type) {
    return type.index;
  }

  static ItemType itemTypeFromInt(int value) {
    return ItemType.values[value];
  }

  String getTypeName() {
    switch (type) {
      case ItemType.SKIN:
        return "Skin";
      case ItemType.SIDE:
        return "Side";
      case ItemType.ARTEFACT:
        return "Artefact";
      case ItemType.PROFILE:
        return "Profile";
    }
  }
}
