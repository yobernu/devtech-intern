import 'package:equatable/equatable.dart';

class Player extends Equatable {
  final String id;
  final String originalName;
  final String assignedName;
  final String symbol; // 'X' or 'O'
  final String? avatarPath;

  const Player({
    required this.id,
    required this.originalName,
    required this.assignedName,
    required this.symbol,
    this.avatarPath,
  });

  @override
  List<Object?> get props => [
    id,
    originalName,
    assignedName,
    symbol,
    avatarPath,
  ];

  Player copyWith({
    String? id,
    String? originalName,
    String? assignedName,
    String? symbol,
    String? avatarPath,
  }) {
    return Player(
      id: id ?? this.id,
      originalName: originalName ?? this.originalName,
      assignedName: assignedName ?? this.assignedName,
      symbol: symbol ?? this.symbol,
      avatarPath: avatarPath ?? this.avatarPath,
    );
  }
}
