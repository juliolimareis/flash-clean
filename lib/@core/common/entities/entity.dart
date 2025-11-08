abstract class Entity {
  final String? id;
  DateTime? _createdAt;
  DateTime? _updatedAt;

  Entity({this.id, String? updatedAt, String? createdAt}) {
    if (createdAt == null || createdAt.isEmpty) {
      _createdAt = DateTime.now();
    } else {
      _createdAt = DateTime.parse(createdAt);
    }
  }

  DateTime get createdAt => _createdAt as DateTime;
  DateTime? get updatedAt => _updatedAt;

  touch() {
    _updatedAt = DateTime.now();
  }

  Map<String, dynamic> toJson();
}
