class ParticipantModel {
  final String id;
  final String name;
  final String? phoneNumber;
  final double amountOwed;
  final bool hasPaid;
  final String? paymentTransactionId;

  ParticipantModel({
    required this.id,
    required this.name,
    this.phoneNumber,
    required this.amountOwed,
    this.hasPaid = false,
    this.paymentTransactionId,
  });

  ParticipantModel copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    double? amountOwed,
    bool? hasPaid,
    String? paymentTransactionId,
  }) {
    return ParticipantModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      amountOwed: amountOwed ?? this.amountOwed,
      hasPaid: hasPaid ?? this.hasPaid,
      paymentTransactionId: paymentTransactionId ?? this.paymentTransactionId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'amountOwed': amountOwed,
      'hasPaid': hasPaid,
      'paymentTransactionId': paymentTransactionId,
    };
  }

  factory ParticipantModel.fromMap(Map<String, dynamic> map) {
    return ParticipantModel(
      id: map['id'],
      name: map['name'],
      phoneNumber: map['phoneNumber'],
      amountOwed: map['amountOwed']?.toDouble() ?? 0.0,
      hasPaid: map['hasPaid'] ?? false,
      paymentTransactionId: map['paymentTransactionId'],
    );
  }
}
