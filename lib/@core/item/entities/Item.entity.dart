import "package:flash_clean/@core/common/entities/entity.dart";

// ignore: constant_identifier_names
enum ItemType { WALLPAPER, SKIN, ARTEFACT }

class Item extends Entity {
  int price;
  int ticket;
  String desc;
  String title;
  ItemType type;
  String imageUrl;
  int daysToExpire;

  Item({
    super.id,
    super.updatedAt,
    required this.type,
    required this.desc,
    required this.price,
    required this.title,
    required this.ticket,
    required this.imageUrl,
    required this.daysToExpire,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "desc": desc,
      "title": title,
      "price": price,
      "ticket": ticket,
      "type": type.name,
      "imageUrl": imageUrl,
      "daysToExpire": daysToExpire,
      "updatedAt": createdAt.toIso8601String(),
      "createdAt": updatedAt?.toIso8601String(),
    };
  }

  String? propsDateToString(DateTime? date) {
    return date?.toIso8601String();
  }
}
