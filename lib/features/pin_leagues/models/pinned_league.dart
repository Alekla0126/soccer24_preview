import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'pinned_league.g.dart';

@HiveType(typeId: 1)
class PinnedLeague extends HiveObject with EquatableMixin {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;

  PinnedLeague({required this.id, required this.name});

  @override
  List<Object?> get props => [id];
}
