abstract class Entity {
  final String? id;
  DateTime? _createdAt;
  DateTime? _updatedAt;

  Entity({this.id, String? createdAt, String? updatedAt}) {
    if (createdAt == null) {
      _createdAt = DateTime.now();
    } else {
      _createdAt = DateTime.parse(createdAt);
    }

    if (updatedAt == null) {
      _updatedAt = _createdAt;
    } else {
      _updatedAt = DateTime.parse(updatedAt);
    }
  }

  DateTime get createdAt => _createdAt as DateTime;
  DateTime get updatedAt => _updatedAt as DateTime;

  touch() {
    _updatedAt = DateTime.now();
  }

  Map<String, dynamic> toMap();
}
