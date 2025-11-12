import "package:flash_clean/@core/common/entities/entity.dart";

class TaskEntity extends Entity {
  int time;
  String? desc;
  String title;
  String tagName;
  int daysToExpire;
  String? imageUrlBackground;
  String? imageUrlSide;

  late DateTime lastRuleUpdated;

  TaskEntity({
    super.id,
    super.updatedAt,
    super.createdAt,
    required this.title,
    required this.daysToExpire,
    required this.time,
    required this.tagName,
    this.desc,
    this.imageUrlSide,
    this.imageUrlBackground,
    String? lastRuleUpdated,
  }) {
    this.lastRuleUpdated = lastRuleUpdated == null
        ? DateTime.now()
        : DateTime.parse(lastRuleUpdated);
  }

  int get remainingDaysToExpire {
    final expirationDate = lastRuleUpdated.add(Duration(days: daysToExpire));
    final difference = expirationDate.difference(DateTime.now()).inDays;
    return difference > 0 ? difference : 0;
  }

  double get expirationPercentage {
    if (daysToExpire <= 0) {
      return 100.0;
    }

    final daysPassed = DateTime.now().difference(lastRuleUpdated).inDays;

    if (daysPassed >= daysToExpire) {
      return 100.0;
    }

    return (daysPassed / daysToExpire) * 100;
  }

  void touchLastRuleUpdated() {
    lastRuleUpdated = DateTime.now();
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "desc": desc,
      "time": time,
      "title": title,
      "tagName": tagName,
      "daysToExpire": daysToExpire,
      "imageUrlSide": imageUrlSide,
      "imageUrlBackground": imageUrlBackground,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
      "lastRuleUpdated": lastRuleUpdated.toIso8601String(),
    };
  }

  factory TaskEntity.fromMap(Map<String, dynamic> map) {
    return TaskEntity(
      id: map['id'],
      desc: map['desc'],
      time: map['time'],
      title: map['title'],
      tagName: map['tagName'],
      updatedAt: map['updatedAt'],
      createdAt: map['createdAt'],
      daysToExpire: map['daysToExpire'],
      imageUrlSide: map['imageUrlSide'],
      lastRuleUpdated: map['lastRuleUpdated'],
      imageUrlBackground: map['imageUrlBackground'],
    );
  }
}
