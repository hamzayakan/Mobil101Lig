import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/league_entity.dart';

/// Firestore lig modeli.
class LeagueModel {
  const LeagueModel({
    required this.id,
    required this.name,
    required this.ownerId,
    required this.maxPlayers,
    required this.status,
    this.createdAt,
  });

  final String id;
  final String name;
  final String ownerId;
  final int maxPlayers;
  final String status;
  final DateTime? createdAt;

  factory LeagueModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return LeagueModel(
      id: doc.id,
      name: data['name'] as String? ?? '',
      ownerId: data['ownerId'] as String? ?? '',
      maxPlayers: (data['maxPlayers'] as num?)?.toInt() ?? 20,
      status: data['status'] as String? ?? 'active',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore({FieldValue? createdAt}) {
    return {
      'name': name,
      'ownerId': ownerId,
      'maxPlayers': maxPlayers,
      'status': status,
      'createdAt': createdAt ?? Timestamp.fromDate(createdAtDate),
    };
  }

  DateTime get createdAtDate => createdAt ?? DateTime.now();

  LeagueEntity toEntity() {
    return LeagueEntity(
      id: id,
      name: name,
      ownerId: ownerId,
      maxPlayers: maxPlayers,
      status: status,
      createdAt: createdAt,
    );
  }
}
