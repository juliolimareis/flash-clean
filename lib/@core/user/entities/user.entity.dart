import 'package:flash_clean/@core/common/entities/entity.dart';

class UserEntity extends Entity {
  int cash;
  int ticket;
  int energy;
  DateTime lastUpdatedEnergy;

  UserEntity({
    super.id,
    super.createdAt,
    super.updatedAt,
    required this.cash,
    required this.ticket,
    required this.energy,
    String? lastUpdatedEnergy,
  }) : lastUpdatedEnergy = lastUpdatedEnergy == null
           ? DateTime.now()
           : DateTime.parse(lastUpdatedEnergy);

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cash': cash,
      'ticket': ticket,
      'energy': energy,
      'createdAt': createdAt.toIso8601String(),
      'lastUpdatedEnergy': lastUpdatedEnergy.toIso8601String(),
    };
  }

  setEnergy(int energy) {
    this.energy = energy;
    this.lastUpdatedEnergy = DateTime.now();
  }

  setCash(int cash) {
    this.cash = cash;
  }

  factory UserEntity.fromMap(Map<String, dynamic> map) {
    return UserEntity(
      id: map['id'],
      cash: map['cash'],
      ticket: map['ticket'],
      energy: map['energy'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      lastUpdatedEnergy: map['lastUpdatedEnergy'],
    );
  }
}
