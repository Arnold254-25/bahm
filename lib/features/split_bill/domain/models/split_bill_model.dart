import 'package:bahm/features/split_bill/domain/models/participant_model.dart';

enum SplitType {
  equal,
  custom,
  percentage,
}

class SplitBillModel {
  final String id;
  final String title;
  final double totalAmount;
  final SplitType splitType;
  final DateTime createdAt;
  final String creatorId;
  final List<ParticipantModel> participants;
  final bool isSettled;

  SplitBillModel({
    required this.id,
    required this.title,
    required this.totalAmount,
    required this.splitType,
    required this.createdAt,
    required this.creatorId,
    required this.participants,
    this.isSettled = false,
  });

  double get amountCollected {
    return participants
        .where((p) => p.hasPaid)
        .fold(0.0, (sum, p) => sum + p.amountOwed);
  }

  double get amountRemaining {
    return totalAmount - amountCollected;
  }

  bool get isFullyPaid {
    return amountRemaining <= 0;
  }

  SplitBillModel copyWith({
    String? id,
    String? title,
    double? totalAmount,
    SplitType? splitType,
    DateTime? createdAt,
    String? creatorId,
    List<ParticipantModel>? participants,
    bool? isSettled,
  }) {
    return SplitBillModel(
      id: id ?? this.id,
      title: title ?? this.title,
      totalAmount: totalAmount ?? this.totalAmount,
      splitType: splitType ?? this.splitType,
      createdAt: createdAt ?? this.createdAt,
      creatorId: creatorId ?? this.creatorId,
      participants: participants ?? this.participants,
      isSettled: isSettled ?? this.isSettled,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'totalAmount': totalAmount,
      'splitType': splitType.index,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'creatorId': creatorId,
      'participants': participants.map((p) => p.toMap()).toList(),
      'isSettled': isSettled,
    };
  }

  factory SplitBillModel.fromMap(Map<String, dynamic> map) {
    return SplitBillModel(
      id: map['id'],
      title: map['title'],
      totalAmount: map['totalAmount']?.toDouble() ?? 0.0,
      splitType: SplitType.values[map['splitType'] ?? 0],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      creatorId: map['creatorId'],
      participants: List<ParticipantModel>.from(
        map['participants']?.map((x) => ParticipantModel.fromMap(x)) ?? [],
      ),
      isSettled: map['isSettled'] ?? false,
    );
  }
}
