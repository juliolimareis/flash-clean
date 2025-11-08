import "package:flash_clean/@core/common/entities/entity.dart";

class Card extends Entity {
  int time;
  String desc;
  String title;
  String tagName;
  int daysToExpire;

  Card({
    super.id,
    super.updatedAt,
    required this.title,
    required this.desc,
    required this.daysToExpire,
    required this.time,
    required this.tagName,
  });

  int get remainingDaysToExpire {
    final expirationDate = createdAt.add(Duration(days: daysToExpire));
    final difference = expirationDate.difference(DateTime.now()).inDays;
    return difference > 0 ? difference : 0;
  }

  double get expirationPercentage {
    if (daysToExpire <= 0) {
      return 100.0;
    }

    final daysPassed = DateTime.now().difference(createdAt).inDays;

    if (daysPassed >= daysToExpire) {
      return 100.0;
    }
    return (daysPassed / daysToExpire) * 100;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "desc": desc,
      "time": time,
      "title": title,
      "tagName": tagName,
      "daysToExpire": daysToExpire,
      "updatedAt": createdAt.toIso8601String(),
      "createdAt": updatedAt?.toIso8601String(),
    };
  }

  String? propsDateToString(DateTime? date) {
    return date?.toIso8601String();
  }
}
